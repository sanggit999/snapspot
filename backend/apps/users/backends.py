from typing import Optional, Any
from django.contrib.auth.backends import ModelBackend
from django.contrib.auth import get_user_model
from django.db.models import Q

User = get_user_model()

class EmailOrUsernameModelBackend(ModelBackend):
    """
    Custom Authentication Backend cho phép đăng nhập bằng cả Email HOẶC Username
    ở trang Django Admin Web UI lẫn REST API.
    """
    def authenticate(self, request: Any = None, username: Optional[str] = None, password: Optional[str] = None, **kwargs: Any) -> Optional[Any]:
        if username is None:
            username = kwargs.get('email') or kwargs.get('username')

        if not username or not password:
            return None

        try:
            # Tìm user theo Email HOẶC Username (không phân biệt chữ hoa/thường)
            user = User.objects.get(Q(email__iexact=username) | Q(username__iexact=username))
        except Exception:
            try:
                user = User.objects.filter(Q(email__iexact=username) | Q(username__iexact=username)).first()
            except Exception:
                return None

        if user and user.check_password(password) and self.user_can_authenticate(user):
            return user
        return None
