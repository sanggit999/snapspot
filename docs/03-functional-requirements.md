# 03 - Functional Requirements

Tài liệu này chi tiết hóa các yêu cầu chức năng (Functional Requirements - FR) của hệ thống SnapSpot, được phân loại theo từng nhóm tính năng chính.

---

## 1. Đối tượng sử dụng (Actors)
- **Khách (Guest)**: Người dùng chưa đăng nhập, chỉ có thể xem Feed công khai, tìm kiếm cơ bản.
- **Thành viên (User)**: Người dùng đã đăng nhập, có toàn quyền đăng ảnh, đính kèm GPS, bình luận, thích, theo dõi bạn bè và nhắn tin.
- **Quản trị viên (Admin/Moderator)**: Có quyền duyệt nội dung báo cáo, khóa tài khoản vi phạm, quản lý danh mục địa điểm và cấu hình hệ thống.

---

## 2. Danh sách Yêu cầu Chức năng (FR)

### Nhóm 1: Xác thực & Quản lý Tài khoản (Authentication)

| ID | Yêu cầu Chức năng | Mô tả chi tiết |
| :--- | :--- | :--- |
| **FR-101** | Đăng ký & Đăng nhập | Cho phép người dùng đăng ký qua Email/Mật khẩu hoặc Đăng nhập nhanh bằng tài khoản Google, Apple. |
| **FR-102** | Quản lý Profile | Cho phép cập nhật ảnh đại diện (avatar), tiểu sử (bio), và quản lý trạng thái tài khoản (Công khai / Riêng tư). |
| **FR-103** | Xác thực 2 lớp (2FA) | Tùy chọn kích hoạt xác thực qua OTP Email hoặc ứng dụng Authenticator (roadmap). |

---

### Nhóm 2: Đăng tải & Quản lý Media (Camera & Media)

| ID | Yêu cầu Chức năng | Mô tả chi tiết |
| :--- | :--- | :--- |
| **FR-201** | Chụp/Chọn ảnh & Video | Hỗ trợ chụp trực tiếp từ camera trong ứng dụng hoặc chọn tối đa 10 ảnh/video từ thư viện (Gallery). |
| **FR-202** | Trích xuất GPS metadata | Hệ thống tự động đọc tọa độ GPS từ dữ liệu EXIF của bức ảnh được chọn. |
| **FR-203** | Bộ lọc & Chỉnh sửa ảnh | Cung cấp các công cụ cắt ảnh (crop) và áp dụng các bộ lọc màu sắc cơ bản trước khi đăng. |

---

### Nhóm 3: Bản đồ & Vị trí địa lý (Location & Map)

| ID | Yêu cầu Chức năng | Mô tả chi tiết |
| :--- | :--- | :--- |
| **FR-301** | Chọn địa điểm (Spot Select) | Cho phép người dùng xác nhận vị trí được gợi ý hoặc tìm kiếm và ghim một địa điểm bất kỳ trên bản đồ. |
| **FR-302** | Bản đồ tương tác (Interactive Map) | Hiển thị các bức ảnh dưới dạng các cụm (cluster pins) trên bản đồ Google Maps của ứng dụng. |
| **FR-303** | Tính khoảng cách | Tự động tính toán và hiển thị khoảng cách từ vị trí hiện tại của thiết bị đến địa điểm đăng ảnh trên Feed (ví dụ: `Cách bạn 2.4 km`). |
| **FR-304** | Nearby Feed | Tải và hiển thị các bài đăng có tọa độ GPS nằm trong bán kính cấu hình xung quanh người dùng. |

---

### Nhóm 4: Mạng xã hội & Tương tác (Social & Interaction)

| ID | Yêu cầu Chức năng | Mô tả chi tiết |
| :--- | :--- | :--- |
| **FR-401** | Bảng tin (Home Feed) | Hiển thị danh sách bài viết từ cộng đồng hoặc từ người đang theo dõi. Hỗ trợ cuộn vô hạn (infinite scroll) và tải lại (pull-to-refresh). |
| **FR-402** | Thích & Bình luận | Cho phép người dùng thả tim (Like) và viết bình luận dưới các bài viết có quyền truy cập. |
| **FR-403** | Theo dõi (Follow System) | Gửi yêu cầu theo dõi, chấp nhận/từ chối yêu cầu đối với tài khoản Riêng tư. |
| **FR-404** | Chat thời gian thực | Nhắn tin văn bản và gửi hình ảnh trực tiếp giữa các tài khoản thông qua kết nối WebSocket. |

---

### Nhóm 5: Tìm kiếm & Khám phá (Search & Discovery)

| ID | Yêu cầu Chức năng | Mô tả chi tiết |
| :--- | :--- | :--- |
| **FR-501** | Tìm kiếm tổng hợp | Cho phép tìm kiếm đồng thời theo tên người dùng (username), địa điểm (place name), hoặc hashtag (#trending). |
| **FR-502** | Xu hướng (Trending) | Hiển thị các hashtag hoặc địa điểm check-in có lượng tương tác cao nhất trong tuần. |