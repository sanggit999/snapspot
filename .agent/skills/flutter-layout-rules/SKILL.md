---
name: flutter-layout-rules
description: Quy chuẩn thiết kế Layout trong Flutter, kiểm soát Constraints, tối ưu hóa Grid/List và Slivers để đạt hiệu năng cuộn mượt mà.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - ui
  - layout
  - scrolling
  - slivers
  - best-practices
---

# Quy chuẩn Thiết kế Layout và Cuộn trong Flutter

## Tổng quan
Cơ chế layout trong Flutter dựa trên luồng truyền dữ liệu kích thước và ràng buộc. Việc làm chủ nguyên tắc layout giúp lập trình viên tránh được các lỗi hiển thị phổ biến (như tràn màn hình - overflow, kích thước vô hạn - unbound height) và tối ưu hóa hiệu năng render danh sách lớn.

## Khi nào cần sử dụng
- Khi sắp xếp bố cục giao diện bằng các widget `Row`, `Column`, `Stack`, `Flex`.
- Khi xây dựng các danh sách cuộn (`ListView`, `GridView`, `SingleChildScrollView`).
- Khi phát triển các hiệu ứng cuộn phức tạp (collapsing toolbar, parallax effect) sử dụng `Slivers`.

---

## Các Quy tắc Bố cục & Cuộn chính

### 1. Nguyên lý vàng: Constraints Go Down, Sizes Go Up, Parent Sets Position
- **Ràng buộc đi xuống (Constraints go down)**: Widget cha truyền các ràng buộc kích thước tối thiểu/tối đa cho widget con.
- **Kích thước đi lên (Sizes go up)**: Widget con tự quyết định kích thước của mình dựa trên các ràng buộc nhận được từ cha và truyền lại thông số đó lên trên.
- **Vị trí do cha thiết lập (Parent sets position)**: Widget cha dựa trên kích thước của con để định vị trí hiển thị cho con trên màn hình.

### 2. Xử lý lỗi Tràn Màn Hình (Layout Overflow) và Kích thước Vô hạn
- Lỗi `A RenderFlex overflowed by X pixels` xảy ra khi kích thước của widget con vượt quá không gian hiển thị cho phép của `Row`/`Column` (widget cha).
  - **Khắc phục**: Bao bọc widget con trong `Expanded` hoặc `Flexible` để buộc nó co giãn trong không gian còn lại.
- Lỗi `Vertical viewport was given unbounded height` xảy ra khi đặt một widget cuộn (như `ListView`) bên trong một widget khác cũng có kích thước vô hạn (như `Column` không giới hạn chiều cao).
  - **Khắc phục**: Đặt `shrinkWrap: true` cho `ListView` (nếu danh sách ngắn) hoặc bao bọc `ListView` trong `Expanded` để nó chiếm toàn bộ không gian khả dụng của `Column`.

### 3. Tối ưu hóa Hiển thị Danh sách (Lists & Grids)
- Đối với danh sách có số lượng phần tử không cố định hoặc lớn hơn 20, **bắt buộc** sử dụng `.builder` constructor (như `ListView.builder`, `GridView.builder`).
  - `.builder` chỉ khởi tạo và vẽ các widget đang hiển thị trên màn hình (lazy loading), giúp tiết kiệm tài nguyên RAM và CPU.
- Thiết lập thuộc tính `itemExtent` hoặc `prototypeItem` cho `ListView` nếu chiều cao các phần tử là cố định. Điều này giúp Flutter tính toán vị trí cuộn nhanh hơn mà không cần vẽ thử phần tử.

### 4. Thiết kế cuộn nâng cao với Slivers
- Khi cần xây dựng các hiệu ứng cuộn phức tạp liên quan đến header (như SliverAppBar tự thu nhỏ khi cuộn), hãy dùng `CustomScrollView` kết hợp với các widget `Sliver`:
  - `SliverList` thay cho `ListView`.
  - `SliverGrid` thay cho `GridView`.
  - `SliverPadding` để tạo khoảng trống giữa các sliver.
- Tránh lồng `SingleChildScrollView` trực tiếp bên ngoài `CustomScrollView` vì sẽ làm mất đi tính năng cuộn mượt mà và cơ chế lazy loading của các sliver con.

### 5. Quy chuẩn Lựa chọn Widget Tạo Khoảng Cách & Bố Cục (Modern Spacing Standard 2026)

Để mã nguồn rõ ràng, dễ bảo trì và tối ưu hóa số lượng node trên cây Widget Tree, áp dụng đúng chuẩn lựa chọn widget tạo khoảng cách như sau:

#### Bảng tra cứu mục đích ↔ Widget nên dùng:
| Mục đích | Widget / Thuộc tính nên dùng |
| :--- | :--- |
| Khoảng cách đều giữa các child | ✅ `spacing` (thuộc tính `spacing` trong `Row`, `Column`, `Flex`, `Wrap`) |
| Khoảng cách không đều / tùy chỉnh | ✅ `SizedBox` |
| Khoảng cách với mép ngoài (Outer spacing) | ✅ `Padding` |
| Đẩy widget sang hai đầu | ✅ `Spacer` hoặc `MainAxisAlignment.spaceBetween` |
| Căn lề một widget | ✅ `Padding` |
| Khoảng cách giữa 2 widget duy nhất | ✅ `SizedBox` hoặc `spacing` đều được |
| Danh sách widget dài có cùng khoảng cách | ✅ `spacing` |

#### Quy ước chuẩn 2026 cho dự án Flutter:
- **`spacing`**: Dùng cho khoảng cách bên trong `Row`, `Column`, `Flex` khi tất cả các phần tử con có khoảng cách cố định bằng nhau. (Giúp loại bỏ hàng loạt các widget `SizedBox` rải rác giữa các item).
- **`Padding`**: Dùng cho khoảng cách giữa widget với widget cha xung quanh (outer spacing) hoặc căn lề widget.
- **`SizedBox`**: Dùng cho các khoảng cách đặc biệt, linh hoạt hoặc không đồng đều giữa 2 phần tử cụ thể.
- **`Spacer`**: Chiếm toàn bộ phần không gian trống còn lại trong `Row`/`Column` để căn chỉnh bố cục.
- **`MainAxisAlignment.spaceBetween / spaceAround / spaceEvenly`**: Chỉ dùng để phân phối không gian dư khả dụng của container, **không** dùng để thay thế khoảng cách cố định giữa các widget.

---

## Hướng dẫn thực hiện cho Agent (Layout Checklist)

1. **Kiểm tra Flexible/Expanded**: Đảm bảo toàn bộ chữ viết (`Text`) hoặc hình ảnh nằm trong `Row`/`Column` mà có nguy cơ bị tràn màn hình đã được bảo vệ bằng `Expanded` hoặc `Flexible`.
2. **Kiểm tra Lazy Loading**: Xác minh tất cả các danh sách/lưới dữ liệu có dùng `ListView.builder` hay `GridView.builder` thay vì khởi tạo mảng widget tĩnh không.
3. **Kiểm tra Unbounded Height**: Đảm bảo các danh sách cuộn nằm trong `Column` được bọc bằng `Expanded` hoặc thiết lập chiều cao cụ thể.
4. **Kiểm tra Spacing Standard (2026)**:
   - Ưu tiên sử dụng thuộc tính `spacing` trong `Row`/`Column` đối với danh sách phần tử có khoảng cách bằng nhau.
   - Dùng `Padding` cho khoảng cách mép ngoài (outer spacing).
   - Dùng `SizedBox` cho các khoảng cách không đồng đều đặc biệt.
   - Dùng `Spacer` khi muốn đẩy các phần tử về hai biên.

