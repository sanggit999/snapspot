from rest_framework.throttling import AnonRateThrottle, UserRateThrottle  # type: ignore

class AuthLoginRateThrottle(AnonRateThrottle):
    """
    Giới hạn tần suất đăng nhập từ 1 IP hoặc tài khoản nhằm chống tấn công Brute-force.
    Mặc định: 5 lượt/phút.
    """
    scope = 'auth_login'

class AuthRegisterRateThrottle(AnonRateThrottle):
    """
    Giới hạn tần suất đăng ký tài khoản từ 1 IP.
    Mặc định: 5 lượt/giờ.
    """
    scope = 'auth_register'

class AuthPasswordResetRateThrottle(AnonRateThrottle):
    """
    Giới hạn tần suất yêu cầu đặt lại mật khẩu.
    Mặc định: 3 lượt/giờ.
    """
    scope = 'auth_password_reset'

class UserBurstRateThrottle(UserRateThrottle):
    """
    Giới hạn tần suất chung cho user đã xác thực.
    Mặc định: 60 lượt/phút.
    """
    scope = 'user_burst'
