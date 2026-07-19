---
name: flutter-animations-rules
description: Quy chuẩn xây dựng Hiệu ứng Hoạt họa (Animations) trong Flutter, lựa chọn giữa Implicit và Explicit Animations, quản lý AnimationController để tối ưu hóa hiệu năng.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - ui
  - animations
  - implicit-animations
  - explicit-animations
  - performance
  - best-practices
---

# Quy chuẩn Xây dựng Animations trong Flutter

## Tổng quan
Animations (hiệu ứng hoạt họa) giúp giao diện ứng dụng trở nên sinh động, trực quan và nâng cao trải nghiệm người dùng. Flutter hỗ trợ hai nhóm hoạt ảnh chính: Implicit (ngầm định) và Explicit (tường minh). Triển khai hoạt ảnh đúng cách giúp đạt hiệu năng cuộn mượt mà (60/120 FPS) và tránh hao pin thiết bị.

## Khi nào cần sử dụng
- Khi tạo các hiệu ứng chuyển đổi trạng thái giao diện đơn giản (phóng to/thu nhỏ nút bấm, mờ dần hình ảnh).
- Khi tạo các chuyển động liên tục, lặp lại, hoặc điều khiển phức tạp (dừng, tua nhanh, chạy ngược).
- Khi thiết kế các chuyển cảnh mượt mà giữa các màn hình (như Hero animation).

---

## Các Quy tắc Thiết kế & Triển khai Animations

### 1. Cây quyết định lựa chọn loại Animation (Implicit vs Explicit)
Hãy luôn chọn loại hoạt ảnh đơn giản nhất đáp ứng được yêu cầu để giữ cho code gọn gàng:
- **Implicit Animations (Hoạt ảnh ngầm định)**:
  - **Đặc điểm**: Dễ sử dụng, Flutter tự động quản lý vòng đời hoạt ảnh (tự tạo Controller ngầm). Bạn chỉ cần thay đổi giá trị thuộc tính và gọi `setState`, widget tự động chuyển đổi mượt mà.
  - **Sử dụng khi**: Hoạt ảnh đơn giản, một chiều, chỉ chuyển đổi từ giá trị A sang B (Ví dụ: `AnimatedContainer`, `AnimatedOpacity`, `AnimatedPadding`, `AnimatedAlign`, `AnimatedPositioned`).
- **Explicit Animations (Hoạt ảnh tường minh)**:
  - **Đặc điểm**: Phức tạp hơn, yêu cầu tự quản lý `AnimationController` và cung cấp `TickerProvider`.
  - **Sử dụng khi**: Hoạt ảnh cần điều khiển chi tiết (lặp lại vô hạn, dừng giữa chừng, tua ngược), hoặc nhiều widget cùng chuyển động theo một nhịp đồng bộ (Ví dụ: `RotationTransition`, `ScaleTransition`, `SizeTransition` kết hợp với `AnimationController`).

### 2. Quản lý Tài nguyên và Tránh Rò Rỉ Bộ Nhớ (Memory Leak)
- Đối với **Explicit Animations**, bất kỳ `AnimationController` nào được khởi tạo **bắt buộc** phải được giải phóng bộ nhớ thông qua phương thức `dispose()` trong vòng đời của `StatefulWidget` (hoặc tầng quản lý tương ứng).
- ❌ **Bad (Không giải phóng controller gây rò rỉ bộ nhớ nghiêm trọng)**:
  ```dart
  class _LoadingState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    
    @override
    void initState() {
      super.initState();
      _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    }
    // Thiếu phương thức dispose() giải phóng _controller
  }
  ```
- ✅ **Good (Giải phóng tài nguyên tường minh)**:
  ```dart
  class _LoadingState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    
    @override
    void initState() {
      super.initState();
      _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    }

    @override
    void dispose() {
      _controller.dispose(); // Giải phóng controller đúng cách
      super.dispose();
    }
  }
  ```

### 3. Tối ưu hóa Hiệu năng Vẽ lại (Repaint)
- **Sử dụng `AnimatedBuilder` hoặc các lớp `Transition` chuyên trách**: Tránh gọi `setState` ở cấp độ toàn màn hình để cập nhật giá trị animation. Hãy dùng `AnimatedBuilder` để giới hạn phạm vi rebuild chỉ nằm trong widget cần chuyển động.
- **Sử dụng `RepaintBoundary`**: Đối với các hoạt ảnh phức tạp hoặc các widget chuyển động liên tục trên màn hình có nhiều widget tĩnh khác xung quanh, hãy bao bọc widget chuyển động đó trong `RepaintBoundary`. Điều này tách biệt layer vẽ của widget hoạt họa ra khỏi phần còn lại của màn hình, ngăn Flutter phải vẽ lại các widget tĩnh vô ích.

---

## Hướng dẫn thực hiện cho Agent (Animations Checklist)

1. **Rà soát Memory Leak**: Đảm bảo tất cả các file chứa `AnimationController` đều có lệnh `_controller.dispose()` tại hàm `dispose()`.
2. **Chọn đúng giải pháp**: Nếu hoạt ảnh chỉ đơn thuần là đổi kích thước hoặc mờ dần một phần tử khi click, hãy khuyến nghị sử dụng `AnimatedContainer` hoặc `AnimatedOpacity` thay vì tự viết `AnimationController` dài dòng.
3. **Rebuild tối thiểu**: Đảm bảo các explicit animations dùng `AnimatedBuilder` với tham số `child` tĩnh (để tránh rebuild lại widget con không chuyển động).
