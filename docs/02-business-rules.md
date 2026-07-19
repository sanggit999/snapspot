# 02 - Business Rules

Tài liệu này mô tả các quy tắc nghiệp vụ (Business Rules) bắt buộc phải tuân thủ trong toàn bộ hệ thống SnapSpot.

---

## 1. Quy tắc Xác thực & Tài khoản (Authentication & Account)

- **BR-101 (Độ tuổi tối thiểu)**: Người dùng phải từ 13 tuổi trở lên mới được phép đăng ký tài khoản.
- **BR-102 (Định dạng Email)**: Mỗi tài khoản phải liên kết với một địa chỉ Email duy nhất và phải được xác thực trước khi sử dụng các tính năng mạng xã hội (Đăng bài, bình luận).
- **BR-103 (Xóa tài khoản)**: Khi người dùng xóa tài khoản, tất cả thông tin cá nhân và dữ liệu vị trí GPS của họ phải được xóa vĩnh viễn (Hard Delete) sau 30 ngày. Các bài đăng hình ảnh sẽ bị ẩn ngay lập tức.

---

## 2. Quy tắc Chia sẻ Vị trí & Đăng ảnh (Location & Media Sharing)

- **BR-201 (Tính hợp lệ của ảnh)**: Mỗi bài đăng bắt buộc phải chứa tối thiểu 1 hình ảnh hoặc 1 video. Không cho phép đăng bài chỉ có nội dung chữ (text-only).
- **BR-202 (Đính kèm tọa độ)**: 
  - Mọi bài đăng phải được liên kết với một tọa độ GPS (Latitude, Longitude) xác định.
  - Hệ thống ưu tiên tự động đọc metadata GPS (EXIF) từ ảnh được chụp trực tiếp từ camera.
  - Nếu ảnh không chứa tọa độ, người dùng bắt buộc phải chọn vị trí thủ công trên bản đồ trước khi đăng.
- **BR-203 (Bán kính tìm kiếm)**: Tính năng "Nearby Feed" mặc định hiển thị bài viết trong bán kính **10km** tính từ tọa độ hiện tại của người dùng. Người dùng có thể tùy chỉnh bán kính từ **1km** đến **50km**.

---

## 3. Quy tắc Cộng đồng & Kiểm duyệt (Community & Moderation)

- **BR-301 (Báo cáo nội dung - Report)**:
  - Một bài đăng nhận từ **5 báo cáo vi phạm độc lập** (từ 5 người dùng khác nhau) sẽ tự động bị ẩn tạm thời khỏi Feed chung và chuyển vào trạng thái "Chờ duyệt" của Quản trị viên (Moderator).
- **BR-302 (Độ nhạy cảm hình ảnh - NSFW)**:
  - Các hình ảnh chứa nội dung nhạy cảm, bạo lực hoặc vi phạm bản quyền sẽ bị xóa vĩnh viễn. Tài khoản vi phạm liên tục 3 lần sẽ bị khóa (Banned).
- **BR-303 (Bình luận tiêu cực)**:
  - Hệ thống tự động lọc hoặc ẩn các bình luận chứa từ khóa nằm trong danh sách cấm (blacklist) được cấu hình bởi quản trị viên.

---

## 4. Quy tắc Quyền riêng tư (Privacy Rules)

- **BR-401 (Chế độ Riêng tư tài khoản)**:
  - **Tài khoản Công khai (Public)**: Mọi người dùng đều có thể xem bài viết và vị trí check-in của họ.
  - **Tài khoản Riêng tư (Private)**: Chỉ những người dùng đã được phê duyệt theo dõi (Followers) mới có quyền xem bài viết và vị trí của họ trên Map/Feed.
- **BR-402 (Ẩn vị trí chính xác)**: Người dùng có tùy chọn làm mờ vị trí chính xác của họ trên bản đồ chung (chỉ hiển thị vị trí ước lượng trong bán kính 500m) để bảo vệ quyền riêng tư cá nhân.