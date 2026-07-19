# 27 - Environment

Tài liệu này đặc tả danh sách và ý nghĩa của các biến môi trường (Environment Variables) cấu hình hệ thống trên các môi trường phát triển (Development, Staging, Production).

---

## 1. Biến môi trường phía Backend (Django)

Các biến này được lưu trữ trong tệp tin `.env` tại thư mục root của Backend và được đọc thông qua thư viện `python-dotenv` hoặc `django-environ`.

### 1.1. Cấu hình chung (General Settings)
- **`DEBUG`**: `True` trên môi trường Local/Development, bắt buộc phải là `False` trên Staging/Production.
- **`SECRET_KEY`**: Chuỗi bí mật dùng để mã hóa session và chữ ký bảo mật của Django.
- **`ALLOWED_HOSTS`**: Danh sách các domains được phép gửi request đến Django (Ví dụ: `snapspot.com,api.snapspot.com`).

### 1.2. Cấu hình Cơ sở dữ liệu & Caching (Database & Redis)
- **`DB_NAME`**: Tên cơ sở dữ liệu PostgreSQL.
- **`DB_USER`**: Tên tài khoản kết nối Database.
- **`DB_PASSWORD`**: Mật khẩu tài khoản Database.
- **`DB_HOST`**: Địa chỉ máy chủ Database (ví dụ: `localhost` hoặc tên service trong docker `db`).
- **`DB_PORT`**: Cổng kết nối Database (mặc định PostgreSQL là `5432`).
- **`REDIS_URL`**: Đường dẫn kết nối Redis Cache và Channel Layer (Ví dụ: `redis://redis:6379/0`).

### 1.3. Cấu hình Hàng đợi (Celery)
- **`CELERY_BROKER_URL`**: Broker trung chuyển task (Ví dụ: `redis://redis:6379/1`).
- **`CELERY_RESULT_BACKEND`**: Nơi lưu trữ kết quả thực thi task (Ví dụ: `redis://redis:6379/2`).

### 1.4. Cấu hình Lưu trữ & Dịch vụ ngoài (MinIO & FCM)
- **`MINIO_ENDPOINT`**: Địa chỉ máy chủ Object Storage (Ví dụ: `minio.snapspot.com` hoặc `localhost:9000`).
- **`MINIO_ACCESS_KEY`**: Tài khoản quản trị MinIO.
- **`MINIO_SECRET_KEY`**: Mật khẩu quản trị MinIO.
- **`MINIO_BUCKET_NAME`**: Tên phân vùng chứa ảnh (Ví dụ: `snapspot-media`).
- **`FIREBASE_CREDENTIALS_PATH`**: Đường dẫn vật lý đến file JSON cấu hình Firebase SDK phục vụ gửi FCM.

---

## 2. Biến môi trường phía Frontend (Flutter)

Trong Flutter, các cấu hình môi trường được nạp thông qua tham số biên dịch `--dark-define` khi chạy build app.

### Các biến cấu hình chính:
- **`API_BASE_URL`**: Địa chỉ gọi REST API của Backend.
  - *Dev*: `http://10.0.2.2:8000/api/v1` (tương đương localhost trên Android Emulator).
  - *Prod*: `https://api.snapspot.com/api/v1`.
- **`WS_BASE_URL`**: Địa chỉ kết nối WebSocket.
  - *Dev*: `ws://10.0.2.2:8000/ws`.
  - *Prod*: `wss://api.snapspot.com/ws`.
- **`GOOGLE_MAPS_API_KEY`**: Khóa API dịch vụ bản đồ Google Maps.