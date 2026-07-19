---
name: flutter-theming-rules
description: Quy chuẩn thiết kế Hệ thống Theme (Theming) trong Flutter, hỗ trợ Dark/Light Mode, cấu hình Material 3 ColorScheme và quản lý Typography.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - ui
  - theming
  - dark-mode
  - material-3
  - best-practices
---

# Quy chuẩn Quản lý Theme & Dark Mode trong Flutter

## Tổng quan
Một ứng dụng chuyên nghiệp cần có giao diện đồng nhất về màu sắc và kiểu chữ (Typography). Flutter cung cấp hệ thống Theme tập trung rất mạnh mẽ. Tuân thủ quy chuẩn theme giúp dễ dàng thay đổi diện mạo ứng dụng (rebranding) và hỗ trợ Dark Mode một cách tự động và mượt mà.

## Khi nào cần sử dụng
- Khi thiết lập cấu hình màu sắc (`ColorScheme`) và kiểu chữ (`TextTheme`) tại gốc ứng dụng (`MaterialApp`).
- Khi chỉ định màu sắc và style cho các text, button, card hoặc background.
- Khi triển khai tính năng chuyển đổi chế độ sáng/tối (Light/Dark Mode).

---

## Các Quy tắc Thiết kế Theme và Màu sắc

### 1. Tuyệt đối không Hardcode Màu sắc & Kiểu chữ trực tiếp trong Widget
- **Không sử dụng trực tiếp các hằng số màu sắc** (như `Colors.red`, `Color(0xFF123456)`) trong phần trang trí (`Decoration`), màu nền hoặc màu chữ của các widget con.
- **Không khai báo trực tiếp font size, font weight** rải rác.
- **Giải pháp**: Tất cả màu sắc và kiểu chữ phải được truy xuất động thông qua **`Theme.of(context)`**.
- ❌ **Tránh (Hardcode màu sắc và kiểu chữ)**:
  ```dart
  Text(
    "Chào mừng",
    style: TextStyle(
      color: Colors.black, // Nếu người dùng bật Dark Mode, chữ này sẽ bị biến mất trong nền tối
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  )
  ```
- ✅ **Khuyến khích (Truy xuất qua Theme)**:
  ```dart
  Text(
    "Chào mừng",
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
      color: Theme.of(context).colorScheme.primary, // Tự động đổi màu phù hợp theo Light/Dark Theme
    ),
  )
  ```

### 2. Thiết lập ColorScheme chuẩn Material 3
- Sử dụng cấu trúc `ColorScheme` của Material 3 để định nghĩa màu sắc hệ thống. Các màu sắc cốt lõi cần được cấu hình đầy đủ:
  - `primary` & `onPrimary`: Màu thương hiệu chính và màu chữ/icon hiển thị trên nền đó.
  - `secondary` & `onSecondary`: Màu thương hiệu phụ.
  - `surface` & `onSurface`: Màu nền của các màn hình, thẻ (Card) và chữ viết hiển thị trên đó.
  - `error` & `onError`: Màu sắc cảnh báo lỗi.
- Cách khởi tạo nhanh ColorScheme từ một màu chủ đạo: `ColorScheme.fromSeed(seedColor: Colors.blue)`.

### 3. Đồng bộ và Hỗ trợ Dark Mode tự động
- Cấu hình cả `theme` (Light Mode) và `darkTheme` (Dark Mode) trong `MaterialApp`.
- Sử dụng thuộc tính `themeMode` để điều khiển chế độ hiển thị:
  - `ThemeMode.system`: Tự động thay đổi theo cài đặt hệ thống của điện thoại.
  - `ThemeMode.light` / `ThemeMode.dark`: Ép buộc hiển thị theo tùy chọn của người dùng trong app.

---

## Hướng dẫn thực hiện cho Agent (Theming Checklist)

1. **Rà soát Hardcode**: Quét qua mã nguồn UI để đảm bảo không có thuộc tính `color: Colors.xxx` hay `fontSize: xxx` nào được khai báo cứng mà không có lý do đặc biệt. Thay thế toàn bộ bằng `Theme.of(context).colorScheme` và `Theme.of(context).textTheme`.
2. **Kiểm thử Dark Mode**: Chuyển đổi qua lại giữa Light/Dark Mode để kiểm tra xem có văn bản nào bị chìm vào nền (ví dụ chữ đen trên nền đen do hardcode) hoặc có widget nào không tự đổi màu nền hay không.
3. **Typography**: Đảm bảo sử dụng đúng các Token kiểu chữ như `titleLarge`, `bodyMedium`, `labelSmall` từ `Theme.of(context).textTheme` thay vì tự chế các style tự do.
