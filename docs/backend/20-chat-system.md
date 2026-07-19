# 20 - Chat System

Tài liệu này đặc tả kiến trúc và cơ chế hoạt động của hệ thống nhắn tin trò chuyện thời gian thực (Real-time Chat) trên SnapSpot sử dụng **Django Channels** và **WebSocket**.

---

## 1. Kiến trúc Thời gian thực (Real-time Architecture)

```text
[ Client A ]              [ Nginx Gateway ]            [ Django Channels ]           [ Redis Channel Layer ]
     │                            │                            │                                │
     ├─ 1. Kết nối WebSocket ────>│                            │                                │
     │  (WSS /ws/chat/room_id/)   ├─ 2. Phân tuyến sang ASGI ─>│                                │
     │                            │                            ├─ 3. Tham gia Group Chat ──────>│
     │                            │                            │                                │
     ├─ 4. Gửi JSON Message ──────────────────────────────────>│                                │
     │  (Tin nhắn chữ/ảnh)        │                            ├─ 5. Lưu PostgreSQL             │
     │                            │                            ├─ 6. Phát tin nhắn đến Group ──>│
     │                            │                            │                                ├─ 7. Nhận tin nhắn
     │<─ 8. Đẩy tin nhắn xuống ───┼────────────────────────────┼────────────────────────────────┤
```

---

## 2. Luồng kết nối & Xác thực (Connection Lifecycle)

### 2.1. Thiết lập kết nối (Handshake)
- Client khởi tạo kết nối thông qua giao thức bảo mật `wss://`:
  ```text
  wss://snapspot.com/ws/chat/conversations/{room_uuid}/?token={access_token}
  ```
- **Xác thực qua Middleware**: Hệ thống không dùng cơ chế xác thực session cookie truyền thống. Django Channels sử dụng một Custom Middleware (`JWTAuthMiddleware`) để trích xuất `token` từ Query Parameter, giải mã và gắn thông tin `user` vào kết nối. Nếu token không hợp lệ hoặc hết hạn, kết nối bị từ chối ngay lập tức (HTTP 403).

### 2.2. Tham gia Phòng chat (Room Join)
- Khi kết nối thành công, Consumer (trình xử lý kết nối của Django) sẽ thêm kết nối (channel) này vào một nhóm Redis tương ứng với ID phòng chat (`conversation_{room_uuid}`).

---

## 3. Định dạng dữ liệu truyền tải (Data Payloads)

Dữ liệu truyền qua WebSocket được đóng gói dưới định dạng JSON thống nhất.

### 3.1. Client gửi tin nhắn (Send Message)
```json
{
  "action": "send_message",
  "data": {
    "temp_id": "client-generated-uuid-123",
    "content": "Xin chào, địa điểm này ở đâu thế?",
    "media_url": null
  }
}
```

### 3.2. Server phản hồi & Phát sóng (Broadcast Message)
Sau khi lưu tin nhắn vào PostgreSQL thành công, Server phát thông tin tin nhắn đến toàn bộ thành viên trong phòng (bao gồm cả người gửi để xác nhận gửi thành công):
```json
{
  "event": "new_message",
  "data": {
    "id": 456,
    "temp_id": "client-generated-uuid-123",
    "sender": {
      "id": "user-uuid-1",
      "username": "sangnguyen"
    },
    "content": "Xin chào, địa điểm này ở đâu thế?",
    "media_url": null,
    "created_at": "2026-07-15T10:30:00Z"
  }
}
```

---

## 4. Xử lý khi Ngoại tuyến (Offline Notification Logic)

- Khi tin nhắn mới được gửi vào phòng chat, Backend sẽ kiểm tra danh sách thành viên đang trực tuyến (active WebSocket channels trong nhóm Redis).
- Đối với những thành viên phòng chat **không trực tuyến** (offline):
  - Kích hoạt một tác vụ Celery chạy nền.
  - Tác vụ này sẽ gọi đến Firebase Cloud Messaging (FCM) để gửi thông báo đẩy (Push Notification) đến thiết bị di động của thành viên đó với nội dung tin nhắn rút gọn.