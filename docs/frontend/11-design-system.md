# 11 - Design System

Tài liệu này đặc tả hệ thống thiết kế (Design System) của SnapSpot, bao gồm các token thiết kế cơ bản phục vụ cho việc xây dựng UI đồng nhất trong Flutter.

---

## 1. Bảng màu hệ thống (Color Tokens)

SnapSpot sử dụng bảng màu hiện đại, trẻ trung và năng động với màu cam san hô làm chủ đạo.

| Token | Giá trị Hex | Ứng dụng thực tế |
| :--- | :--- | :--- |
| **`Primary (Cam San Hô)`** | `#FF6F61` | Màu chủ đạo cho nút nhấn, chỉ báo hoạt động, icon trạng thái active. |
| **`Secondary (Xanh Teal)`** | `#4EA8DE` | Màu phụ dùng cho các hành động bổ trợ, liên kết, bản đồ. |
| **`Background Light`** | `#F8F9FA` | Nền màn hình chính ở chế độ sáng. |
| **`Background Dark`** | `#121212` | Nền màn hình chính ở chế độ tối. |
| **`Surface Light`** | `#FFFFFF` | Nền của các thẻ (Card), ô nhập liệu, Appbar ở chế độ sáng. |
| **`Surface Dark`** | `#1E1E1E` | Nền của các thẻ (Card), ô nhập liệu, Appbar ở chế độ tối. |
| **`Success`** | `#2ECC71` | Trạng thái thành công, thông báo thành công. |
| **`Warning`** | `#F1C40F` | Trạng thái cảnh báo, lưu ý. |
| **`Error`** | `#E74C3C` | Trạng thái lỗi, cảnh báo nguy hiểm. |

---

## 2. Hệ thống kiểu chữ (Typography Tokens)

Sử dụng phông chữ **Outfit** hoặc **Inter** từ Google Fonts để mang lại giao diện hiện đại và dễ đọc.

- **`Display Large`**: Size 32sp, Bold (700), Line height 1.25. Dùng cho tiêu đề lớn, chào đón.
- **`Headline Medium`**: Size 20sp, Semi-Bold (600), Line height 1.3. Dùng cho tiêu đề màn hình, tên địa điểm lớn.
- **`Body Large`**: Size 16sp, Regular (400), Line height 1.5. Dùng cho văn bản nội dung chính, mô tả bài viết.
- **`Body Medium`**: Size 14sp, Regular (400), Line height 1.4. Dùng cho nội dung bình luận, thông tin phụ.
- **`Label Small`**: Size 12sp, Medium (500), Line height 1.3. Dùng cho thẻ phân loại (hashtags), thời gian, khoảng cách.

---

## 3. Hệ thống khoảng cách & Grid (Spacing & Grid)

Áp dụng quy tắc khoảng cách chia hết cho **8** để bảo đảm căn lề hoàn hảo trên mọi kích thước màn hình di động:
- **`Spacing-4`**: 4dp (Khoảng cách rất nhỏ, ví dụ: icon và text nhỏ).
- **`Spacing-8`**: 8dp (Khoảng cách giữa các phần tử nhỏ trong thẻ).
- **`Spacing-12`**: 12dp (Khoảng cách trung bình).
- **`Spacing-16`**: 16dp (Padding lề tiêu chuẩn cho toàn màn hình và lề thẻ).
- **`Spacing-24`**: 24dp (Khoảng cách giữa các khối nội dung lớn).
- **`Spacing-32`**: 32dp (Khoảng cách giữa các phần lớn hoặc margin nút bấm cuối trang).

---

## 4. Quy chuẩn Bo góc (Border Radius Tokens)
- **`Radius-Small`**: 8dp (Dùng cho ô nhập liệu Input, nút bấm nhỏ).
- **`Radius-Medium`**: 16dp (Dùng cho các thẻ bài đăng, hộp thoại Dialog).
- **`Radius-Large`**: 24dp (Dùng cho Bottom Sheet, bảng điều khiển góc bản đồ).
- **`Radius-Circular`**: 50% (Dùng cho ảnh đại diện Avatar, nút bấm tròn Floating Action Button).