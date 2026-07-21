---
name: flutter-local-storage-rules
description: Quy chuẩn lưu trữ và bộ nhớ tạm (Local Storage & Caching) trong Flutter sử dụng Hive cho NoSQL database, FlutterSecureStorage cho mã hóa Token/Credentials, và chiến lược Caching Cache-First / Network-First.
version: 1.0.0
tags:
  - flutter
  - local-storage
  - hive
  - secure-storage
  - caching
---

# Flutter Local Storage & Caching Rules

## Overview
Bộ quy chuẩn này quy định cách thức quản lý lưu trữ dữ liệu cục bộ, bộ nhớ tạm (Cache), và bảo mật thông tin nhạy cảm trong ứng dụng Flutter.

---

## Key Principles

### 1. Phân chia Trách nhiệm Lưu trữ (Storage Separation)
- **`FlutterSecureStorage`**:
  - Chỉ lưu trữ các thông tin nhạy cảm: `accessToken`, `refreshToken`, `userId`, `securityKeys`.
  - Sử dụng Android Keystore trên Android và iOS Keychain trên iOS.
- **`Hive` (NoSQL Box)**:
  - Lưu trữ cài đặt ứng dụng (`settingsBox`), chế độ Theme (`AppThemeMode`), ngôn ngữ chọn (`locale`).
  - Cache dữ liệu mảng bài viết, thông tin cá nhân tạm thời để xem Offline.

---

### 2. Khởi tạo & Mở Box An toàn
- Tất cả các Box cần thiết phải được mở ở hàm `main()` trước khi ứng dụng chạy:
  ```dart
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  ```
- Thao tác ghi dữ liệu `Hive.box('settingsBox').put(key, value)` phải bọc trong `try-catch` để tránh crash ứng dụng khi Box chưa khả dụng.

---

### 3. Chiến lược Bộ nhớ tạm (Caching Strategies)
- **Cache-First (Offline First)**: Trả về dữ liệu local từ Hive ngay lập tức cho UI hiển thị tức thì, sau đó âm thầm gọi API ở background để cập nhật lại dữ liệu mới nhất.
- **Network-First**: Gọi API ưu tiên. Nếu không có mạng (Offline/Failure), tự động fallback lấy dữ liệu cache gần nhất từ Hive.
