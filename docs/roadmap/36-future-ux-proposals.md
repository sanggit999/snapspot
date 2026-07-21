# 36 - Đề xuất Tối ưu UI/UX & Lộ trình Tính năng Đột phá

Tài liệu này tổng hợp chiến lược nghiên cứu trải nghiệm người dùng (UX Research), các cải tiến UI/UX đã hoàn thiện và định hướng phát triển các tính năng đột phá cho ứng dụng SnapSpot.

---

## 🎯 1. Triết Lý Thiết Kế UX Đặt Người Dùng Làm Trung Tâm (User-Centric Principles)

1. **Giảm tải đắn đo thị giác (Hick's Law)**:
   - Giảm số lượng biểu tượng ứng dụng chia sẻ rác, tập trung vào **Top 3 ứng dụng phổ biến nhất Việt Nam**: Zalo, Messenger, Facebook và nút "Khác...".
2. **Phản hồi xúc giác & thị giác tức thì (Instant Feedback & Haptics)**:
   - Kết hợp `HapticFeedback.lightImpact()` / `mediumImpact()` khi Thả tim 3D, chọn Emoji Reaction, bấm Gửi chia sẻ hoặc sao chép liên kết.
3. **Hiển thị Số lớn thu gọn (Compact Social Counts)**:
   - Áp dụng `NumberFormatter.formatCompact` hiển thị các số đếm lớn dạng `1.2K`, `15.8K`, `1.2M`, `2.3B` nâng cao tính thẩm mỹ và dễ đọc.

---

## 🚀 2. Các Cải Tiến UI/UX Đã Hoàn Thành

| Tính năng | Vị trí | Mô tả Trải nghiệm (UX) |
|---|---|---|
| **Thanh Lọc Chủ Đề Nhanh** | `HomeScreen` | Filter chips cuộn ngang (`✨ Tất cả`, `☕ Cafe đẹp`, `🏖️ Du lịch`...) giúp chọn chủ đề trong 1-Tap. |
| **Share Sheet 3-trong-1** | `SpotCard` | Gửi nhanh tin nhắn bạn bè, copy link, đăng Story & mở ứng dụng Zalo, Messenger, Facebook. |
| **Tab Đã Lưu & Bộ Sưu Tập** | `ProfileScreen` | Quản lý bài viết đã lưu theo thư mục chủ đề (*Địa điểm muốn đến*, *Quán cà phê đẹp*...). |
| **Ghim Đã Lưu Trên Bản Đồ** | `MapExploreScreen` | Filter `🔖 Đã lưu` hiển thị các điểm check-in đã bookmark trực tiếp trên bản đồ GPS. |
| **Màn Hình Lỗi 404 Tùy Biến** | `GoRouter` | Giao diện 404 thân thiện kèm nút bấm về trang chủ thay thế màn hình lỗi hệ thống. |

---

## 🔮 3. Lộ Trình Phát Triển Tính Năng Đột Phá Tiếp Theo (Future Roadmap)

### 3.1. 🗺️ SnapSpot Trip Itinerary (Tự Động Gom Bài Lưu Thành Lịch Trình Du Lịch)
- **Ý tưởng**: Cho phép người dùng chọn 3 - 5 bài đăng trong danh sách `Đã lưu` -> Bấm nút **"Tạo lịch trình 1 ngày"**.
- **Cơ chế**: Hệ thống sử dụng thuật toán tính toán đường đi ngắn nhất (Traveling Salesman Problem - TSP) trên bản đồ PostGIS/Mapbox để gợi ý lộ trình di chuyển tối ưu kèm ước tính khoảng cách & thời gian di chuyển.

### 3.2. 📸 QR Verified Check-in Badge (Huy Hiệu Xác Thực Check-in Thực Tế)
- **Ý tưởng**: Tăng mức độ uy tín và tránh việc check-in ảo.
- **Cơ chế**: Khi người dùng tới trực tiếp quán cafe/địa điểm du lịch và quét mã QR Code dán tại điểm -> Bài viết sẽ nhận được **Huy hiệu Tích Xanh Check-in Verified**, đồng thời người dùng nhận điểm thưởng thành viên (SnapPoints).

### 3.3. 💬 Group Trip Planner Chat (Phòng Chat Nhóm Rủ Đi Check-in)
- **Ý tưởng**: Biến hành động chia sẻ thành hành động kết nối bạn bè đi chơi thực tế.
- **Cơ chế**: Tại Share Sheet bài viết -> Thêm nút **"Rủ bạn đi cùng"** -> Tự động khởi tạo phòng chat nhóm trong SnapSpot Chat, gắn đính kèm thẻ xem trước địa điểm để nhóm bạn thảo luận lịch trình xuất phát.
