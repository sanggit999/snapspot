import os
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

app = Celery('snapspot')

# Load cấu hình từ settings.py với prefix CELERY_
app.config_from_object('django.conf:settings', namespace='CELERY')

# Tự động đọc tất cả tasks.py trong các Django Apps
app.autodiscover_tasks()
