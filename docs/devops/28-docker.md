# 28 - Docker

Tài liệu này hướng dẫn cách đóng gói ứng dụng (Containerization) sử dụng **Docker** và chạy cụm dịch vụ qua **Docker Compose** cho dự án SnapSpot.

---

## 1. Dockerfile cho Backend (Django)

Để chạy được các truy vấn tọa độ PostGIS, Docker base image của Python bắt buộc phải cài đặt các thư viện hệ thống chuyên dụng cho GIS (`gdal-bin`, `libpq-dev`).

```dockerfile
# Sử dụng Python Slim Image để tối ưu dung lượng tệp tin build
FROM python:3.11-slim

# Thiết lập các biến môi trường hệ thống
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Cài đặt các thư viện hệ thống cần thiết cho PostgreSQL & PostGIS
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    binutils \
    gdal-bin \
    libproj-dev \
    proj-data \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt các thư viện Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép mã nguồn vào container
COPY . /app/

# Khởi chạy máy chủ ASGI (Daphne) phục vụ REST API và WebSockets
EXPOSE 8000
CMD ["daphne", "-b", "0.0.0.0", "-p", "8000", "config.asgi:application"]
```

---

## 2. Docker Compose cho môi trường Phát triển (docker-compose.yml)

Docker Compose giúp khởi chạy toàn bộ ngăn xếp dịch vụ (Stack) chỉ bằng một câu lệnh: `docker compose up --build`.

```yaml
version: '3.8'

services:
  # 1. Cơ sở dữ liệu PostgreSQL tích hợp PostGIS
  db:
    image: postgis/postgis:15-3.3
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=snapspot
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=securepassword
    ports:
      - "5432:5432"

  # 2. Bộ đệm Redis
  redis:
    image: redis:7.0-alpine
    ports:
      - "6379:6379"

  # 3. Web Service Django (ASGI Daphne)
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/app
    ports:
      - "8000:8000"
    environment:
      - DEBUG=True
      - DB_NAME=snapspot
      - DB_USER=postgres
      - DB_PASSWORD=securepassword
      - DB_HOST=db
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis

  # 4. Hàng đợi Celery Worker
  celery_worker:
    build: .
    command: celery -A config worker --loglevel=info
    volumes:
      - .:/app
    environment:
      - DB_NAME=snapspot
      - DB_USER=postgres
      - DB_PASSWORD=securepassword
      - DB_HOST=db
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis

  # 5. Lưu trữ Object Storage MinIO
  minio:
    image: minio/minio
    ports:
      - "9000:9000"
      - "9001:9001"
    command: server /data --console-address ":9001"
    environment:
      - MINIO_ROOT_USER=minioadmin
      - MINIO_ROOT_PASSWORD=minioadminpassword
    volumes:
      - minio_data:/data

volumes:
  postgres_data:
  minio_data:
```
---

## 3. Các lệnh vận hành Docker thông dụng
- **Build và khởi chạy cụm**: `docker compose up --build -d`
- **Tắt cụm và xóa volumes**: `docker compose down -v`
- **Xem log hệ thống**: `docker compose logs -f web`
- **Truy cập CLI của container**: `docker compose exec web python manage.py migrate`