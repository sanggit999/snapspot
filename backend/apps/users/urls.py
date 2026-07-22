from django.urls import path
from apps.users.views import (
    RegisterAPIView,
    LoginAPIView,
    TokenRefreshAPIView,
    UserMeAPIView,
    ChangePasswordAPIView
)


urlpatterns = [
    path('register/', RegisterAPIView.as_view(), name='auth_register'),
    path('login/', LoginAPIView.as_view(), name='auth_login'),
    path('refresh/', TokenRefreshAPIView.as_view(), name='auth_refresh'),
    path('me/', UserMeAPIView.as_view(), name='auth_me'),
    path('change-password/', ChangePasswordAPIView.as_view(), name='auth_change_password'),
]
