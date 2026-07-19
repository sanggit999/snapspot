---
name: dart-diagnostics-rules
description: Quy chuẩn chẩn đoán, xử lý và khắc phục lỗi static analysis (Errors, Warnings, Lints) và các thông báo chẩn đoán từ Dart Analyzer.
version: 1.0.0
author: Antigravity
tags:
  - dart
  - flutter
  - diagnostics
  - static-analysis
  - linter
  - debugging
  - best-practices
---

# Quy chuẩn Xử lý Diagnostic Messages (Dart Analyzer)

## Tổng quan
Dart Analyzer liên tục quét mã nguồn để phát hiện các lỗi cú pháp, vi phạm đặc tả ngôn ngữ, mã nguồn không tối ưu hoặc vi phạm quy tắc phong cách (style lints). Kỹ năng này hướng dẫn cách đọc hiểu, cấu hình mức độ nghiêm trọng và khắc phục các thông báo chẩn đoán (Diagnostic Messages) phổ biến nhất nhằm giữ cho codebase luôn sạch lỗi.

## Khi nào cần sử dụng
- Khi chạy lệnh `dart analyze` hoặc `flutter analyze` và phát hiện lỗi/cảnh báo.
- Khi xuất hiện gạch chân màu đỏ (Error), vàng (Warning) hoặc xanh (Lint) trong trình soạn thảo mã nguồn.
- Khi cần cấu hình các tùy chọn phân tích tĩnh trong file `analysis_options.yaml`.

---

## 1. Phân loại Diagnostic Messages trong Dart

Mỗi thông báo chẩn đoán được gắn một mức độ nghiêm trọng (Severity) mặc định:
- **Error (Lỗi)**: Vi phạm nghiêm trọng cú pháp hoặc quy tắc của ngôn ngữ khiến chương trình không thể biên dịch. (Ví dụ: `invalid_assignment`, `concrete_class_has_abstract_member`).
- **Warning (Cảnh báo)**: Code hợp lệ về mặt cú pháp và có thể chạy được, nhưng có khả năng cao sẽ gây lỗi runtime hoặc hoạt động sai mong muốn. (Ví dụ: `dead_code`, `unnecessary_null_check_pattern`).
- **Info/Hint (Gợi ý)**: Gợi ý các cách cải tiến code tốt hơn về hiệu năng hoặc cấu trúc.
- **Lint (Quy tắc linter)**: Cảnh báo phong cách lập trình không nhất quán được cấu hình tùy chọn theo dự án. (Ví dụ: `prefer_const_constructors`, `always_specify_types`).

---

## 2. Cấu hình Diagnostic trong `analysis_options.yaml`

Ta có thể thay đổi mức độ nghiêm trọng (nâng lên thành lỗi để ngăn chặn build lỗi, hoặc hạ xuống/ignore đối với các trường hợp đặc biệt) trong file cấu hình tĩnh của dự án:

```yaml
# analysis_options.yaml
analyzer:
  exclude:
    - "build/**"
    - "**/*.g.dart" # Loại trừ file tự động sinh ra
  errors:
    # Nâng warning thành error để bắt buộc sửa trước khi commit
    use_build_context_synchronously: error
    missing_required_param: error
    
    # Hạ mức độ nghiêm trọng hoặc bỏ qua
    todo: ignore
    dead_code: info
```

---

## 3. Cách Khắc phục Các Diagnostics Phổ biến

### 3.1. `use_build_context_synchronously` (Error/Warning)
- **Nguyên nhân**: Sử dụng `BuildContext` của Widget sau một thao tác không đồng bộ (`await`). Trong thời gian chờ `await`, Widget đó có thể đã bị gỡ bỏ (unmounted) khỏi Widget Tree, việc tiếp tục gọi `context` sẽ gây crash ứng dụng.
- ❌ **Bad (Gọi trực tiếp context sau await)**:
  ```dart
  Future<void> _submitData() async {
    await apiService.postData();
    Navigator.of(context).pop(); // Gây cảnh báo hoặc lỗi runtime nếu widget đã unmounted
  }
  ```
- ✅ **Good (Kiểm tra context.mounted trước khi gọi)**:
  ```dart
  Future<void> _submitData() async {
    await apiService.postData();
    if (!context.mounted) return; // Bảo vệ an toàn
    Navigator.of(context).pop();
  }
  ```

### 3.2. Type Promotion Failures (Lỗi nâng cấp kiểu dữ liệu)
- **Nguyên nhân**: Dart không tự động nâng cấp kiểu từ Nullable (ví dụ `String?`) lên Non-nullable (`String`) sau khi kiểm tra `!= null` nếu biến đó là một thuộc tính cấp lớp (class field). Lý do là vì một luồng (thread) hoặc phương thức khác có thể thay đổi giá trị của thuộc tính đó thành `null` ngay sau khi check.
- ❌ **Bad (Không promote được field)**:
  ```dart
  class Profile {
    String? name;

    void printName() {
      if (name != null) {
        // Dart Analyzer báo lỗi: 'name' is nullable, can't be assigned to non-nullable parameter
        showName(name); 
      }
    }
  }
  ```
- ✅ **Good (Gán vào biến cục bộ - Local Variable để tự động promote)**:
  ```dart
  class Profile {
    String? name;

    void printName() {
      final localName = name; // Gán vào local variable (bảo toàn giá trị)
      if (localName != null) {
        showName(localName); // Tự động được nâng cấp lên kiểu String (non-nullable)
      }
    }
  }
  ```

### 3.3. `prefer_const_constructors` (Lint)
- **Nguyên nhân**: Khởi tạo một Widget tĩnh mà không khai báo `const`. Khai báo `const` giúp Flutter tái sử dụng instance cũ thay vì tạo mới, giúp tối ưu hóa bộ nhớ và tăng tốc độ render (FPS).
- ❌ **Tránh**:
  ```dart
  return Container(
    child: Text("Hello World"),
  );
  ```
- ✅ **Khuyến khích**:
  ```dart
  return const Container(
    child: Text("Hello World"),
  );
  ```

### 3.4. `unnecessary_non_null_assertion` (Lint/Warning)
- **Nguyên nhân**: Sử dụng toán tử `!` trên một biến vốn dĩ đã được định nghĩa là Non-nullable (không thể null).
- ❌ **Tránh**:
  ```dart
  String title = "Notification";
  print(title!); // Cảnh báo thừa thãi dấu !
  ```
- ✅ **Khuyến khích**:
  ```dart
  String title = "Notification";
  print(title);
  ```

### 3.5. `non_abstract_class_inherits_abstract_member` (Error)
- **Nguyên nhân**: Một class **không phải `abstract`** kế thừa hoặc `with` một mixin/class có các phương thức `abstract` mà không cung cấp triển khai cụ thể (concrete implementation) cho tất cả các phương thức đó. Dart sẽ báo lỗi biên dịch vì không thể instantiate một class còn tồn tại abstract member.
- **Trường hợp phổ biến với `freezed`**: Khi dùng `@freezed`, macro `_$ClassName` (do `build_runner` sinh ra) chứa các abstract members. Nếu khai báo class là `class` thông thường thay vì `abstract class`, Dart Analyzer sẽ báo lỗi này vì class chưa implement đầy đủ các member từ mixin `_$ClassName`.
- ❌ **Bad (`class` thông thường dùng với `@freezed` khi có custom method)**:
  ```dart
  @freezed
  class UserModel with _$UserModel { // ❌ Lỗi: non_abstract_class_inherits_abstract_member
    const UserModel._();
    const factory UserModel({required String id}) = _UserModel;

    UserEntity toEntity() => UserEntity(id: id); // Custom method yêu cầu abstract class
  }
  ```
- ✅ **Good (Dùng `abstract class` để cho phép `freezed` mixin triển khai đầy đủ)**:
  ```dart
  @freezed
  abstract class UserModel with _$UserModel { // ✅ abstract class giải quyết lỗi
    const UserModel._(); // Bắt buộc khi thêm custom methods vào freezed class
    const factory UserModel({required String id}) = _UserModel;

    UserEntity toEntity() => UserEntity(id: id);
  }
  ```
- **Quy tắc**: Với **`@freezed`**, luôn dùng `abstract class` khi:
  1. Class có thêm các **custom methods** (như `toEntity()`, `fromEntity()`, validators).
  2. Class sử dụng **private constructor** `const ClassName._()` để cho phép viết method body.
  > Nếu class `@freezed` không có custom method nào, có thể dùng `class` thông thường – tuy nhiên để nhất quán, **luôn khai báo `abstract class`** cho mọi `@freezed` model.

---

## 4. Hướng dẫn thực hiện cho Agent (Static Analysis Checklist)

1. **Tuyệt đối không bỏ qua Errors và Warnings**: Mọi mã nguồn Agent chỉnh sửa hoặc viết mới phải vượt qua bước kiểm tra phân tích tĩnh mà không có lỗi đỏ hay cảnh báo vàng nào.
2. **Không lạm dụng `// ignore`**: 
   - Chỉ sử dụng các chú thích tắt cảnh báo cục bộ (như `// ignore: argument_type_not_assignable`) khi thực sự có trường hợp bất khả kháng (như làm việc với mock data phức tạp hoặc thư viện bên ngoài bị lỗi type).
   - Khi sử dụng, bắt buộc phải viết lý do giải thích ngay phía trên.
3. **Kiểm soát BuildContext**: Bất cứ khi nào Agent viết lệnh `await`, hãy rà soát xem phía dưới có đoạn mã nào sử dụng `BuildContext` hay không. Nếu có, bắt buộc phải thêm check `if (!context.mounted) return;`.
4. **Kiểm tra `@freezed` class**: Khi viết hoặc review bất kỳ `@freezed` class nào, xác nhận rằng class đó được khai báo là `abstract class`. Nếu class có custom method hoặc sử dụng `const ClassName._()`, việc thiếu `abstract` sẽ gây lỗi `non_abstract_class_inherits_abstract_member` tại compile time.
