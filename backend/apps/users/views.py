from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions

from core.throttling import AuthLoginRateThrottle, AuthRegisterRateThrottle, AuthPasswordResetRateThrottle
from apps.users.serializers import (
    RegisterInputSerializer,
    LoginInputSerializer,
    TokenRefreshInputSerializer,
    ChangePasswordInputSerializer,
    UserOutputSerializer,
    AuthTokenOutputSerializer
)
from apps.users.services import AuthService
from apps.users.mappers import user_model_to_domain

def get_client_ip(request) -> str:
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip

class RegisterAPIView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_classes = [AuthRegisterRateThrottle]

    def post(self, request):
        serializer = RegisterInputSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user_domain = AuthService.register_user(
            validated_data=serializer.validated_data,
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', '')
        )

        return Response(UserOutputSerializer(user_domain).data, status=status.HTTP_201_CREATED)

class LoginAPIView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_classes = [AuthLoginRateThrottle]

    def post(self, request):
        serializer = LoginInputSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        tokens, user_domain = AuthService.login_user(
            validated_data=serializer.validated_data,
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', '')
        )

        response_data = {
            "access_token": tokens["access_token"],
            "refresh_token": tokens["refresh_token"],
            "token_type": "Bearer",
            "user": user_domain
        }

        return Response(AuthTokenOutputSerializer(response_data).data, status=status.HTTP_200_OK)

class TokenRefreshAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = TokenRefreshInputSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        tokens = AuthService.rotate_refresh_token(
            refresh_token_str=serializer.validated_data['refresh_token']
        )

        return Response(tokens, status=status.HTTP_200_OK)

class UserMeAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user_domain = user_model_to_domain(request.user)
        return Response(UserOutputSerializer(user_domain).data, status=status.HTTP_200_OK)

class ChangePasswordAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        serializer = ChangePasswordInputSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        AuthService.change_password(
            user=request.user,
            validated_data=serializer.validated_data
        )

        return Response({"message": "Đổi mật khẩu thành công."}, status=status.HTTP_200_OK)
