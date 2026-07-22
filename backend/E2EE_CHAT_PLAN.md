# SnapSpot E2EE Chat Architecture Plan (Phase 2 Roadmap)

Tài liệu này đặc tả chi tiết kiến trúc **Mã hóa Đầu-Đến-Đầu (End-to-End Encryption - E2EE)** cấp Enterprise cho hệ thống Chat 1-1 và Nhóm Chat của **SnapSpot**, đảm bảo nguyên tắc **Zero-Trust Server** (Server Django/PostgreSQL chỉ lưu trữ Ciphertext mã hóa, tuyệt đối không giải mã được nội dung).

Vui lòng tham khảo chi tiết tại tài liệu hệ thống:
👉 [`docs/backend/21-e2ee-chat-architecture.md`](file:///d:/Flutter/snapspot/docs/backend/21-e2ee-chat-architecture.md)

---

## Tóm Tắt Nhanh Mô Hình Database Backend E2EE (`apps.chats`):

1. **`UserPreKeyBundle`**: Lưu trữ `identity_key` (Ed25519) và `signed_prekey` (X25519) phục vụ bắt tay X3DH cho Chat 1-1.
2. **`MLSKeyPackage`**: Lưu trữ `key_package_data` phục vụ bắt tay MLS (RFC 9420) cho Nhóm Chat.
3. **`E2EEMessage`**: Lưu trữ `ciphertext`, `nonce_iv`, `ratchet_header` hoặc `mls_epoch` (Chỉ lưu chuỗi mã hóa vô nghĩa trên DB, server Zero-Knowledge không giải mã được).
