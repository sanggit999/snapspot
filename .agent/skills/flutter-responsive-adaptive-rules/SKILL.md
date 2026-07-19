---
name: flutter-responsive-adaptive-rules
description: Quy chuẩn thiết kế giao diện thích ứng (Adaptive) và phản hồi (Responsive) trong Flutter cho nhiều kích thước màn hình (Mobile, Tablet, Desktop, Web).
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - ui
  - responsive
  - adaptive
  - safearea
  - mediaquery
  - best-practices
---

# Quy chuẩn Thiết kế Responsive & Adaptive trong Flutter

## Tổng quan
Flutter hỗ trợ biên dịch ứng dụng ra nhiều hệ điều hành và thiết bị với kích thước màn hình khác nhau. Việc xây dựng giao diện có khả năng phản hồi linh hoạt theo kích thước vật lý (Responsive) và thích ứng theo hành vi hệ điều hành (Adaptive) là bắt buộc để mang lại trải nghiệm chuyên nghiệp nhất.

## Khi nào cần sử dụng
- Khi thiết kế giao diện ứng dụng chạy trên cả điện thoại, máy tính bảng (tablet) và máy tính (desktop/web).
- Khi xử lý giao diện tự động thay đổi khi xoay màn hình (orientation change).
- Khi tối ưu hóa giao diện cho các vùng khuất màn hình (tai thỏ, camera nốt ruồi, thanh điều hướng hệ thống).

---

## Các Quy tắc Thiết kế Phản hồi & Thích ứng

### 1. Phân biệt Responsive (Phản hồi) và Adaptive (Thích ứng)
- **Responsive (Phản hồi)**: Giao diện tự động co giãn, sắp xếp lại bố cục dựa trên không gian màn hình khả dụng (Ví dụ: Chuyển từ cột đơn trên Mobile sang dạng lưới nhiều cột trên Tablet/Desktop).
- **Adaptive (Thích ứng)**: Giao diện tự động điều chỉnh theo nền tảng chạy ứng dụng để đem lại trải nghiệm tự nhiên (Ví dụ: Sử dụng phím Back chuẩn Android ở góc trên bên trái, sử dụng cử chỉ vuốt từ cạnh ở iOS; tự động chuyển đổi cấu trúc phím tắt bàn phím trên Desktop).

### 2. Sử dụng MediaQuery vs LayoutBuilder
- **`MediaQuery`**: Cung cấp kích thước toàn màn hình vật lý của thiết bị (`MediaQuery.of(context).size`).
  - Dùng khi cần đưa ra quyết định ở mức độ vĩ mô (macro-level) như xác định loại thiết bị hoặc hướng xoay màn hình (ngang/dọc).
- **`LayoutBuilder`**: Cung cấp các ràng buộc kích thước (`BoxConstraints`) từ widget cha truyền trực tiếp cho nó.
  - Dùng khi thiết kế các component vi mô (micro-level) để chúng tự động thay đổi cấu trúc dựa trên không gian thực tế mà nó được phép hiển thị, bất kể màn hình thiết bị lớn hay nhỏ.
  - ❌ **Tránh (Sử dụng MediaQuery cho mọi thành phần)**:
    ```dart
    // Rất dễ gây tràn layout nếu widget con nằm trong một vùng không gian nhỏ
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return Container(
        width: screenWidth * 0.5, 
        child: Text("Data"),
      );
    }
    ```
  - ✅ **Khuyến khích (Dùng LayoutBuilder để thiết kế thích ứng cục bộ)**:
    ```dart
    Widget build(BuildContext context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      );
    }
    ```

### 3. Đảm bảo vùng an toàn với SafeArea
- Luôn bao bọc các màn hình chính bằng **`SafeArea`** để tránh nội dung bị che khuất bởi tai thỏ (notch), camera nốt ruồi, hoặc thanh điều hướng hệ thống ở cạnh dưới.
- Nếu giao diện có ảnh nền tràn viền (hero background), có thể tắt SafeArea ở phần ảnh nhưng phần văn bản và các nút hành động tương tác bắt buộc phải nằm trong SafeArea.

### 4. Hệ thống Breakpoints Tiêu chuẩn
Sử dụng các mốc kích thước chiều rộng (width) tiêu chuẩn sau để phân loại thiết bị:
- **Mobile (Điện thoại)**: Chiều rộng `< 600 dp`.
- **Tablet (Máy tính bảng / Điện thoại gập màn hình lớn)**: Chiều rộng từ `600 dp` đến `1024 dp`.
- **Desktop / Web**: Chiều rộng `> 1024 dp`.

---

## Hướng dẫn thực hiện cho Agent (Responsive Checklist)

1. **Kiểm tra SafeArea**: Kiểm tra xem màn hình hoặc phần header/footer có bị dính vào viền trên hoặc viền dưới màn hình thiết bị không. Nếu có, hãy thêm `SafeArea`.
2. **Breakpoints Nhất quán**: Kiểm tra xem logic phân chia giao diện Mobile vs Tablet có tuân thủ đúng hệ thống breakpoints tiêu chuẩn không.
3. **Thích ứng Xoay màn hình**: Đảm bảo giao diện không bị vỡ hoặc tràn pixel khi người dùng xoay ngang màn hình (sử dụng `OrientationBuilder` hoặc `SingleChildScrollView` khi cần thiết).
