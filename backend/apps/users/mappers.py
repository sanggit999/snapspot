from dataclasses import dataclass
from typing import Optional
from datetime import datetime
from apps.users.models import User, AccountStatus, AuthProvider

@dataclass
class UserDomainEntity:
    """
    Domain Entity cho User, hoàn toàn độc lập với Django ORM (Senior Standard).
    """
    id: int
    email: str
    username: str
    phone_number: Optional[str]
    full_name: str
    avatar_url: Optional[str]
    bio: str
    auth_provider: str
    status: str
    banned_until: Optional[datetime]
    ban_reason: Optional[str]
    email_verified: bool
    phone_verified: bool
    is_2fa_enabled: bool
    is_private: bool
    hide_exact_location: bool
    posts_count: int
    followers_count: int
    following_count: int
    last_active_at: Optional[datetime]
    language: str
    theme_mode: str
    is_active: bool
    created_at: datetime

def user_model_to_domain(user: User) -> UserDomainEntity:
    """Chuyển đổi từ Django ORM Model sang Domain Entity"""
    avatar_url = user.avatar.url if user.avatar else None
    return UserDomainEntity(
        id=user.id,
        email=user.email,
        username=user.username,
        phone_number=user.phone_number,
        full_name=user.full_name,
        avatar_url=avatar_url,
        bio=user.bio,
        auth_provider=user.auth_provider,
        status=user.status,
        banned_until=user.banned_until,
        ban_reason=user.ban_reason,
        email_verified=user.email_verified,
        phone_verified=user.phone_verified,
        is_2fa_enabled=user.is_2fa_enabled,
        is_private=user.is_private,
        hide_exact_location=user.hide_exact_location,
        posts_count=user.posts_count,
        followers_count=user.followers_count,
        following_count=user.following_count,
        last_active_at=user.last_active_at,
        language=user.language,
        theme_mode=user.theme_mode,
        is_active=user.is_active,
        created_at=user.created_at,
    )
