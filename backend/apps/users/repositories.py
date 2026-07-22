from typing import Optional, List, Any
from django.utils import timezone
from apps.users.models import User, UserSession, SecurityAuditLog, AccountStatus
from apps.users.mappers import user_model_to_domain, UserDomainEntity

class UserRepository:
    @staticmethod
    def get_by_id(user_id: int) -> Optional[UserDomainEntity]:
        try:
            user = User.objects.get(id=user_id)
            return user_model_to_domain(user)
        except User.DoesNotExist:
            return None

    @staticmethod
    def get_model_by_id(user_id: int) -> Optional[User]:
        try:
            return User.objects.get(id=user_id)
        except User.DoesNotExist:
            return None

    @staticmethod
    def get_by_email(email: str) -> Optional[User]:
        try:
            return User.objects.get(email__iexact=email)
        except User.DoesNotExist:
            return None

    @staticmethod
    def get_by_username(username: str) -> Optional[User]:
        try:
            return User.objects.get(username__iexact=username)
        except User.DoesNotExist:
            return None

    @staticmethod
    def create_user(email: str, username: str, password: str, full_name: str = "", phone_number: Optional[str] = None) -> UserDomainEntity:
        user = User.objects.create_user(
            email=email,
            username=username,
            password=password,
            full_name=full_name,
            phone_number=phone_number,
            status=AccountStatus.ACTIVE
        )
        return user_model_to_domain(user)


    @staticmethod
    def update_password(user: User, new_password: str) -> None:
        user.set_password(new_password)
        user.password_changed_at = timezone.now()
        user.save(update_fields=['password', 'password_changed_at'])

    @staticmethod
    def set_account_status(user: User, status: str, ban_reason: Optional[str] = None, banned_until: Optional[Any] = None) -> None:
        user.status = status
        user.ban_reason = ban_reason
        user.banned_until = banned_until
        user.save(update_fields=['status', 'ban_reason', 'banned_until'])

    @staticmethod
    def request_account_deletion(user: User) -> None:
        user.status = AccountStatus.PENDING_DELETION
        user.pending_deletion_at = timezone.now()
        user.save(update_fields=['status', 'pending_deletion_at'])

    @staticmethod
    def create_audit_log(event_type: str, user: Optional[User] = None, ip_address: Optional[str] = None, user_agent: str = "", details: Optional[dict] = None) -> None:
        SecurityAuditLog.objects.create(
            user=user,
            event_type=event_type,
            ip_address=ip_address,
            user_agent=user_agent,
            details=details or {}
        )
