---
name: flutter-state-management
description: Establishes conventions and architectures for managing state in Flutter, focusing on clean separation of presentation and business logic using BLoC/Cubit, BlocBuilder, BlocListener, BlocConsumer, and BlocSelector for performance optimization.
version: 1.2.0
author: Antigravity
tags:
  - flutter
  - state-management
  - bloc
  - cubit
  - performance
  - bloc-selector
---

# Flutter State Management Skill

## Overview
This skill defines standard patterns for state management, ensuring a clear separation between the UI presentation layer and the application state/business logic layer using BLoC/Cubit.

---

## Key Principles

### 1. Separation of Concerns
- **UI (Widgets)**: Should remain completely declarative and simple. They subscribe to state changes and render UI components accordingly.
- **State Holders (BLoC / Cubit)**: Contain business logic, state mutations, and call API repositories. They do NOT import `package:flutter/material.dart` or interact directly with UI elements.

---

### 2. BLoC Widgets & Performance Optimization Rules

#### A. `BlocSelector` (Ưu tiên Hàng đầu cho Tối ưu Hiệu năng & Code Sạch)
- **Tư tưởng hiện đại**: **Thay vì lạm dụng `buildWhen`** (phải viết so sánh thủ công `(prev, current) => prev.foo != current.foo`), các dự án Flutter quy mô vừa và lớn hiện nay **ưu tiên dùng `BlocSelector`** để chỉ lắng nghe đúng phần dữ liệu được chọn (ví dụ: chỉ theo dõi `user.name` hoặc `isLoading`).
- **Ưu điểm vượt trội**: Khai báo ngắn gọn, rõ ràng (Declarative & Strongly-typed), tự động so sánh giá trị trích xuất và triệt tiêu 100% việc rebuild thừa khi các phần dữ liệu khác trong State biến đổi.
  ```dart
  // ✅ Ưu tiên dùng BlocSelector: Chỉ rebuild khi isLoading thay đổi!
  BlocSelector<AuthCubit, AuthState, bool>(
    selector: (state) => state.isLoading,
    builder: (context, isLoading) {
      return AppButton(
        title: 'Đăng nhập',
        isLoading: isLoading,
        onPressed: () => context.read<AuthCubit>().login(...),
      );
    },
  )

  // ✅ BlocSelector cho thuộc tính phức tạp: Chỉ rebuild khi user.name thay đổi!
  BlocSelector<UserCubit, UserState, String>(
    selector: (state) => state.user.fullName,
    builder: (context, fullName) {
      return Text('Xin chào, $fullName!');
    },
  )
  ```

#### B. `BlocListener` (Thực thi Side-effects 1 lần)
- **Mục đích**: Thực thi side-effects một lần duy nhất per state emission mà KHÔNG rebuild widget tree.
- **Trường hợp áp dụng**: Chuyển màn hình (`context.go`, `context.push`), hiển thị `SnackBar`, hoặc mở `Dialog`/`BottomSheet`.
- **Sử dụng `listenWhen`**: Dùng `listenWhen: (prev, current)` để chỉ kích hoạt listener khi đúng điều kiện State mục tiêu.
  ```dart
  BlocListener<AuthCubit, AuthState>(
    listenWhen: (prev, current) => current is AuthFailure || current is AuthSuccess,
    listener: (context, state) {
      if (state is AuthSuccess) context.go('/');
      if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    },
    child: const LoginForm(),
  )
  ```

#### C. `BlocConsumer` (Kết hợp Builder & Listener)
- **Mục đích**: Kết hợp cả `BlocBuilder` và `BlocListener` cho các luồng vừa cần cập nhật UI vừa cần thực thi hành động 1 lần (Ví dụ: Form Đăng nhập).

#### D. `BlocBuilder` (Dựng lại UI Thuần túy)
- **Quy tắc Bắt buộc**: **TUYỆT ĐỐI KHÔNG chứa Side-effects** bên trong `builder` (như `Navigator.push`, `showSnackBar`, `showDialog`).

---

### 3. Handling Either Result in Cubits
- Always handle the `Either` result from Repositories using `fold()` or `match()`:
  ```dart
  final result = await authRepository.login(email, password);
  result.fold(
    (failure) => emit(AuthFailure(failure.message)),
    (user) => emit(AuthSuccess(user)),
  );
  ```

---

### 4. Dependency Injection via `get_it`
- Pass repositories into Cubits/BLoCs via Constructor Injection.
- Instantiate BLoCs using `getIt`:
  ```dart
  BlocProvider(
    create: (context) => AuthCubit(getIt<AuthRepository>()),
    child: const LoginScreen(),
  )
  ```
