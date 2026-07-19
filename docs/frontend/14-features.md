# 14 - Features

Tài liệu này đặc tả chi tiết giao diện, các hành động và logic xử lý của từng màn hình tính năng chính phía Frontend (Client App) của SnapSpot.

---

## 1. Phân hệ Xác thực (Authentication)

### 1.1. Màn hình Đăng nhập (Login Screen)
- **Giao diện**:
  - Logo SnapSpot ở góc trên cùng.
  - Ô nhập liệu Email và Mật khẩu (có nút ẩn/hiện mật khẩu).
  - Nút "Đăng nhập" (AppButton).
  - Khối liên kết "Quên mật khẩu?" và "Đăng ký tài khoản".
  - Các nút đăng nhập mạng xã hội: Google Sign-In và Sign in with Apple.
- **Logic xử lý**:
  - Validate email đúng định dạng và mật khẩu lớn hơn 6 ký tự tại client.
  - Gọi API đăng nhập -> Nhận cặp Access Token & Refresh Token -> Lưu vào Secure Storage -> Chuyển hướng sang trang chủ `/`.

### 1.2. Màn hình Đăng ký (Register Screen)
- **Giao diện**: Ô nhập Username, Email, Mật khẩu và Nhập lại mật khẩu.
- **Logic xử lý**: Gọi API tạo tài khoản -> Yêu cầu kiểm tra hòm thư để xác thực email trước khi cho phép đăng nhập.

---

## 2. Phân hệ Bảng tin (Home Feed & Nearby Feed)

### 2.1. Màn hình Bảng tin chính (Feed Screen)
Màn hình trang chủ chia làm 2 tab con: **"Theo dõi"** (Follow) và **"Lân cận"** (Nearby).
- **Tab Theo dõi**: Hiển thị bài viết của những người dùng đã follow.
- **Tab Lân cận**: Gọi GPS thiết bị -> Lọc bài viết xung quanh vị trí hiện tại trong bán kính cấu hình (mặc định 10km).
- **Trải nghiệm vuốt (Scroll)**:
  - Sử dụng `RefreshIndicator` để hỗ trợ kéo xuống để làm mới (Pull-to-Refresh).
  - Lắng nghe sự kiện cuộn màn hình để tự động tải thêm trang tiếp theo (Infinite Scroll).

### 2.2. Màn hình Chi tiết bài viết (Post Detail Screen)
- **Giao diện**:
  - Slider ảnh phóng to (Carousel) hỗ trợ nhấp đúp để Like nhanh (Double-tap to Like).
  - Phần hiển thị chi tiết vị trí (bấm vào sẽ chuyển sang màn hình Bản đồ tập trung vào tọa độ đó).
  - Danh sách bình luận cuộn phía dưới.
- **Logic**: Kết nối thời gian thực thông qua API thông thường để gửi/nhận bình luận mới.

---

## 3. Phân hệ Camera & Đăng tải (Camera & Posting)
- **Màn hình chụp ảnh (Camera Capture)**:
  - Cho phép căn lề, bật/tắt flash, chuyển đổi camera trước/sau.
- **Màn hình biên tập (Post Editor)**:
  - Hệ thống đọc EXIF dữ liệu ảnh -> Nếu có GPS, tự động gắn thẻ địa chỉ (ví dụ: `Hồ Hoàn Kiếm, Hà Nội`).
  - Nếu không có GPS -> Hiển thị nút "Chọn vị trí trên Bản đồ" -> Người dùng ghim thủ công.
  - Cho phép nhập Caption tối đa 500 ký tự và gắn hashtag dạng `#dulich #photographer`.

---

## 4. Phân hệ Bản đồ khám phá (Map Explore)
- **Giao diện**: Bản đồ tràn màn hình, ở trên là thanh tìm kiếm địa điểm/hashtag, ở dưới là slider trượt xem nhanh các bức ảnh.
- **Logic**: Khi di chuyển bản đồ (onCameraMove), lấy tọa độ tâm bản đồ và bán kính hiển thị -> Gửi request API lấy danh sách các spots nằm trong khung nhìn bản đồ -> Cập nhật các marker tương ứng trên màn hình.

---

## 5. Phân hệ Nhắn tin (Real-time Chat)
- **Danh sách Chat (Chat List)**: Hiển thị các phòng hội thoại gần đây kèm tin nhắn mới nhất và trạng thái đọc/chưa đọc.
- **Phòng Chat (Chat Room)**:
  - Thiết lập kết nối **WebSocket** đến Backend ngay khi mở phòng.
  - Tin nhắn mới gửi đi được đóng gói dạng JSON qua WebSocket -> Render lập tức lên UI.
  - Nhận tin nhắn đến từ WebSocket -> Cập nhật danh sách tin nhắn. Tự động đóng kết nối khi thoát khỏi màn hình (dispose).