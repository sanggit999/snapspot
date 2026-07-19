# 17 - Authentication

Tài liệu này đặc tả chi tiết cơ chế xác thực người dùng sử dụng **JSON Web Token (JWT)** và giải pháp xoay vòng token bảo mật (**Refresh Token Rotation**) trên hệ thống SnapSpot.

---

## 1. Cơ chế hoạt động của JWT (JWT flow)

Hệ thống sử dụng hai loại token:
1. **Access Token**:
   - Thời gian tồn tại ngắn: **15 phút**.
   - Dùng để đính kèm vào mỗi HTTP Request gửi lên server thông qua header `Authorization: Bearer <access_token>`.
   - Payload chứa thông tin: `user_id`, `role`, `exp` (thời gian hết hạn), `jti` (mã định danh token).
2. **Refresh Token**:
   - Thời gian tồn tại dài: **30 ngày**.
   - Dùng để gửi yêu cầu cấp lại Access Token mới mà người dùng không cần nhập lại mật khẩu.
   - Được lưu trữ mã hóa dưới Database Backend để kiểm soát trạng thái hoạt động.

---

## 2. Giải pháp xoay vòng Token (Refresh Token Rotation - RTR)

Để phòng ngừa trường hợp Refresh Token bị đánh cắp và kẻ xấu duy trì quyền truy cập vĩnh viễn, SnapSpot áp dụng cơ chế **Refresh Token Rotation**:

```text
[ Client ]                                     [ Backend ]
    │                                               │
    ├───── POST /api/v1/auth/refresh/ ─────────────>┤  (Gửi Refresh_Token_A)
    │      (Refresh_Token_A)                        │
    │                                               │  1. Kiểm tra tính hợp lệ.
    │                                               │  2. Hủy bỏ Refresh_Token_A.
    │                                               │  3. Tạo cặp token mới:
    │                                               │     - Access_Token_B
    │                                               │     - Refresh_Token_B
    │<──── Trả về: Access_Token_B & Refresh_Token_B ┤
```

### Quy tắc xử lý khi phát hiện lạm dụng (Reuse Detection)
- Mỗi Refresh Token chỉ được phép sử dụng **duy nhất 1 lần** để lấy token mới.
- Nếu Server phát hiện Client gửi lên một Refresh Token **đã từng được sử dụng**:
  - Server đánh giá đây là một cuộc tấn công chiếm đoạt phiên (Session Hijacking).
  - Lập tức thu hồi (Revoke/Delete) toàn bộ các Refresh Tokens đang hoạt động của người dùng đó.
  - Bắt buộc người dùng phải đăng nhập lại từ đầu trên tất cả các thiết bị để cấp danh tính mới.

---

## 3. Lưu trữ Token phía Client

- **Thiết bị di động (Flutter App)**:
  - Tuyệt đối không lưu Access/Refresh Token trong `SharedPreferences` thông thường (vì dễ bị đọc trộm trên thiết bị root/jailbreak).
  - Bắt buộc lưu trữ trong **Flutter Secure Storage** (sử dụng Keychain trên iOS và Keystore trên Android).
- **Web Client (Roadmap tương lai)**:
  - Refresh Token phải được lưu trữ trong **HttpOnly, Secure, SameSite=Strict Cookie** để chống lại các cuộc tấn công XSS và CSRF.