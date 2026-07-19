# 26 - Privacy Policy

Tài liệu này định hình chính sách bảo vệ quyền riêng tư (Privacy Policy) và hướng dẫn kỹ thuật xử lý thông tin nhạy cảm của người dùng trong dự án SnapSpot.

---

## 1. Nguyên tắc Xử lý dữ liệu Vị trí GPS (GPS Data Handling)

Dữ liệu vị trí địa lý là thông tin nhạy cảm nhất của người dùng SnapSpot. Hệ thống cam kết tuân thủ các nguyên tắc sau:
- **Xác nhận sự đồng ý**: Ứng dụng chỉ được phép truy cập GPS của thiết bị khi được người dùng đồng ý (qua hộp thoại cấp quyền hệ điều hành Android/iOS).
- **Không theo dõi ngầm (No Background Tracking)**:
  - Ứng dụng **tuyệt đối không** thu thập hoặc theo dõi tọa độ GPS của người dùng chạy nền (khi tắt ứng dụng).
  - Vị trí GPS chỉ được truy cập cục bộ trên thiết bị tại thời điểm người dùng mở ứng dụng và truy cập tab Bản đồ hoặc màn hình Camera/Đăng bài.
- **Ẩn vị trí chính xác (Location Fuzzing)**:
  - Hệ thống cung cấp tùy chọn "Làm mờ vị trí" cho từng bài đăng.
  - Khi được kích hoạt, tọa độ lưu trên database sẽ được cộng/trừ một sai số ngẫu nhiên trong bán kính 500 mét để tránh việc hiển thị chính xác vị trí nhà riêng hoặc nơi làm việc của người dùng lên bản đồ cộng đồng.

---

## 2. Quyền riêng tư về Hồ sơ tài khoản (Account Privacy Settings)

- **Tài khoản Riêng tư (Private Account)**:
  - Khi người dùng cấu hình tài khoản ở chế độ Riêng tư, các bài viết check-in của họ sẽ không xuất hiện trên bảng tin chung (Public Feed), Nearby Feed của người lạ hoặc ghim bản đồ chung.
  - Chỉ những người dùng nằm trong danh sách người theo dõi được chấp duyệt (Approved Followers) mới có thể xem vị trí và ảnh đăng của họ.
- **Xóa siêu dữ liệu ảnh (Strip EXIF metadata)**:
  - Trước khi ảnh được phân phối ra cộng đồng, Backend phải tự động loại bỏ (strip) toàn bộ siêu dữ liệu nhạy cảm (EXIF Metadata) của tệp tin ảnh gốc (như thông tin dòng máy ảnh, thời gian chụp gốc, các nhãn thiết bị) để tránh rò rỉ thông tin cá nhân.

---

## 3. Quy chuẩn Xóa dữ liệu tài khoản (Right to be Forgotten)

Khi người dùng yêu cầu xóa tài khoản:
- **Ẩn dữ liệu tức thì**: Tài khoản, bài viết, lượt thích, bình luận và phòng chat liên quan sẽ bị ẩn ngay lập tức khỏi mọi luồng hiển thị của ứng dụng.
- **Quy trình Xóa vĩnh viễn (Hard Delete)**: Sau thời hạn **30 ngày** (thời gian chờ khôi phục nếu người dùng đổi ý), hệ thống sẽ chạy tác vụ định kỳ Celery để:
  - Xóa vĩnh viễn dữ liệu người dùng khỏi cơ sở dữ liệu PostgreSQL.
  - Xóa toàn bộ tệp tin hình ảnh, video liên quan của người dùng trên MinIO Object Storage.