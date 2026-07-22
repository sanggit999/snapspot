#!/bin/sh

# Đợi Database PostgreSQL sẵn sàng kết nối
if [ "$USE_POSTGRES" = "True" ] || [ "$USE_POSTGRES" = "true" ]; then
    echo "Đang chờ PostgreSQL tại $DB_HOST:$DB_PORT..."
    while ! nc -z $DB_HOST $DB_PORT; do
      sleep 0.5
    done
    echo "PostgreSQL đã sẵn sàng!"
fi

# Chạy Database Migrations
echo "Thực thi Django Migrations..."
python manage.py makemigrations users
python manage.py migrate --noinput

# Nếu có truyền command custom từ docker-compose (vd: runserver hoặc celery)
if [ "$#" -gt 0 ]; then
    echo "Thực thi command: $@"
    exec "$@"
else
    # Mặc định cho Production: Gom static files và khởi chạy Gunicorn
    echo "Gom nhóm Static Files..."
    python manage.py collectstatic --noinput
    echo "Khởi chạy Gunicorn WSGI Server..."
    exec gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers 3 --timeout 120
fi
