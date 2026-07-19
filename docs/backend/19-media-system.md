# 19 - Media System

Tài liệu này đặc tả kiến trúc lưu trữ, xử lý hình ảnh/video và tối ưu hóa hệ thống truyền tải đa phương tiện (Media System) trên SnapSpot.

---

## 1. Quy trình tải ảnh trực tiếp bằng Presigned URL

Để tránh việc máy chủ Backend Django bị tắc nghẽn băng thông và tốn CPU khi xử lý hàng nghìn luồng tải ảnh dung lượng lớn đồng thời, SnapSpot sử dụng cơ chế **Presigned URL** tải trực tiếp lên Object Storage (MinIO).

```text
[ Client ]                   [ Django Backend ]               [ MinIO S3 Storage ]
    │                                │                                 │
    ├─ 1. POST /media/presigned/ ───>│                                 │
    │  (filename, file_size, type)   │                                 │
    │                                ├─ 2. Validate size & type.       │
    │                                ├─ 3. Gọi S3 SDK sinh PUT URL ───>│
    │                                ├<── Nhận Presigned PUT URL ──────┤
    │<─ 4. Trả URL & File_Key ───────┤                                 │
    │                                │                                 │
    ├─ 5. HTTP PUT (Binary file) ────┼────────────────────────────────>│ (Upload trực tiếp)
    │    (đến Presigned URL nhận được)│                                 │
    │                                │                                 │
    ├─ 6. POST /posts/ ─────────────>│                                 │
    │  (Đăng bài chứa File_Key)       ├─ 7. Lưu DB ở trạng thái "Draft". │
    │                                ├─ 8. Trigger Celery Job ────────>│ (Nén & tạo thumbnail)
```

### Các bước thực hiện:
1. **Yêu cầu khởi tạo**: Client gửi thông tin tệp tin cần tải (kích thước, định dạng `.jpg`, `.png`...) lên API của Django.
2. **Cấp quyền**: Django xác thực quyền người dùng, kiểm tra dung lượng tối đa (ví dụ: không quá 10MB/ảnh). Nếu hợp lệ, gọi MinIO SDK sinh ra một đường dẫn tải lên tạm thời (**Presigned PUT URL**) có thời hạn hiệu lực ngắn (5 phút).
3. **Tải lên trực tiếp**: Client nhận URL và tự động thực hiện lệnh HTTP PUT đẩy tệp tin nhị phân trực tiếp từ thiết bị lên MinIO.
4. **Đăng bài**: Sau khi MinIO xác nhận tải lên hoàn tất, Client gửi API tạo bài viết kèm theo `file_key` tương ứng.
5. **Xử lý bất đồng bộ**: Django ghi nhận bài viết và kích hoạt Celery worker chạy nền thực hiện tối ưu hóa ảnh.

---

## 2. Quy trình xử lý tối ưu hóa hình ảnh (Image Optimization)

Khi Celery worker nhận được lệnh xử lý ảnh từ hàng đợi, nó sẽ:
- **Tải ảnh gốc**: Lấy file ảnh gốc từ thư mục tạm trên MinIO.
- **Nén & Resize (Thư viện Pillow)**:
  - Nếu chiều rộng ảnh lớn hơn **1200px**, tự động hạ độ phân giải (resize) về mức 1200px nhưng vẫn giữ nguyên tỉ lệ khung hình (aspect ratio).
  - Chuyển đổi định dạng sang **WebP** (định dạng ảnh thế hệ mới giúp giảm 30% dung lượng so với JPEG/PNG nhưng chất lượng không đổi).
  - Nén chất lượng ảnh (Quality) về mức **80%**.
- **Tạo ảnh thu nhỏ (Thumbnail)**:
  - Tạo thêm một phiên bản ảnh nhỏ có kích thước **300x300px** phục vụ cho việc hiển thị nhanh trên trang Explore hoặc dạng lưới (Grid View).
- **Lưu trữ**: Đẩy hai tệp tin mới (ảnh tối ưu và ảnh thumbnail) lên thư mục chính trên MinIO và xóa tệp tin ảnh gốc tạm thời để tiết kiệm bộ nhớ.