---
name: flutter-interactivity-gestures-rules
description: Quy chuẩn xử lý tương tác và cử chỉ (Gestures) trong Flutter, sử dụng GestureDetector, InkWell và quản lý trạng thái tương tác của người dùng.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - ui
  - gestures
  - interactivity
  - inkwell
  - best-practices
---

# Quy chuẩn Xử lý Tương tác và Cử chỉ trong Flutter

## Tổng quan
Trải nghiệm người dùng (UX) phụ thuộc rất nhiều vào mức độ mượt mà và nhạy bén khi tương tác với ứng dụng. Flutter cung cấp hệ thống xử lý cử chỉ mạnh mẽ thông qua nhận diện sự kiện chạm, kéo, vuốt. Việc thiết lập đúng các tương tác giúp ứng dụng mang lại cảm giác phản hồi tự nhiên và dễ dùng.

## Khi nào cần sử dụng
- Khi thiết kế các nút bấm tùy chỉnh (custom buttons) hoặc các vùng bấm tương tác.
- Khi triển khai các cử chỉ vuốt để xóa (swipe-to-dismiss), kéo thả (drag and drop), hoặc zoom hình ảnh.
- Khi tối ưu hóa vùng tương tác của người dùng nhằm đảm bảo tính dễ sử dụng (Accessibility).

---

## Các Quy tắc Tương tác & Cử chỉ chính

### 1. Phân biệt InkWell và GestureDetector
- **`InkWell`**: Dùng cho các tương tác bấm tiêu chuẩn của Material Design. Tự động hiển thị hiệu ứng gợn sóng (ink splash ripple) khi chạm vào.
  - **Lưu ý**: Phải đặt `InkWell` bên dưới một `Material` widget và phía trên các widget trang trí (`Ink` hoặc `Container` không có màu nền đè lên hiệu ứng) để gợn sóng hiển thị đúng.
- **`GestureDetector`**: Dùng cho các tương tác cử chỉ nâng cao (kéo - drag, vuốt - swipe, chạm giữ lâu - long press, zoom - scale) hoặc các vùng bấm không cần hiệu ứng gợn sóng Material (như vùng trống để đóng bàn phím).
- ❌ **Tránh (Dùng GestureDetector cho các button tùy chỉnh thông thường)**:
  ```dart
  // Nút bấm không có hiệu ứng phản hồi thị giác khi chạm vào
  GestureDetector(
    onTap: () => _submitForm(),
    child: Container(
      padding: EdgeInsets.all(12),
      child: Text("Submit"),
    ),
  )
  ```
- ✅ **Khuyến khích (Dùng InkWell hoặc Ink để có hiệu ứng gợn sóng)**:
  ```dart
  Material(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _submitForm(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text("Submit", style: TextStyle(color: Colors.white)),
      ),
    ),
  )
  ```

### 2. Thiết lập Vùng Chạm Tiêu chuẩn (Tap Target Size)
- Để đảm bảo ứng dụng dễ sử dụng cho mọi người (kể cả người dùng có ngón tay lớn hoặc gặp khó khăn về vận động), mọi vùng tương tác bấm được bằng ngón tay bắt buộc phải đạt kích thước tối thiểu **48x48 dp** (density-independent pixels).
- **Cách xử lý**: Nếu icon hoặc text hiển thị nhỏ hơn kích thước này (ví dụ một icon close 24x24), hãy bọc nó trong `IconButton` (tự động có padding tối thiểu 48) hoặc dùng `GestureDetector` bọc ngoài `Padding` để mở rộng vùng nhận diện sự kiện chạm.

### 3. Tránh Xung đột Cử chỉ (Gesture Arena Conflict)
- Khi lồng ghép nhiều cử chỉ vuốt/kéo chéo nhau (ví dụ: `PageView` trượt ngang nằm trong một `Drawer` cũng mở bằng cách trượt ngang), cần cấu hình thuộc tính `physics` hoặc chỉ định cụ thể hướng kéo để tránh hiện tượng đơ UI do xung đột sự kiện chạm trong Gesture Arena của Flutter.

---

## Hướng dẫn thực hiện cho Agent (Gestures Checklist)

1. **Kiểm tra Phản hồi Thị giác (Visual Feedback)**: Rà soát xem tất cả các vùng tương tác, nút bấm custom đã có hiệu ứng thay đổi trạng thái khi bấm vào chưa (hiệu ứng gợn sóng của `InkWell`, hoặc thay đổi opacity của `CupertinoButton`).
2. **Kiểm tra Tap Target Size**: Đảm bảo không có nút bấm nhỏ hoặc icon tương tác nào có vùng chạm vật lý nhỏ hơn `48x48 dp`.
3. **Đóng bàn phím tiện lợi**: Bọc màn hình chính (bên dưới Scaffold) bằng một `GestureDetector` với `onTap: () => FocusScope.of(context).unfocus()` để người dùng dễ dàng đóng bàn phím bằng cách chạm vào bất kỳ khoảng trống nào.
