from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    # SnapSpot API V1 Auth endpoints
    path('api/v1/auth/', include('apps.users.urls')),
]
