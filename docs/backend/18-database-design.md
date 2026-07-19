# 18 - Database Design

Tài liệu này đặc tả thiết kế cơ sở dữ liệu quan hệ **PostgreSQL (+ PostGIS)** cho hệ thống SnapSpot.

---

## 1. Sơ đồ các bảng dữ liệu chính (Database Schema)

### 1.1. Bảng Người dùng (`custom_user`)
Lưu trữ thông tin tài khoản và profile cá nhân.
- `id` (UUID, Primary Key)
- `email` (VARCHAR(150), Unique)
- `username` (VARCHAR(50), Unique)
- `password` (VARCHAR(128))
- `bio` (TEXT, Nullable)
- `avatar_url` (VARCHAR(512), Nullable)
- `is_active` (BOOLEAN, Default: True)
- `is_private` (BOOLEAN, Default: False)
- `created_at` (TIMESTAMP WITH TIME ZONE)

### 1.2. Bảng Bài viết (`post`)
- `id` (UUID, Primary Key)
- `user_id` (UUID, Foreign Key -> `custom_user.id` on DELETE CASCADE)
- `caption` (TEXT, Nullable)
- `created_at` (TIMESTAMP WITH TIME ZONE)

### 1.3. Bảng Hình ảnh Bài viết (`post_image`)
Một bài đăng có thể có nhiều hình ảnh (Carousel).
- `id` (BIGINT, Primary Key)
- `post_id` (UUID, Foreign Key -> `post.id` on DELETE CASCADE)
- `image_url` (VARCHAR(512))
- `display_order` (INT, Default: 0)
- `created_at` (TIMESTAMP WITH TIME ZONE)

### 1.4. Bảng Địa điểm/Check-in (`spot`)
Lưu trữ thông tin tọa độ không gian địa lý của bài viết sử dụng tính năng của PostGIS.
- `id` (BIGINT, Primary Key)
- `post_id` (UUID, Foreign Key -> `post.id` on DELETE CASCADE, Unique)
- `name` (VARCHAR(255))
- `latitude` (DECIMAL(9,6))
- `longitude` (DECIMAL(9,6))
- `coordinates` (GEOMETRY(Point, 4326)) — Trường lưu trữ tọa độ chuẩn PostGIS
- `created_at` (TIMESTAMP WITH TIME ZONE)

### 1.5. Bảng Bình luận (`comment`)
- `id` (BIGINT, Primary Key)
- `post_id` (UUID, Foreign Key -> `post.id` on DELETE CASCADE)
- `user_id` (UUID, Foreign Key -> `custom_user.id` on DELETE CASCADE)
- `content` (TEXT)
- `created_at` (TIMESTAMP WITH TIME ZONE)

### 1.6. Bảng Thích bài viết (`like`)
- `id` (BIGINT, Primary Key)
- `post_id` (UUID, Foreign Key -> `post.id` on DELETE CASCADE)
- `user_id` (UUID, Foreign Key -> `custom_user.id` on DELETE CASCADE)
- `created_at` (TIMESTAMP WITH TIME ZONE)
- *Unique Constraint*: (`post_id`, `user_id`) - Đảm bảo mỗi user chỉ được like một bài viết 1 lần.

---

## 2. Quy chuẩn Chỉ mục (Indexes & Optimizations)

Để bảo đảm tốc độ truy vấn khi dữ liệu tăng lên hàng triệu dòng, bắt buộc phải tạo các chỉ mục (Indexes) sau:

1. **Bản đồ không gian (Spatial Index)**:
   - Áp dụng chỉ mục **GIST (Generalized Search Tree)** trên cột `coordinates` của bảng `spot`.
   - *Mục đích*: Tối ưu hóa các câu lệnh tìm kiếm lân cận (`ST_DWithin`, `ST_Distance`).
   - *SQL*: `CREATE INDEX spot_coordinates_gist ON spot USING GIST (coordinates);`
2. **Tìm kiếm Bảng tin (Feed Index)**:
   - Tạo Composite Index trên bảng `post` cho hai trường (`user_id`, `created_at` DESC).
   - *Mục đích*: Tối ưu hóa truy vấn hiển thị bảng tin theo thời gian của những người đang theo dõi.
3. **Các khóa ngoại (Foreign Keys)**:
   - Mọi trường khóa ngoại (`user_id`, `post_id`) đều phải được tự động đánh chỉ mục (B-Tree Index) để cải thiện tốc độ các câu lệnh JOIN.