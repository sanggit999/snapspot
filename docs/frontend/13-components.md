# 13 - Components

Tài liệu này mô tả danh sách các thành phần giao diện dùng chung (Reusable Widgets) được thiết kế và đóng gói sẵn trong ứng dụng SnapSpot.

---

## 1. Danh sách các Component dùng chung (Common Widgets)

### 1.1. `AppButton` (Nút bấm tùy chỉnh)
Nút bấm chung hỗ trợ trạng thái tải (Loading state) để ngăn chặn click đúp khi gọi API.
- **Thuộc tính chính**:
  - `label` (String): Nội dung chữ hiển thị.
  - `onPressed` (VoidCallback?): Hàm callback xử lý khi bấm (nếu null -> nút tự động vô hiệu hóa).
  - `isLoading` (bool): Hiển thị vòng tròn xoay thay cho chữ khi đang tải.
  - `variant` (AppButtonVariant): Gồm `primary` (màu cam san hô), `secondary` (xanh teal), `outline` (viền mỏng), `text` (chỉ có chữ).

### 1.2. `AppTextField` (Ô nhập liệu đa năng)
Ô nhập dữ liệu hỗ trợ hiển thị lỗi, ẩn/hiện mật khẩu và các biểu tượng bổ trợ.
- **Thuộc tính chính**:
  - `controller` (TextEditingController).
  - `hintText` (String): Gợi ý nhập liệu.
  - `errorText` (String?): Thông tin lỗi nếu kiểm duyệt thất bại.
  - `obscureText` (bool): Ẩn nội dung nhập (dành cho Mật khẩu).
  - `prefixIcon`, `suffixIcon` (Widget?): Biểu tượng ở đầu hoặc cuối ô nhập.

### 1.3. `SpotCard` (Thẻ hiển thị bài đăng địa điểm)
Thẻ thành phần cốt lõi hiển thị trên trang chủ Home Feed và Nearby Feed.
- **Hình ảnh hiển thị**:
  - Tải ảnh không đồng bộ từ CDN và cache cục bộ bằng thư viện `cached_network_image`.
  - Hiển thị hiệu ứng mờ nhạt (shimmer effect) trong lúc tải.
- **Nội dung thẻ**:
  - **Góc trên**: Tên và avatar của người đăng bài.
  - **Góc dưới bên trái**: Tên địa điểm kèm icon ghim bản đồ.
  - **Góc dưới bên phải**: Khoảng cách động tính bằng kilomet (ví dụ: `2.5 km`).
  - **Thanh tương tác**: Biểu tượng Like (Thả tim), Comment (Bình luận), Share (Chia sẻ) kèm số lượng đếm tương ứng.

---

## 2. Component Bản đồ (`SpotMapWidget`)
Bản đồ tương tác bọc quanh Google Maps SDK hỗ trợ gom cụm điểm đánh dấu (Marker Clustering) để tránh chồng chéo khi có nhiều ảnh ở cùng một địa điểm.
- **Tính năng chính**:
  - Tự động gộp nhóm các bức ảnh ở khoảng cách gần nhau thành một vòng tròn hiển thị số lượng (ví dụ: `[ 5 ]`).
  - Khi thu phóng (Zoom-in), tự động tách nhỏ các cụm thành từng ghim cụ thể.
  - Mỗi ghim đơn (Marker) hiển thị dưới dạng khung tròn chứa ảnh nhỏ (thumbnail) của địa điểm đó.

---

## 3. Component Ảnh đại diện (`AppAvatar`)
Hiển thị ảnh đại diện dạng tròn của người dùng, hỗ trợ placeholder mặc định khi ảnh bị lỗi hoặc chưa thiết lập.
- **Tính năng**:
  - Tích hợp `cached_network_image` để tối ưu băng thông.
  - Tự động vẽ viền sáng (border highlight) nếu người dùng có tin mới (Story) chưa đọc.
  - Hỗ trợ các kích thước chuẩn: `small` (24dp), `medium` (40dp), `large` (80dp).