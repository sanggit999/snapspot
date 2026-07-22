from django import forms
from django.contrib.auth.forms import AuthenticationForm

class CustomAdminAuthenticationForm(AuthenticationForm):
    """
    Custom Admin Authentication Form bóc tách riêng tầng Presentation (UI Form)
    hiển thị nhãn Tiếng Việt 'Địa chỉ Email hoặc Tên người dùng'
    """
    username = forms.CharField(
        label="Địa chỉ Email hoặc Tên người dùng",
        widget=forms.TextInput(attrs={
            'autofocus': True,
            'placeholder': 'Nhập Email hoặc Tên người dùng...'
        })
    )
