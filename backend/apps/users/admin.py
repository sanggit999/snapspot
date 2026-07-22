from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from apps.users.models import User, UserSession, SecurityAuditLog

@admin.register(User)
class CustomUserAdmin(BaseUserAdmin):
    list_display = (
        'id', 'username', 'email', 'phone_number', 'full_name', 
        'auth_provider', 'status', 'is_private', 'email_verified', 'is_staff', 'created_at'
    )
    list_filter = (
        'status', 'auth_provider', 'is_private', 'hide_exact_location', 
        'email_verified', 'phone_verified', 'is_2fa_enabled', 'is_staff', 'is_superuser', 'created_at'
    )
    search_fields = ('username', 'email', 'phone_number', 'full_name', 'google_id', 'apple_id')
    ordering = ('-created_at',)

    fieldsets = (
        ('Thông Tin Đăng Nhập Cơ Bản', {
            'fields': ('username', 'email', 'password', 'phone_number', 'full_name', 'avatar', 'bio')
        }),
        ('Đăng Nhập Mạng Xã Hội (Social Auth)', {
            'fields': ('auth_provider', 'google_id', 'apple_id')
        }),
        ('Quản Lý Trạng Thái Tài Khoản', {
            'fields': ('status', 'banned_until', 'ban_reason')
        }),
        ('Quyền Riêng Tư & Bảo Mặt', {
            'fields': (
                'is_private', 'hide_exact_location', 'email_verified', 'phone_verified', 
                'is_2fa_enabled', 'password_changed_at', 'pending_deletion_at'
            )
        }),
        ('Bộ Đếm Thống Kê (Counter Caching)', {
            'fields': ('posts_count', 'followers_count', 'following_count')
        }),
        ('Cài Đặt & Hoạt Động', {
            'fields': ('last_active_at', 'language', 'theme_mode', 'is_staff', 'is_active', 'is_superuser', 'groups', 'user_permissions')
        }),
    )

@admin.register(UserSession)
class UserSessionAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'device_name', 'ip_address', 'last_active_at', 'is_active')
    search_fields = ('user__email', 'user__username', 'device_name', 'ip_address')

@admin.register(SecurityAuditLog)
class SecurityAuditLogAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'event_type', 'ip_address', 'created_at')
    list_filter = ('event_type', 'created_at')
    search_fields = ('user__email', 'user__username', 'ip_address', 'event_type')
