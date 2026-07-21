---
name: flutter-navigation-routing-rules
description: Quy chuẩn định tuyến và điều hướng trong ứng dụng Flutter sử dụng GoRouter, hỗ trợ Declarative Routing, ShellRoute cho Bottom Navigation Bar, Route Guards bảo mật và truyền tham số an toàn.
version: 1.0.0
tags:
  - flutter
  - navigation
  - gorouter
  - routing
---

# Flutter Navigation & Routing Rules

## Overview
Bộ quy chuẩn này định nghĩa các quy tắc quản lý điều hướng và định tuyến trong ứng dụng Flutter bằng thư viện `go_router`.

---

## Key Principles

### 1. Khai báo Route Tập trung (`lib/core/router/`)
- Mọi tuyến đường (Routes) được cấu hình tập trung tại `AppRouter.router` trong file `lib/core/router/app_router.dart`.
- Đặt tên Route Name và Path dưới dạng hằng số chuẩn để tránh gõ nhầm chuỗi:
  ```dart
  class AppRoutes {
    static const String home = '/';
    static const String login = '/login';
    static const String postDetail = '/post/:id';
  }
  ```

---

### 2. Sử dụng ShellRoute cho Navigation Bar
- Sử dụng `ShellRoute` hoặc `StatefulShellRoute` để bảo toàn trạng thái (State Retention) của các Tab trong Bottom Navigation Bar khi chuyển tab (Home, Map, Camera, Chat, Profile).

---

### 3. Route Guards & Xác thực (Authentication Redirect)
- Cấu hình thuộc tính `redirect` của `GoRouter` để kiểm tra trạng thái xác thực người dùng (`AuthCubit` / Token):
  - Nếu người dùng chưa đăng nhập và truy cập route bảo mật → Tự động chuyển hướng về `/login`.
  - Nếu người dùng đã đăng nhập mà truy cập `/login` → Tự động chuyển hướng tới `/`.

---

### 4. Truyền Tham số An toàn (Safe Parameter Passing)
- **Path Parameters**: Dùng cho ID định danh tài nguyên (Ví dụ: `/post/:id`).
- **Query Parameters**: Dùng cho lọc/tìm kiếm (Ví dụ: `/search?q=hanoi`).
- **Extra Parameters (`extra`)**: Dùng khi cần truyền một Domain Entity (Ví dụ: `PostEntity`) sang màn hình chi tiết.
- Sử dụng `context.go()` cho chuyển đổi tuyến đường chính và `context.push()` cho hiển thị màn hình con/stack.
