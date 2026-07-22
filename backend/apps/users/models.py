from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils import timezone

class AccountStatus(models.TextChoices):
    ACTIVE = 'ACTIVE', 'Hoạt động'
    PENDING_VERIFICATION = 'PENDING_VERIFICATION', 'Chờ xác thực Email/Phone'
    TEMPORARILY_SUSPENDED = 'TEMPORARILY_SUSPENDED', 'Tạm khóa'
    PERMANENTLY_BANNED = 'PERMANENTLY_BANNED', 'Khóa vĩnh viễn'
    PENDING_DELETION = 'PENDING_DELETION', 'Chờ xóa tài khoản'

class AuthProvider(models.TextChoices):
    LOCAL = 'LOCAL', 'Tài khoản thường (Email/Password)'
    GOOGLE = 'GOOGLE', 'Google Sign-In'
    APPLE = 'APPLE', 'Apple Sign-In'

class User(AbstractUser):
    """
    Custom User Model mở rộng cho SnapSpot Backend (Senior Standard 2026)
    Bao gồm các trường quản lý Auth, Social Login, Vị trí GPS Privacy, Counter Caching, 2FA.
    """
    # 1. Thông Tin Định Danh & Liên Lạc
    email = models.EmailField(verbose_name='Địa chỉ Email', unique=True)
    phone_number = models.CharField(verbose_name='Số điện thoại', max_length=20, unique=True, null=True, blank=True)
    full_name = models.CharField(verbose_name='Họ và tên', max_length=150, blank=True)
    avatar = models.ImageField(verbose_name='Ảnh đại diện', upload_to='avatars/', null=True, blank=True)
    bio = models.TextField(verbose_name='Tiểu sử', max_length=500, blank=True)

    # 2. Đăng Nhập Mạng Xã Hội (Social Auth - Google & Apple)
    auth_provider = models.CharField(
        verbose_name='Phương thức đăng nhập',
        max_length=20,
        choices=AuthProvider.choices,
        default=AuthProvider.LOCAL
    )
    google_id = models.CharField(verbose_name='Google ID', max_length=255, null=True, blank=True, unique=True)
    apple_id = models.CharField(verbose_name='Apple ID', max_length=255, null=True, blank=True, unique=True)

    # 3. Quản Lý Trạng Thái Tài Khoản & Khóa
    status = models.CharField(
        verbose_name='Trạng thái tài khoản',
        max_length=30,
        choices=AccountStatus.choices,
        default=AccountStatus.ACTIVE
    )
    banned_until = models.DateTimeField(verbose_name='Tạm khóa đến', null=True, blank=True)
    ban_reason = models.TextField(verbose_name='Lý do khóa', null=True, blank=True)
    
    # 4. Bảo Mật & Xác Thực (2FA, Email, Phone Verification)
    email_verified = models.BooleanField(verbose_name='Đã xác thực Email', default=False)
    phone_verified = models.BooleanField(verbose_name='Đã xác thực Số điện thoại', default=False)
    is_2fa_enabled = models.BooleanField(verbose_name='Bật bảo mật 2 lớp (2FA)', default=False)
    password_changed_at = models.DateTimeField(verbose_name='Thời điểm đổi mật khẩu', null=True, blank=True)
    pending_deletion_at = models.DateTimeField(verbose_name='Thời điểm yêu cầu xóa', null=True, blank=True)

    # 5. Quyền Riêng Tư & An Toàn Vị Trí (Location Privacy Settings)
    is_private = models.BooleanField(verbose_name='Tài khoản riêng tư', default=False, help_text='Chỉ bạn bè được duyệt mới xem được bài đăng & vị trí')
    hide_exact_location = models.BooleanField(verbose_name='Ẩn tọa độ GPS chính xác', default=False, help_text='Chỉ hiển thị tên địa danh/quận huyện, ẩn số nhà GPS')

    # 6. Bộ Đếm Counter Caching (Tối ưu hiệu năng Query Profile)
    posts_count = models.PositiveIntegerField(verbose_name='Số bài đăng', default=0)
    followers_count = models.PositiveIntegerField(verbose_name='Số người theo dõi', default=0)
    following_count = models.PositiveIntegerField(verbose_name='Số người đang theo dõi', default=0)

    # 7. Trạng Thái Hoạt Động & Cài Đặt Ứng Dụng
    last_active_at = models.DateTimeField(verbose_name='Hoạt động lần cuối', null=True, blank=True)
    language = models.CharField(verbose_name='Ngôn ngữ ứng dụng', max_length=10, default='vi')
    theme_mode = models.CharField(verbose_name='Chế độ giao diện', max_length=10, default='system')

    created_at = models.DateTimeField(verbose_name='Ngày tạo tài khoản', auto_now_add=True)
    updated_at = models.DateTimeField(verbose_name='Ngày cập nhật', auto_now=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    class Meta:
        verbose_name = 'Người dùng'
        verbose_name_plural = 'Danh sách người dùng'

    def is_currently_suspended(self) -> bool:
        """Kiểm tra tài khoản có đang nằm trong thời gian bị tạm khóa hay không"""
        if self.status == AccountStatus.TEMPORARILY_SUSPENDED:
            if self.banned_until and timezone.now() < self.banned_until:
                return True
        return False

    def __str__(self):
        return f"{self.username} ({self.email})"

class UserSession(models.Model):
    """
    Quản lý các phiên đăng nhập thiết bị di động / web
    """
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sessions', verbose_name='Người dùng')
    device_name = models.CharField(verbose_name='Tên thiết bị', max_length=100, blank=True)
    os_info = models.CharField(verbose_name='Hệ điều hành', max_length=100, blank=True)
    ip_address = models.GenericIPAddressField(verbose_name='Địa chỉ IP', null=True, blank=True)
    refresh_token_jti = models.CharField(verbose_name='Mã Refresh Token (JTI)', max_length=255, unique=True)
    last_active_at = models.DateTimeField(verbose_name='Hoạt động lần cuối', auto_now=True)
    is_active = models.BooleanField(verbose_name='Trạng thái phiên', default=True)
    created_at = models.DateTimeField(verbose_name='Ngày tạo phiên', auto_now_add=True)

    class Meta:
        verbose_name = 'Phiên đăng nhập'
        verbose_name_plural = 'Quản lý phiên đăng nhập'
        ordering = ['-last_active_at']

class SecurityAuditEvent(models.TextChoices):
    LOGIN_SUCCESS = 'LOGIN_SUCCESS', 'Đăng nhập thành công'
    LOGIN_FAILED = 'LOGIN_FAILED', 'Đăng nhập thất bại'
    PASSWORD_CHANGE = 'PASSWORD_CHANGE', 'Thay đổi mật khẩu'
    ACCOUNT_SUSPENDED = 'ACCOUNT_SUSPENDED', 'Tài khoản bị khóa'
    TOKEN_REUSE_DETECTED = 'TOKEN_REUSE_DETECTED', 'Phát hiện lạm dụng Token'
    ACCOUNT_DELETION_REQUESTED = 'ACCOUNT_DELETION_REQUESTED', 'Yêu cầu xóa tài khoản'
    TWO_FACTOR_VERIFIED = 'TWO_FACTOR_VERIFIED', 'Xác thực 2FA thành công'

class SecurityAuditLog(models.Model):
    """
    Lưu vết tất cả các sự kiện bảo mật Auth
    """
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='audit_logs', verbose_name='Người dùng')
    event_type = models.CharField(verbose_name='Loại sự kiện bảo mật', max_length=50, choices=SecurityAuditEvent.choices)
    ip_address = models.GenericIPAddressField(verbose_name='Địa chỉ IP', null=True, blank=True)
    user_agent = models.TextField(verbose_name='Trình duyệt / Thiết bị', blank=True)
    details = models.JSONField(verbose_name='Chi tiết sự kiện', default=dict, blank=True)
    created_at = models.DateTimeField(verbose_name='Thời điểm ghi nhận', auto_now_add=True)

    class Meta:
        verbose_name = 'Nhật ký bảo mật'
        verbose_name_plural = 'Nhật ký sự kiện bảo mật'
        ordering = ['-created_at']
