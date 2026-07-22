from django.contrib import admin
from django.urls import path, include
from apps.users.forms import CustomAdminAuthenticationForm

# Cấu hình giao diện và form đăng nhập cho Django Admin Portal (Presentation Layer)
admin.site.login_form = CustomAdminAuthenticationForm
admin.site.site_header = "SnapSpot Admin Portal"
admin.site.site_title = "SnapSpot Admin"
admin.site.index_title = "Quản Trị Hệ Thống SnapSpot"

urlpatterns = [
    path('admin/', admin.site.urls),
    # SnapSpot API V1 Auth endpoints
    path('api/v1/auth/', include('apps.users.urls')),
]
