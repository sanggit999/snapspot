# Tài Liệu Kiến Trúc Bảo Mật Mã Hóa Đầu-Đến-Đầu (E2EE Chat Architecture)

Tài liệu này đặc tả chi tiết kiến trúc **Mã hóa Đầu-Đến-Đầu (End-to-End Encryption - E2EE)** cấp Enterprise cho hệ thống Chat 1-1 và Nhóm Chat của **SnapSpot**, đảm bảo nguyên tắc **Zero-Trust Server** (Server Django/PostgreSQL chỉ lưu trữ Ciphertext mã hóa, tuyệt đối không giải mã được nội dung).

---

## 1. Đánh Giá Kiến Trúc Cấp Senior (Senior Security Audit)

> [!IMPORTANT]
> **Đánh giá kiến trúc đề xuất**: Mô hình kết hợp giữa **Signal Protocol (Double Ratchet)** cho Chat 1-1 và **MLS (Messaging Layer Security - IETF RFC 9420)** cho Nhóm Chat là tiêu chuẩn vàng (Gold Standard 2026) của ngành bảo mật truyền thông.

```text
[ Flutter Mobile Frontend ]
   │
   ├── 1. Tầng Mạng (Network Security):
   │      └── TLS 1.3 + Certificate Pinning (Chống tấn công Man-in-the-Middle)
   │
   ├── 2. Tầng Quản Lý Khóa Cá Nhân (Client Key Storage):
   │      └── flutter_secure_storage ──► Encrypted Android Keystore / iOS Keychain
   │
   ├── 3. Mã Hóa Chat 1-1 (One-to-One E2EE):
   │      └── Signal Protocol (X3DH + Double Ratchet)
   │             ├── Forward Secrecy (Lộ khóa hôm nay không giải mã được tin quá khứ)
   │             └── Break-in Recovery (Tự phục hồi khóa cho tin nhắn tương lai)
   │
   ├── 4. Mã Hóa Nhóm Chat (Group E2EE):
   │      └── MLS (Messaging Layer Security - RFC 9420)
   │             └── Tối ưu độ phức tạp $O(\log N)$ qua TreeKEM (Scale nhóm hàng ngàn user)
   │
   └── 5. Thuật Toán Mã Hóa Đối Xứng (Symmetric Cipher):
          └── AES-256-GCM / ChaCha20-Poly1305 (Authenticated Encryption)
               │
               ▼ (Chỉ gửi Ciphertext + Nonce + Header)
   [ Django REST + WebSocket (ASGI) ]
               ↓
   [ PostgreSQL Database ] ──► Chỉ lưu trữ CIPHERTEXT (Zero-Knowledge / Zero-Trust)
```

---

## 2. Thiết Kế Cơ Sở Dữ Liệu Phía Backend Cho E2EE (`apps.chats`)

Dù Server không đọc được tin nhắn, Backend Django vẫn đóng vai trò **Directory Service** (Lưu trữ Public Keys và chuyển tiếp Ciphertext).

### A. Model `UserPreKeyBundle` (Phục vụ bắt tay X3DH cho Chat 1-1)
Lưu trữ các Public Keys công khai của từng User:
- `user`: `OneToOneField(User)`
- `identity_key`: `TextField` (Public Key Ed25519 xác thực danh tính).
- `signed_prekey`: `TextField` (Public Key X25519 đã ký chữ ký số).
- `signed_prekey_signature`: `TextField` (Chữ ký số xác nhận).
- `one_time_prekeys`: `JSONField` (Danh sách các Public Key dùng 1 lần, tự động tiêu thụ khi tạo session chat 1-1 mới).

### B. Model `MLSKeyPackage` (Phục vụ bắt tay MLS cho Nhóm Chat)
Lưu trữ KeyPackages công khai để mời thành viên vào Nhóm Chat E2EE:
- `user`: `ForeignKey(User)`
- `key_package_data`: `TextField` (Base64 encoded MLS KeyPackage).
- `ciphersuite`: `CharField` (Mã thuật toán, ví dụ `MLS_128_X25519_AES128GCM_SHA256_Ed25519`).

### C. Model `E2EERoom` & `E2EEMessage` (Chỉ lưu Ciphertext)
- `room_id`: `UUID`
- `sender_id`: `BigInteger`
- `ciphertext`: `TextField` (Nội dung đã mã hóa hoàn toàn ở máy gửi).
- `nonce_iv`: `CharField` (Vector khởi tạo cho AES-256-GCM).
- `ratchet_header`: `JSONField` (Thông tin Header xoay vòng khóa cho 1-1).
- `mls_epoch`: `BigInteger` (Epoch của nhóm MLS cho Nhóm Chat).

---

## 3. Luồng Hoạt Động Chi Tiết (E2EE Workflows)

### Luồng 1: Chat 1-1 (Double Ratchet Protocol)
1. **User A muốn nhắn tin cho User B**:
   - User A gọi API Backend `GET /api/v1/chats/prekey-bundle/{user_b_id}/`.
   - User A nhận `IdentityKey_B`, `SignedPrekey_B`, và 1 `OneTimePrekey_B`.
2. **Bắt tay X3DH phía Client (Flutter)**:
   - Flutter App của User A thực hiện tính toán Elliptic-curve Diffie-Hellman (ECDH) tạo ra **Master Shared Key**.
3. **Gửi tin nhắn**:
   - Flutter App dùng thuật toán **Double Ratchet** (khóa liên tục thay đổi sau mỗi tin nhắn) mã hóa văn bản bằng `AES-256-GCM`.
   - Gửi `ciphertext` qua WebSocket đến Backend.
4. **Nhận tin nhắn**:
   - Backend đẩy `ciphertext` sang User B.
   - Flutter App của User B dùng `IdentityKey_A` và `Double Ratchet` giải mã hiển thị văn bản thuần lên màn hình.

### Luồng 2: Nhóm Chat (MLS RFC 9420 Protocol)
1. **Khởi tạo Nhóm Chat E2EE**:
   - Người tạo nhóm lấy `MLSKeyPackage` của tất cả thành viên được mời từ Backend.
   - Khởi tạo cây **TreeKEM** tạo khóa nhóm chung `GroupContext`.
2. **Gửi tin nhắn nhóm**:
   - Thành viên mã hóa bằng khóa nhóm ở `Epoch` hiện tại.
   - Gửi `ciphertext` tới tất cả thành viên trong nhóm.
3. **Thêm/Xóa thành viên khỏi Nhóm**:
   - Khi xóa 1 người ra khỏi nhóm ➔ Trưởng nhóm thực hiện `UpdateCommit` xoay epoch mới ➔ Người bị xóa **không bao giờ** đọc được các tin nhắn nhóm trong tương lai!

---

## 4. Kế Hoạch Triển Khai Theo Các Bước (Khi Đến Phase 2)

1. **Bước 1: Thiết lập Tầng Mạng & Storage phía Flutter FE**:
   - Tích hợp `flutter_secure_storage` lưu trữ an toàn `IdentityKey` (Ed25519) và `DH Private Key` (X25519) trong iOS Keychain / Android Keystore.
   - Cấu hình Certificate Pinning chống nghe lén TLS.
2. **Bước 2: Xây dựng Module `apps.chats` phía Backend (Django REST)**:
   - Tạo các Models `UserPreKeyBundle`, `MLSKeyPackage`, `Room`, `RoomMember`, `Message`.
   - Viết REST API hỗ trợ Upload/Download Public Key Bundles và KeyPackages.
3. **Bước 3: Xây dựng Realtime WebSocket Server (Django Channels + Redis)**:
   - Thiết lập WebSocket consumer tiếp nhận và broadcast `ciphertext` tới các thiết bị.
4. **Bước 4: Tích hợp Thư viện Mã hóa Cụm Client (Flutter)**:
   - Sử dụng thư viện mã hóa E2EE native (libsodium / libsignal / openmls) trên Flutter.
