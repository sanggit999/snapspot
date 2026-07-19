---
name: comment-rules
description: Chuẩn hóa quy tắc viết chú thích (comment), tài liệu nội bộ, định dạng TODO và chính sách xử lý mã nguồn bị comment trong dự án Dart & Flutter bằng tiếng Việt.
version: 1.0.0
author: Antigravity
tags:
  - documentation
  - clean-code
  - comments
  - vietnamese
---

# Quy tắc Viết Comment và Chú thích Mã nguồn (Tiếng Việt)

## Tổng quan
Kỹ năng này quy định cách viết comment, tài liệu hướng dẫn và dọn dẹp mã nguồn trong dự án. Việc chuẩn hóa comment giúp tăng khả năng đọc hiểu code và bảo trì dự án tốt hơn.

## Khi nào cần sử dụng
- Khi viết các chú thích giải thích thuật toán phức tạp hoặc giải pháp tạm thời (workaround).
- Khi tạo tài liệu mô tả cho class, function hoặc public API.
- Khi thêm các lời nhắc công việc cần làm (TODO).

## Các quy tắc viết Comment chính

### 1. Viết comment bằng tiếng Việt
- Tất cả comment giải thích code trong dự án này sẽ **ưu tiên viết bằng tiếng Việt** (có dấu, rõ nghĩa, chuẩn chỉnh).
- Hãy viết ngắn gọn, súc tích nhưng đầy đủ thông tin để người sau dễ đọc.

### 2. Giải thích "Tại sao", không giải thích "Cái gì"
- Tránh viết các comment dịch lại dòng code một cách dư thừa.
  - ❌ Tránh:
    ```dart
    // Tăng biến đếm lên 1
    count++;
    ```
  - ✅ Khuyến khích:
    ```dart
    // Tăng biến đếm để kích hoạt hiệu ứng chuyển trang tiếp theo sau khi animation kết thúc
    count++;
    ```

### 3. Comment tài liệu hóa (`///`)
- Sử dụng cú pháp 3 dấu gạch chéo (`///`) cho các Class, Mixin, Extension, các biến thành viên quan trọng và các hàm/phương thức để tự động tạo tài liệu.
- Tài liệu hóa các tham số đầu vào, giá trị trả về và các ngoại lệ (Exception) có thể xảy ra.
- Có thể sử dụng định dạng Markdown bên trong comment 3 gạch chéo.
  ```dart
  /// Lớp đại diện cho một địa điểm chụp ảnh (spot).
  /// 
  /// Yêu cầu [latitude] và [longitude] phải là tọa độ GPS hợp lệ.
  class Spot {
    final double latitude;
    final double longitude;
  ...
  ```

### 4. Định dạng chú thích TODO
- Định dạng TODO thống nhất để dễ tìm kiếm: `// TODO(tên_người_viết/mã_lỗi): Mô tả công việc cần làm`.
  - ✅ Ví dụ: `// TODO(sangnguyen): Cập nhật API endpoint động khi có file cấu hình production.`

### 5. Không để lại code bị comment (Dead Code)
- **Tuyệt đối không để lại code không sử dụng bị comment** trong mã nguồn. Nếu không dùng nữa, hãy xóa nó đi. Git đã lưu lại lịch sử nên không lo bị mất.
- Nếu comment lại để debug tạm thời, phải xóa bỏ trước khi tạo Pull Request / Commit.

## Hướng dẫn thực hiện cho Agent
1. Kiểm tra các file code được chỉnh sửa xem có tuân thủ quy tắc comment tiếng Việt không.
2. Cập nhật các comment dịch code dư thừa thành giải thích nghiệp vụ (Tại sao).
3. Chuyển các comment mô tả class/hàm thành chuẩn `///`.
4. Dọn dẹp tất cả các dòng code cũ bị comment vô nghĩa.
