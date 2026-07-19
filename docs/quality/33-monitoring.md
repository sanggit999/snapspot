# 33 - Monitoring

Tài liệu này đặc tả quy chuẩn ghi log lỗi (Logging), theo dõi hiệu năng hệ thống (APM) và cảnh báo sự cố (Alerting) của dự án SnapSpot.

---

## 1. Quy chuẩn Ghi nhận Nhật ký (Logging Policy)

Hệ thống Backend Django cấu hình logging tập trung ghi nhận các hoạt động của hệ thống.

### 1.1. Các mức độ Log (Log Levels)
- **`DEBUG`**: Chỉ sử dụng trên môi trường Development để theo dõi chi tiết câu lệnh SQL, luồng chạy biến.
- **`INFO`**: Ghi nhận các sự kiện nghiệp vụ quan trọng (ví dụ: `User đăng ký thành công ID: {user_id}`).
- **`WARNING`**: Ghi nhận các lỗi nhẹ có thể tự khắc phục hoặc hành vi bất thường (ví dụ: `Đăng nhập sai mật khẩu 3 lần liên tiếp`).
- **`ERROR`**: Ghi nhận các lỗi phát sinh nghiêm trọng (ví dụ: `Mất kết nối Database`, `Lỗi hệ thống 500`).

### 1.2. Bảo mật thông tin trong Log
- **Tuyệt đối không ghi nhận PII (Personally Identifiable Information)**: Cấm tuyệt đối in ra log mật khẩu thô của người dùng, số điện thoại hoặc token xác thực. Lập trình viên phải filter/masking các trường nhạy cảm này trước khi in log.

---

## 2. Giám sát lỗi thời gian thực với Sentry

SnapSpot tích hợp **Sentry SDK** trên cả hai nền tảng Frontend (Flutter) và Backend (Django) để tự động thu thập các crash, exception phát sinh trong quá trình hoạt động thực tế.

- **Frontend (Flutter)**:
  - Bọc ứng dụng trong `SentryFlutter.init(...)`.
  - Tự động bắt và gửi lỗi chưa được xử lý (uncaught exceptions) từ luồng chạy của Flutter kèm theo cấu hình thiết bị (hệ điều hành, dòng máy, dung lượng RAM trống).
- **Backend (Django)**:
  - Tích hợp `sentry-sdk` thông qua Django settings.
  - Tự động bắt lỗi 500 kèm theo chi tiết Stack Trace (từng dòng code gây lỗi) giúp nhà phát triển sửa lỗi nhanh chóng mà không cần truy cập trực tiếp vào VPS đọc log file.

---

## 3. Theo dõi hạ tầng & Cảnh báo (Infrastructure Monitoring)

Để quản lý trạng thái máy chủ VPS:
- **Hệ thống giám sát**: Sử dụng bộ công cụ **Prometheus & Grafana** chạy độc lập trên docker container.
  - **Prometheus**: Định kỳ lấy dữ liệu hệ thống (CPU, RAM, dung lượng Disk, số lượng kết nối Nginx).
  - **Grafana**: Vẽ biểu đồ trực quan hóa dữ liệu giám sát.
- **Cảnh báo (Alerting)**: Cấu hình cảnh báo thông qua Telegram Bot hoặc Discord Webhook. Hệ thống sẽ gửi tin nhắn khẩn cấp khi:
  - Dung lượng ổ cứng máy chủ khả dụng dưới **10%**.
  - CPU tải liên tục vượt ngưỡng **90%** trong vòng 5 phút.
  - Tỉ lệ lỗi HTTP 500 trên Nginx tăng đột biến (> 2% tổng số request).
  - Máy chủ Database PostgreSQL ngừng hoạt động đột ngột.