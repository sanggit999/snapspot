# 15 - Backend Overview

Tài liệu này tổng quan cấu trúc, kiến trúc và nền tảng phát triển của dịch vụ phía sau (Backend) ứng dụng SnapSpot.

---

## 1. Nền tảng Công nghệ (Tech Stack)

Hệ thống Backend của SnapSpot sử dụng ngôn ngữ lập trình **Python** làm cốt lõi và được xây dựng trên các nền tảng sau:
- **Django**: Web framework mạnh mẽ, cung cấp sẵn hệ thống ORM bảo mật và kiến trúc mô-đun tốt.
- **Django REST Framework (DRF)**: Bộ công cụ mở rộng của Django chuyên dụng cho việc xây dựng các RESTful API chuẩn hóa.
- **Django Channels (ASGI)**: Giải pháp hỗ trợ giao tiếp hai chiều thời gian thực qua giao thức WebSockets.
- **Celery & Celery Beat**: Xử lý các tác vụ nền bất đồng bộ và lập lịch tác vụ định kỳ.
- **PostgreSQL (+ PostGIS)**: Cơ sở dữ liệu quan hệ chính, lưu trữ dữ liệu không gian địa lý hiệu năng cao.
- **Redis**: Đóng vai trò là bộ đệm tốc độ cao (Cache), Channel Layer cho WebSockets và Message Broker cho Celery.
- **MinIO**: Object Storage lưu trữ ảnh và video người dùng (tương thích API S3).

---

## 2. Mô hình Thiết kế Kiến trúc (Backend Architecture Pattern)

Để mã nguồn dễ bảo trì, Backend áp dụng mô hình **Controller - Service - Model (ORM)**:

```text
  [ Client Request ] 
         │
         ▼
    [ Views/API ]    <── (Validate input thông qua Serializers)
         │
         ▼
  [ Service Layer ]  <── (Chứa toàn bộ logic nghiệp vụ cốt lõi)
         │
         ▼
  [ Database (ORM) ] <── (Đọc/ghi dữ liệu qua Models)
```

### Các phân lớp chính:
1. **Views (Controller)**:
   - Nhận request từ Client, thực hiện kiểm tra quyền (Permissions) và xác thực (Authentication).
   - Sử dụng **Serializers** để kiểm duyệt và chuyển đổi dữ liệu đầu vào.
   - Gọi hàm nghiệp vụ tương ứng ở lớp `Service` và trả về kết quả dưới dạng HTTP Response chuẩn.
2. **Service Layer**:
   - Chứa logic nghiệp vụ tinh khiết của hệ thống.
   - Ví dụ: Hàm `create_post_service` sẽ xử lý việc lưu thông tin bài đăng, trích xuất tọa độ GPS, tạo hàng đợi Celery để nén ảnh và gửi thông báo FCM đến những người theo dõi.
   - Giúp tránh việc viết code logic phức tạp trong file `views.py` hay ghi đè phương thức `save()` của `models.py`.
3. **Models (ORM)**:
   - Đại diện cho các bảng trong cơ sở dữ liệu PostgreSQL.
   - Khai báo các mối quan hệ (ForeignKey, ManyToManyField, OneToOneField) và các ràng buộc dữ liệu.

---

## 3. Cấu hình chạy nền (Celery Setup)
- Hàng đợi tác vụ Celery chạy độc lập với luồng xử lý web chính.
- Khi người dùng đăng ảnh, View sẽ gọi:
  ```python
  process_image_task.delay(post_id, image_key)
  ```
- Tác vụ lập tức được đưa vào hàng đợi Redis. Người dùng nhận được phản hồi đăng bài thành công ngay lập tức, trong khi Celery worker chạy nền sẽ tải ảnh từ MinIO, nén tối ưu dung lượng, tạo thumbnail và cập nhật lại đường dẫn ảnh trong database.