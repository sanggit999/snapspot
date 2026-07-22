from typing import Tuple, Dict, Any, Optional, cast
from django.utils import timezone
from rest_framework.exceptions import ValidationError, PermissionDenied, AuthenticationFailed
from rest_framework_simplejwt.tokens import RefreshToken, TokenError

from apps.users.models import User, AccountStatus, SecurityAuditEvent
from apps.users.repositories import UserRepository
from apps.users.mappers import user_model_to_domain, UserDomainEntity

class AuthService:
    """
    Business Logic Layer xử lý toàn bộ các quy trình Auth & Bảo mật tài khoản
    """

    @staticmethod
    def register_user(validated_data: Dict[str, Any], ip_address: Optional[str] = None, user_agent: str = "") -> UserDomainEntity:
        email = validated_data['email'].strip().lower()
        username = validated_data['username'].strip()
        password = validated_data['password']
        full_name = validated_data.get('full_name', '')

        # 1. Kiểm tra Email trùng lặp
        if UserRepository.get_by_email(email):
            raise ValidationError({"email": ["Email này đã được sử dụng."]})

        # 2. Kiểm tra Username trùng lặp
        if UserRepository.get_by_username(username):
            raise ValidationError({"username": ["Tên người dùng này đã được sử dụng."]})

        phone_number = validated_data.get('phone_number')

        # 3. Tạo tài khoản
        user_domain = UserRepository.create_user(
            email=email,
            username=username,
            password=password,
            full_name=full_name,
            phone_number=phone_number
        )


        # 4. Ghi Audit Log
        user_model = UserRepository.get_model_by_id(user_domain.id)
        UserRepository.create_audit_log(
            event_type=SecurityAuditEvent.LOGIN_SUCCESS,
            user=user_model,
            ip_address=ip_address,
            user_agent=user_agent,
            details={"action": "REGISTER_SUCCESS"}
        )

        return user_domain

    @staticmethod
    def login_user(validated_data: Dict[str, Any], ip_address: Optional[str] = None, user_agent: str = "") -> Tuple[Dict[str, str], UserDomainEntity]:

        email_or_username = validated_data['email_or_username'].strip()
        password = validated_data['password']

        # 1. Tìm user theo Email hoặc Username
        user = UserRepository.get_by_email(email_or_username)
        if not user:
            user = UserRepository.get_by_username(email_or_username)

        if not user or not user.check_password(password):
            UserRepository.create_audit_log(
                event_type=SecurityAuditEvent.LOGIN_FAILED,
                user=user if user else None,
                ip_address=ip_address,
                user_agent=user_agent,
                details={"identifier": email_or_username, "reason": "INVALID_CREDENTIALS"}
            )
            raise AuthenticationFailed("Tài khoản hoặc mật khẩu không chính xác.")

        # 2. Kiểm tra Trạng Thái Khóa Vĩnh Viễn
        if user.status == AccountStatus.PERMANENTLY_BANNED or not user.is_active:
            reason = user.ban_reason or "Tài khoản bị khóa do vi phạm điều khoản."
            UserRepository.create_audit_log(
                event_type=SecurityAuditEvent.ACCOUNT_SUSPENDED,
                user=user,
                ip_address=ip_address,
                user_agent=user_agent,
                details={"status": user.status, "reason": reason}
            )
            raise PermissionDenied(f"Tài khoản của bạn đã bị khóa vĩnh viễn. Lý do: {reason}. Liên hệ support@snapspot.com để biết thêm chi tiết.")

        # 3. Kiểm tra Trạng Thái Khóa Tạm Thời (Temporary Suspension)
        if user.status == AccountStatus.TEMPORARILY_SUSPENDED:
            if user.banned_until and timezone.now() < user.banned_until:
                formatted_until = user.banned_until.strftime('%Y-%m-%d %H:%M:%S UTC')
                reason = user.ban_reason or "Tạm khóa do vi phạm quy chuẩn cộng đồng."
                raise PermissionDenied(f"Tài khoản bị tạm khóa đến {formatted_until}. Lý do: {reason}.")
            else:
                # Tự động mở khóa nếu đã qua thời hạn banned_until
                UserRepository.set_account_status(user, AccountStatus.ACTIVE)

        # 4. Sinh cặp JWT Token
        refresh = RefreshToken.for_user(user)
        tokens = {
            "access_token": str(refresh.access_token),
            "refresh_token": str(refresh)
        }

        # 5. Ghi Audit Log
        UserRepository.create_audit_log(
            event_type=SecurityAuditEvent.LOGIN_SUCCESS,
            user=user,
            ip_address=ip_address,
            user_agent=user_agent,
            details={"action": "LOGIN_SUCCESS"}
        )

        return tokens, user_model_to_domain(user)

    @staticmethod
    def rotate_refresh_token(refresh_token_str: str) -> Dict[str, str]:
        """
        Xoay vòng Refresh Token (Refresh Token Rotation - RTR)
        """
        try:
            refresh = RefreshToken(cast(Any, refresh_token_str))
            data = {

                "access_token": str(refresh.access_token),
                "refresh_token": str(refresh)
            }

            # Thực hiện rotation token
            refresh.blacklist()
            return data
        except TokenError as e:
            raise AuthenticationFailed("Refresh token không hợp lệ hoặc đã hết hạn/đã qua sử dụng.")

    @staticmethod
    def change_password(user: User, validated_data: Dict[str, Any]) -> None:
        old_password = validated_data['old_password']
        new_password = validated_data['new_password']

        if not user.check_password(old_password):
            raise ValidationError({"old_password": ["Mật khẩu cũ không chính xác."]})

        UserRepository.update_password(user, new_password)
        UserRepository.create_audit_log(
            event_type=SecurityAuditEvent.PASSWORD_CHANGE,
            user=user,
            details={"action": "PASSWORD_CHANGED"}
        )
