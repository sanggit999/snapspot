# 10 - UI/UX Guidelines

Tài liệu này định hình các hướng dẫn và nguyên tắc thiết kế giao diện (UI) cùng trải nghiệm người dùng (UX) cho ứng dụng di động SnapSpot.

---

## 1. Phong cách thiết kế chung (Visual Style Concept)

SnapSpot hướng tới một phong cách thiết kế hiện đại, cao cấp và đầy năng lượng nhằm nhấn mạnh vào hình ảnh và bản đồ:
- **Tập trung vào nội dung hình ảnh (Media-First)**: Giảm thiểu các đường viền thô và các chi tiết gây xao nhãng. Sử dụng không gian âm (negative space) để hình ảnh nổi bật nhất.
- **Thiết kế thẻ mềm mại (Card-based Layout)**: Các bài đăng, địa điểm được bọc trong các thẻ bo góc lớn (Border Radius: 16px - 24px) đi kèm đổ bóng nhẹ để tạo chiều sâu.
- **Glassmorphism (Hiệu ứng kính mờ)**: Sử dụng hiệu ứng mờ nền (blur backdrop) cho các thanh thông báo, app bar hoặc các bảng điều khiển ghim trên bản đồ để duy trì kết cấu bản đồ bên dưới.

---

## 2. Quy trình trải nghiệm người dùng chính (Core User Flows)

### 2.1. Luồng khám phá bản đồ (Interactive Map Flow)
- **Mục tiêu**: Người dùng khám phá ảnh đẹp xung quanh vị trí của mình một cách trực quan.
- **UX Steps**:
  1. Người dùng mở tab Bản đồ -> Bản đồ tải vị trí hiện tại của thiết bị.
  2. Các bài đăng ảnh hiển thị dưới dạng icon tròn nhỏ chứa avatar ảnh (Avatar Pins).
  3. Bấm vào một Pin -> Hiển thị thẻ xem nhanh thông tin địa điểm (Spot Preview Card) trượt lên từ cạnh dưới.
  4. Bấm vào Spot Preview Card -> Chuyển hướng mượt mà sang trang chi tiết bài đăng.

### 2.2. Luồng đăng ảnh nhanh kèm vị trí (Quick Post Flow)
- **Mục tiêu**: Tải ảnh lên nhanh nhất với số thao tác ít nhất.
- **UX Steps**:
  1. Bấm nút "+" chính giữa thanh điều hướng BottomBar -> Mở Camera trong ứng dụng.
  2. Chụp ảnh (hoặc chọn từ Thư viện).
  3. Màn hình Biên tập: Hệ thống tự động trích xuất vị trí từ ảnh và hiển thị địa chỉ tương ứng. Người dùng có thể bấm vào để thay đổi vị trí thủ công trên bản đồ mini.
  4. Nhập mô tả ngắn (caption) và thêm hashtag.
  5. Bấm "Chia sẻ" -> Trở về trang chủ, thanh trạng thái hiển thị tiến trình tải lên bất đồng bộ nền.

---

## 3. Micro-Animations & Phản hồi tương tác

Các hiệu ứng động nhỏ giúp ứng dụng có cảm giác sống động và phản hồi nhanh:
- **Tương tác nút Thích (Like Button Pop)**: Khi người dùng thả tim (Like), icon trái tim sẽ phình to ra và co lại nhanh kèm theo các hạt phát tia màu đỏ xung quanh.
- **Chuyển trang (Page Transitions)**: Sử dụng hiệu ứng trượt ngang (Slide) khi đi vào trang con và hiệu ứng mờ dần (Fade) khi chuyển tab chính.
- **Chỉ báo hình ảnh (Image Carousel Indicator)**: Khi vuốt qua lại giữa nhiều ảnh trong một bài viết, dấu chấm chỉ báo (dots indicator) sẽ co giãn đàn hồi mượt mà.

---

## 4. Khả năng truy cập (Accessibility - A11y)
- **Kích thước vùng bấm (Tap Target Size)**: Mọi nút bấm tương tác phải có kích thước tối thiểu **48x48 dp** để tránh việc bấm nhầm trên màn hình cảm ứng di động.
- **Độ tương phản chữ (Text Contrast)**: Đảm bảo độ tương phản của chữ với nền đạt tiêu chuẩn WCAG 2.1 AA (tỉ lệ tối thiểu 4.5:1).