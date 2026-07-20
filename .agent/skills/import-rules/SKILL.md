---
name: import-rules
description: Chuẩn hóa quy tắc import trong dự án Flutter, yêu cầu sử dụng absolute import, không dùng relative import và không dùng barrel files cho một số thành phần.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - dart
  - import-conventions
  - architecture
---

# Quy tắc Import Mã nguồn trong dự án Flutter

## Tổng quan
Kỹ năng này quy định cách thức import các file và thư viện trong dự án. Việc chuẩn hóa import giúp codebase rõ ràng, tránh xung đột import vòng (circular dependency) và giúp các công cụ phân tích tĩnh hoạt động hiệu quả hơn.

## Khi nào cần sử dụng
- Khi thêm mới hoặc chỉnh sửa các câu lệnh `import` ở đầu file Dart.
- Khi refactor cấu trúc thư mục hoặc di chuyển các file trong dự án.

## Các quy tắc Import chính

### 1. Sử dụng Absolute Import (`package:`) cho toàn bộ project
- Tất cả các import nội bộ trong dự án phải sử dụng đường dẫn tuyệt đối bắt đầu bằng `package:snapspot/`.
- ❌ Tránh (Relative Import):
  ```dart
  import 'models/user.dart';
  import '../../widgets/button.dart';
  ```
- ✅ Khuyến khích (Absolute Import):
  ```dart
  import 'package:snapspot/features/auth/data/models/user_model.dart';
  import 'package:snapspot/core/widgets/buttons/app_button.dart';
  ```

### 2. Tuyệt đối không dùng relative import dạng `../` hoặc `./`
- Không sử dụng các đường dẫn tương đối để đi ngược thư mục cha (`../`) hoặc thư mục hiện tại (`./`). Mọi tham chiếu đều phải quy về absolute package path.

### 3. Tuyệt đối không dùng `index.dart` hoặc `widgets.dart` (barrel files) trên toàn bộ ứng dụng
- Bắt buộc trỏ trực tiếp đến từng file `.dart` cụ thể để minh bạch file nguồn được import, tăng tốc độ phân tích của IDE và tránh phụ thuộc vòng.
- Tuyệt đối KHÔNG tạo hoặc sử dụng file gộp barrel file (`index.dart`, `widgets.dart`) cho bất kỳ thành phần nào (Model, Entity, Mapper, Repository hay Reusable Widgets).

### 4. Mỗi import phải thể hiện đầy đủ Feature → Layer → Folder → File
- Đường dẫn import phải tường minh và chỉ thẳng tới file đích chứa định nghĩa của class/hàm đó.
- Cấu trúc đường dẫn import chuẩn:
  `import 'package:snapspot/features/<feature_name>/<layer_name>/<folder_name>/<file_name>.dart';`
- Ví dụ cụ thể:
  ```dart
  import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
  ```

## Hướng dẫn thực hiện cho Agent
1. Khi tạo file mới hoặc thực hiện thay đổi, hãy quét các import ở đầu file.
2. Chuyển đổi mọi relative import (`../`, `./`) sang absolute import bắt đầu bằng `package:snapspot/`.
3. Kiểm tra xem có file `index.dart` nào được import trong model/entity/mapper/repository không, nếu có hãy thay thế bằng import trực tiếp file đích.
