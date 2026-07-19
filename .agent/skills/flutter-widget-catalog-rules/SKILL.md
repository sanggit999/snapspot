---
name: flutter-widget-catalog-rules
description: Quy chuẩn sử dụng Widget Catalog trong Flutter, phân biệt và áp dụng Material Design vs Cupertino (iOS), và tối ưu hóa việc chọn lựa các base widgets.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - ui
  - design-systems
  - material
  - cupertino
  - best-practices
---

# Quy chuẩn Widget Catalog & Design Systems trong Flutter

## Tổng quan
Mọi thành phần giao diện trong Flutter đều là **Widget**. Việc hiểu rõ danh mục widget (Widget Catalog) và các ngôn ngữ thiết kế giúp xây dựng UI nhất quán, chuẩn chỉnh trên nhiều nền tảng (Android, iOS, Web, Desktop).

## Khi nào cần sử dụng
- Khi chọn lựa widget để xây dựng giao diện người dùng.
- Khi cần quyết định thiết kế ứng dụng theo phong cách Material Design (Android/Web) hay Cupertino (iOS).
- Khi tối ưu hóa khả năng tái sử dụng và tính nhất quán của UI.

---

## Các Quy tắc Thiết kế & Sử dụng Widget

### 1. Phân biệt & Kết hợp Material Design và Cupertino
- **Material Components**: Ngôn ngữ thiết kế mặc định của Google, phù hợp trên mọi nền tảng (đặc biệt là Android, Web, Windows).
- **Cupertino Components**: Ngôn ngữ thiết kế chuẩn iOS (Apple Human Interface Guidelines), mang lại trải nghiệm chuẩn native cho người dùng iPhone/iPad.
- **Tích hợp Adaptive (Thích ứng)**:
  - Nên sử dụng các constructor `.adaptive` của Flutter để tự động hiển thị widget Material trên Android và Cupertino trên iOS.
  - ❌ **Tránh (Dùng cố định một kiểu trên mọi nền tảng)**:
    ```dart
    // Switch luôn hiển thị kiểu Material kể cả trên iOS
    Switch(
      value: _isActive,
      onChanged: (val) => setState(() => _isActive = val),
    )
    ```
  - ✅ **Khuyến khích (Dùng constructor adaptive)**:
    ```dart
    // Switch tự chuyển đổi giao diện dựa trên nền tảng (iOS vs Android)
    Switch.adaptive(
      value: _isActive,
      onChanged: (val) => setState(() => _isActive = val),
    )
    ```
  - Các widget hỗ trợ `.adaptive` thông dụng: `Switch.adaptive()`, `Slider.adaptive()`, `CircularProgressIndicator.adaptive()`, `Icon.adaptive()`, `Checkbox.adaptive()`, `Radio.adaptive()`.

### 2. Sử dụng Base Widgets đúng mục đích
- **Basics**: Các widget cấu trúc cơ bản như `Container`, `Row`, `Column`, `Stack`, `Image`, `Text`.
  - Hạn chế lạm dụng `Container` nếu chỉ cần căn lề (`Padding`), chỉnh kích thước (`SizedBox`), hoặc căn chỉnh (`Align`). Sử dụng các widget chuyên trách giúp widget tree gọn nhẹ và tối ưu hóa hiệu năng render.
- **Input**: `TextField` (Material) vs `CupertinoTextField` (Cupertino). Luôn xử lý đúng các thuộc tính bàn phím (`keyboardType`, `textInputAction`).
- **Async Widgets**:
  - Dùng `FutureBuilder` cho các tác vụ lấy dữ liệu một lần (one-off asynchronous operation).
  - Dùng `StreamBuilder` cho các nguồn dữ liệu thay đổi liên tục (real-time stream).
  - Phải kiểm tra đầy đủ các trạng thái `ConnectionState.waiting`, `hasError`, và `hasData` để tránh lỗi màn hình trắng hoặc crash UI.

### 3. Tách biệt Custom Widgets
- Khi một Widget Tree vượt quá 80 dòng code hoặc chứa logic hiển thị lặp lại, bắt buộc phải tách ra thành các Custom Widget (class riêng biệt kế thừa `StatelessWidget`/`StatefulWidget`) để dễ quản lý, bảo trì và tái sử dụng.
- Ưu tiên tạo Class Widget hơn là viết helper function trả về Widget (vì helper function không tham gia vào vòng đời tối ưu hóa rebuild của Flutter Element Tree).

---

## Hướng dẫn thực hiện cho Agent (Widget Catalog Checklist)

1. **Rà soát nền tảng**: Kiểm tra xem các nút bấm, hộp thoại (`Dialog`), thanh trượt (`Slider`), công tắc (`Switch`) đã được tối ưu hóa hiển thị trên cả Android và iOS bằng cơ chế `.adaptive` hoặc kiểm tra platform chưa.
2. **Chọn Widget chuyên trách**: Thay thế các `Container` trống chỉ dùng để căn lề hoặc tạo khoảng trống bằng `Padding` hoặc `SizedBox`.
3. **Quản lý Widget phức tạp**: Đảm bảo các widget tree sâu hoặc phức tạp được chia nhỏ thành các custom class widget chuyên biệt.
