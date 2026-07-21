---
name: clean-architecture-rules
description: Quy chuẩn xây dựng kiến trúc Clean Architecture trong ứng dụng Flutter, phân tách 3 lớp Domain, Data, Presentation, quản lý Entity bất biến với Equatable, Model thuần với Freezed, và chuyển đổi dữ liệu tập trung qua Mappers.
version: 1.0.0
tags:
  - clean-architecture
  - flutter
  - domain
  - mapper
  - equatable
---

# Clean Architecture Rules for Flutter

## Overview
Bộ quy chuẩn này định nghĩa các nguyên tắc bắt buộc khi thiết kế và mở rộng ứng dụng Flutter theo kiến trúc Clean Architecture. Mục tiêu tối thượng là giữ cho **Domain Layer thuần túy (Pure Domain)**, không phụ thuộc vào thư viện ngoài hay biến đổi của Data Source.

---

## Key Principles

### 1. Phân tách 3 Lớp Rõ Ràng (Strict Layering)
- **Domain Layer (`lib/features/<feature>/domain/`)**:
  - Chứa `Entities`, `Repositories (abstract contracts)`, và `UseCases`.
  - **Bắt buộc thuần túy**: Không import `package:flutter/material.dart`, không chứa mã parse JSON hay annotation của thư viện bên ngoài (trừ `equatable`).
- **Data Layer (`lib/features/<feature>/data/`)**:
  - Chứa `Models`, `DataSources (Remote/Local)`, và `Repository Implementations`.
  - Chịu trách nhiệm giao tiếp với API Server, SQLite, Hive, SecureStorage.
- **Presentation Layer (`lib/features/<feature>/presentation/`)**:
  - Chứa `Screens`, `Widgets`, `Blocs/Cubits`.
  - Chỉ làm việc trực tiếp với `Entities` nhận được từ Repository/UseCase.

---

### 2. Tiêu chuẩn Vàng cho Entities (Domain Entities)
1. **Độc lập hoàn toàn**: Mỗi Entity được khai báo trong một file riêng biệt (Ví dụ: `comment_entity.dart` độc lập với `post_entity.dart`).
2. **Không kế thừa Model**: Entity không `extends` hay `implements` bất kỳ Model nào.
3. **Không chứa JSON Logic**: Tuyệt đối không khai báo `fromJson()` hay `toJson()` trong Entity.
4. **Kết hợp Equatable + copyWith**:
   - `extends Equatable` để so sánh Value Equality (tránh Rebuild UI lãng phí trong BLoC/Cubit).
   - Phương thức `copyWith()` để thực hiện Immutability State Updates.

---

### 3. Tiêu chuẩn Vàng cho Data Models
1. **Sử dụng Freezed**: Định nghĩa Model bằng `@freezed` và `json_serializable`.
2. **Không kế thừa Entity**: Model không `extends` hay `implements` Entity để giữ cho Data Layer linh hoạt khi API thay đổi (REST / GraphQL / SQLite).
3. **Quản lý JSON**: Mọi logic `fromJson()` và `toJson()` chỉ nằm ở Model.

---

### 4. Quản lý Mappers Tập trung (`lib/mappers/`)
- Mọi chuyển đổi hai chiều `Model ↔ Entity` phải được thực hiện thông qua các Mapper thuần túy (Pure Mapper Classes) đặt tại thư mục tập trung `lib/mappers/`.
- Cấu trúc thư mục:
  ```
  lib/mappers/
  ├── auth/user_mapper.dart
  ├── feed/post_mapper.dart
  ├── feed/comment_mapper.dart
  └── chat/chat_mapper.dart
  ```
- Cung cấp các phương thức tĩnh: `toEntity()`, `fromEntity()`, `toEntityList()`, và `toTreeList()` (dùng để chuyển mảng phẳng thành mảng cây lồng nhau).

---

### 5. Quản lý Lỗi & Dependency Injection
- Repositories trả về kiểu `Either<Failure, T>` sử dụng `fpdart` để xử lý lỗi nhất quán.
- Đăng ký và quản lý phụ thuộc (Dependency Injection) thông qua `GetIt` (`lib/core/di/service_locator.dart`).
