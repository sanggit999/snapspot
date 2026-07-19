# 22 - Notification System

Tài liệu này đặc tả kiến trúc và cơ chế hoạt động của hệ thống thông báo đẩy (Push Notification) sử dụng **Firebase Cloud Messaging (FCM)** trên SnapSpot.

---

## 1. Kiến trúc Hệ thống Thông báo (Notification Architecture)

Hệ thống thông báo chia thành hai loại:
1. **Thông báo đẩy (Push Notification)**: Hiển thị trên thanh trạng thái của hệ điều hành di động (kể cả khi ứng dụng đã đóng).
2. **Thông báo trong ứng dụng (In-App Notification)**: Lưu trữ trong database và hiển thị ở màn hình Hộp thư (Inbox) trong app.

```text
[ Event Trigger ] ──> [ Celery Task ] ──> [ Query FCM Tokens ] ──> [ FCM Server ] ──> [ Mobile Device ]
(Like/Comment/Chat)    (Chạy nền)          (Đọc từ PostgreSQL)       (Google Service)   (Android/iOS UI)
```

---

## 2. Quy trình đăng ký thiết bị (Token Registration)

Để có thể gửi thông báo chính xác đến một tài khoản, ứng dụng cần theo dõi danh sách token thiết bị của họ.
- **Client**: Lấy FCM Token từ Firebase SDK khi ứng dụng khởi động.
- **API Đăng ký**: Client gửi FCM Token lên Backend qua API:
  - `POST /api/v1/notifications/devices/`
  - Payload:
    ```json
    {
      "registration_id": "fcm-token-string-abc-123",
      "device_type": "android" // hoặc "ios"
    }
    ```
- **Xử lý ở Backend**: Lưu token vào bảng `Device` liên kết với tài khoản người dùng (`user_id`). Một người dùng có thể đăng nhập trên nhiều thiết bị (sẽ có nhiều token khác nhau).

---

## 3. Luồng gửi thông báo bất đồng bộ (Sending Notifications)

Tác vụ gửi thông báo luôn được đưa vào hàng đợi Celery để tránh làm chậm luồng xử lý chính.

### Ví dụ luồng xử lý khi người dùng A Thích bài viết của người dùng B:
1. Client gửi `POST /api/v1/posts/{id}/likes/`.
2. View xử lý lưu lượt thích vào Database.
3. View gọi tác vụ chạy nền:
   ```python
   send_like_notification_task.delay(liker_id, post_id)
   ```
4. Celery Worker nhận tác vụ:
   - Truy vấn người sở hữu bài viết (chủ bài viết B).
   - Lấy danh sách các FCM Tokens hợp lệ của người dùng B từ bảng `Device`.
   - Xây dựng Payload thông báo.
   - Gọi Firebase Admin SDK gửi tin nhắn đa điểm (Multicast Message) đến tất cả thiết bị của B.

---

## 4. Định dạng dữ liệu thông báo (Notification Payload)

Hệ thống gửi dữ liệu kèm theo khóa `data` để ứng dụng Flutter có thể xử lý điều hướng (Deep Linking) khi người dùng bấm vào thông báo.

### Payload tin nhắn Chat gửi qua FCM:
```json
{
  "message": {
    "notification": {
      "title": "Tin nhắn mới từ sangnguyen",
      "body": "Xin chào, địa điểm này ở đâu thế?"
    },
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "type": "chat",
      "conversation_id": "conversation-uuid-123"
    }
  }
}
```
- **Xử lý ở Client**: Lắng nghe sự kiện click thông báo ở tầng nền di động -> Trích xuất `type` và `conversation_id` -> Gọi `context.push('/chat/conversation-uuid-123')` thông qua GoRouter để chuyển tiếp người dùng thẳng vào phòng chat.