from rest_framework import serializers

class RegisterInputSerializer(serializers.Serializer):
    email = serializers.EmailField(max_length=255)
    username = serializers.CharField(max_length=150, min_length=3)
    password = serializers.CharField(max_length=128, min_length=8, write_only=True)
    full_name = serializers.CharField(max_length=150, required=False, allow_blank=True, default="")
    phone_number = serializers.CharField(max_length=20, required=False, allow_blank=True, default=None)

class LoginInputSerializer(serializers.Serializer):
    email_or_username = serializers.CharField(max_length=255)
    password = serializers.CharField(max_length=128, write_only=True)

class TokenRefreshInputSerializer(serializers.Serializer):
    refresh_token = serializers.CharField()

class ChangePasswordInputSerializer(serializers.Serializer):
    old_password = serializers.CharField(max_length=128, write_only=True)
    new_password = serializers.CharField(max_length=128, min_length=8, write_only=True)

class UserOutputSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    email = serializers.EmailField()
    username = serializers.CharField()
    phone_number = serializers.CharField(allow_null=True)
    full_name = serializers.CharField()
    avatar_url = serializers.CharField(allow_null=True)
    bio = serializers.CharField()
    auth_provider = serializers.CharField()
    status = serializers.CharField()
    email_verified = serializers.BooleanField()
    phone_verified = serializers.BooleanField()
    is_2fa_enabled = serializers.BooleanField()
    is_private = serializers.BooleanField()
    hide_exact_location = serializers.BooleanField()
    posts_count = serializers.IntegerField()
    followers_count = serializers.IntegerField()
    following_count = serializers.IntegerField()
    last_active_at = serializers.DateTimeField(allow_null=True)
    language = serializers.CharField()
    theme_mode = serializers.CharField()
    created_at = serializers.DateTimeField()

class AuthTokenOutputSerializer(serializers.Serializer):
    access_token = serializers.CharField()
    refresh_token = serializers.CharField()
    token_type = serializers.CharField(default="Bearer")
    user = UserOutputSerializer()
