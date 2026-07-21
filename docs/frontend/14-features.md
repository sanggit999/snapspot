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
Màn hình trang chủ chia làm 2 tab chính: **"Theo dõi"** (Follow) và **"Lân cận"** (Nearby).
- **Tab Theo dõi**: Hiển thị bài viết của những người dùng đã follow.
- **Tab Lân cận**: Gọi GPS thiết bị -> Lọc bài viết xung quanh vị trí hiện tại trong bán kính cấu hình (mặc định 10km).
- **Thanh Lọc Chủ Đề Nhanh (Topic Filter Chips Tray)**:
  - Nằm ngay dưới Story Tray, cho phép lọc nhanh bài viết theo từng chủ đề: `✨ Tất cả`, `☕ Cafe đẹp`, `🏖️ Du lịch`, `🍜 Ăn uống`, `📸 Sống ảo`, `🏞️ Khám phá`.
- **Trải nghiệm vuốt (Scroll)**:
  - Sử dụng `RefreshIndicator` để hỗ trợ kéo xuống để làm mới (Pull-to-Refresh).
  - Lắng nghe sự kiện cuộn màn hình để tự động tải thêm trang tiếp theo (Infinite Scroll).

### 2.2. Màn hình Chi tiết bài viết (Post Detail Screen)
- **Giao diện**:
  - Slider ảnh phóng to (Carousel) hỗ trợ nhấp đúp để Like nhanh kèm hiệu ứng Rung Haptic Pulse & Tim 3D.
  - Header bài viết hiển thị tên tùy biến: `Bài viết của [Tên FullName]`.
  - Smart Location Badge có khoảng cách GPS tính toán từ vị trí người dùng (`cách bạn 1.2 km`).
  - Danh sách bình luận dạng cuộn phẳng liền mạch (Single-scrollable comment section).
- **Logic**: Hỗ trợ tự động focus ô nhập bàn phím khi chuyển tới từ icon comment (`focusComment=true`).

---

## 3. Phân hệ Tương tác & Chia sẻ (Reactions & 3-in-1 Share Sheet)

### 3.1. Long-Press Quick Reaction Bar
- Nhấn giữ nút Thích (Like) để mở thanh Reaction 5 Emoji độc đáo: `❤️`, `🔥`, `😍`, `👏`, `📍`.
- Tự động lưu cảm xúc đã chọn và cập nhật số đếm tim tương ứng.

### 3.2. Luồng Chia sẻ 3-trong-1 (3-in-1 Social Share Sheet)
Bấm vào nút Chia sẻ (`✈️`) mở Stateful Modal Share Sheet hỗ trợ 3 nhóm chức năng:
1. **Gửi tin nhắn nhanh (Direct DM Chat)**: Chọn avatar bạn bè để bấm "Gửi" / "Đã gửi ✓", gửi tin nhắn kèm preview bài đăng và tăng chỉ số lượt chia sẻ `sharesCount`.
2. **Hành động nhanh**: Sao chép liên kết (`https://snapspot.app/p/:id`), Đăng lên Tin (Story).
3. **Mở App di động Android & iOS (`AppShareService`)**:
   - 🔵 **Zalo**: Thử kích hoạt App Zalo (`zalo://share...`), fallback sang Zalo Web.
   - 🟣 **Messenger**: Thử kích hoạt App Messenger (`fb-messenger://share...`), fallback sang Web Messenger.
   - 🔷 **Facebook**: Thử kích hoạt App Facebook (`fb://...`), fallback sang FB Sharer Web.
   - ⚙️ **Khác...**: Mở System Native Share Sheet của iOS / Android.

---

## 4. Phân hệ Bộ sưu tập Đã lưu (Bookmarked & Saved Collections)

### 4.1. Tab Đã lưu tại ProfileScreen
- Nằm tại trang cá nhân ([ProfileScreen](file:///d:/Flutter/snapspot/lib/features/profile/presentation/screens/profile_screen.dart)), cung cấp TabBar chuyển đổi giữa **Bài viết của tôi** và **Đã lưu (Bookmarked)**.
- **Khối Thư mục Bộ sưu tập (Collections Tray)**:
  - Phân loại bài lưu theo chủ đề: *"Địa điểm muốn đến"*, *"Quán cà phê đẹp"*, *"Ảnh chụp đẹp"*...
- **Lưới Bài viết Đã lưu**: Hiển thị tất cả các địa điểm check-in người dùng đã lưu. Chạm vào bài bất kỳ mở trực tiếp màn hình chi tiết.

### 4.2. Lọc Địa điểm Đã lưu trên Bản đồ Khám phá
- Cho phép bật filter `🔖 Đã lưu` trên [MapExploreScreen](file:///d:/Flutter/snapspot/lib/features/map/presentation/screens/map_explore_screen.dart) để lọc các ghim vị trí đã bookmark trên bản đồ.

---

## 5. Phân hệ Định tuyến & Deep Links (GoRouter Engine)

### 5.1. Hệ thống Route Aliases Đa dạng
Ứng dụng hỗ trợ đa dạng cấu trúc URL giúp việc chia sẻ và deep linking luôn đúng trang:
- `/post/:id` và `/p/:id` -> Màn hình Chi tiết bài viết.
- `/profile`, `/profile/:id`, `/user/profile/:id`, `/user/:id`, `/u/:id` -> Màn hình Trang cá nhân.
- `/saved`, `/bookmarks` -> Màn hình Bộ sưu tập đã lưu.

### 5.2. Màn hình Lỗi 404 Thân thiện (Custom Error Page)
- Khi truy cập route không tồn tại, GoRouter render màn hình 404 tùy biến với biểu tượng cảnh báo và nút "Về Trang Chủ".

---

## 6. Phân hệ Định dạng Số đếm Thu gọn (Compact Number Formatter)
- Tự động chuẩn hóa các số đếm tim, bình luận, chia sẻ lên hàng nghìn, hàng triệu:
  - `< 1,000`: Giữ nguyên số gốc (`950`).
  - `1,000` -> `999,999`: Chuẩn hóa chữ `K` (`1.2K`, `15.8K`).
  - `1,000,000` -> `999,999,999`: Chuẩn hóa chữ `M` (`1.2M`, `15.4M`).
  - `>= 1,000,000,000`: Chuẩn hóa chữ `B` (`2.3B`).