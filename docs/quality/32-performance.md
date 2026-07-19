# 32 - Performance

Tài liệu này quy chuẩn hóa các giải pháp tối ưu hiệu năng (Performance Optimization) cho ứng dụng di động và hệ thống máy chủ SnapSpot.

---

## 1. Tối ưu hiệu năng Client (Flutter App)

Mục tiêu duy trì ứng dụng mượt mà ở mức **60 FPS** (hoặc 120 FPS trên các thiết bị màn hình tần số quét cao):
- **Sử dụng `const` constructor**: Khai báo `const` cho tất cả các Widgets tĩnh để tránh việc khởi tạo lại đối tượng khi Widget Tree rebuild.
- **Tối ưu hóa ảnh tải về**:
  - Không tải ảnh kích thước gốc hiển thị trên bảng tin danh sách. Luôn yêu cầu đường dẫn ảnh thumbnail (300x300px) để hiển thị nhanh.
  - Sử dụng widget `CachedNetworkImage` để tránh tải lại ảnh đã tải trước đó.
- **Xử lý tác vụ nặng bất đồng bộ (Isolates)**: Các tác vụ nặng xử lý CPU (như mã hóa ảnh EXIF, phân tích dữ liệu JSON dung lượng lớn) phải được đẩy xuống chạy riêng ở **Flutter Isolate** để tránh làm đơ luồng xử lý giao diện chính (UI Thread).

---

## 2. Tối ưu hiệu năng Máy chủ (Django Backend)

Mục tiêu phản hồi API dưới **500ms** và giảm thiểu nghẽn cổ chai tài nguyên hệ thống.

### 2.1. Giải quyết bài toán truy vấn dư thừa (N+1 Query Problem)
Khi lấy danh sách bài đăng kèm thông tin người dùng và ảnh, mặc định Django ORM sẽ thực hiện hàng chục câu lệnh SQL rời rạc (N+1 Query).
- **Giải pháp**: Bắt buộc sử dụng `select_related` (cho mối quan hệ 1-1, 1-N) và `prefetch_related` (cho mối quan hệ N-N) để gộp truy vấn SQL thành 1 hoặc 2 câu lệnh duy nhất.
  ```python
  # Tối ưu hóa truy vấn gộp lấy Post kèm User và Images
  posts = Post.objects.select_related('user').prefetch_related('images').all()
  ```

### 2.2. Chiến lược bộ đệm (Caching với Redis)
- **Cache dữ liệu Profile**: Thông tin người dùng ít thay đổi sẽ được lưu vào Redis với thời hạn 1 ngày. Khi cập nhật Profile, thực hiện xóa key cache tương ứng để đồng bộ.
- **Cache bảng tin chung (Home Feed Cache)**: Danh sách các bài đăng nổi bật được lưu cache Redis. Khi có bài đăng mới được duyệt, Celery worker sẽ cập nhật lại danh sách cache này bất đồng bộ.

---

## 3. Tối ưu Cơ sở dữ liệu (PostgreSQL/PostGIS)
- **Tạo chỉ mục phù hợp**: Ngoài GIST cho tọa độ, đánh chỉ mục B-Tree cho toàn bộ khóa ngoại và các trường thường xuyên lọc (`created_at`, `status`).
- **Connection Pooling**: Sử dụng công cụ quản lý kết nối như **PgBouncer** trước PostgreSQL trên production để tái sử dụng các kết nối cơ sở dữ liệu hiện có, tránh hao phí thời gian bắt tay (handshake) tạo kết nối mới cho mỗi request API.