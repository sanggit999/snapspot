---
name: security-rules
description: Quy chuẩn bảo mật hệ thống bao gồm xác thực JWT, phân quyền RBAC, kiểm tra BOLA/IDOR, chống tấn công SQLi/XSS/CSRF/SSRF, cấu hình CORS, Rate Limiting, Logging và quản lý Secrets.
version: 1.0.0
author: Antigravity
tags:
  - security
  - devsecops
  - authentication
  - compliance
---

# Quy tắc Bảo mật và Vận hành Hệ thống

## Tổng quan
Kỹ năng này quy định các tiêu chuẩn bảo mật bắt buộc đối với toàn bộ hệ thống (bao gồm cả Frontend, Backend và hạ tầng dịch vụ) nhằm bảo vệ dữ liệu người dùng, ngăn chặn các cuộc tấn công mạng và duy trì tính sẵn sàng cao của hệ thống.

## Khi nào cần sử dụng
- Khi phát triển các tính năng liên quan đến xác thực, phân quyền hoặc xử lý thông tin nhạy cảm.
- Khi cấu hình hạ tầng mạng, máy chủ, CORS, Rate Limiting hoặc quản lý biến môi trường.
- Trước khi release/phát hành phiên bản mới của phần mềm.

## Các quy tắc Bảo mật chính

### 1. Truyền thông an toàn & Xác thực (Authentication)
- **HTTPS/TLS**: Bắt buộc sử dụng HTTPS với TLS 1.2/1.3 trở lên cho toàn bộ kết nối API và giao diện Web/Mobile. Hủy bỏ hoặc tự động redirect các kết nối HTTP thường.
- **SSL Pinning (Certificate / Public Key Pinning)**: 
  - Triển khai SSL Pinning (hoặc Public Key Pinning) trên ứng dụng Flutter/Mobile đối với các endpoint quan trọng.
  - Ngăn chặn triệt để các cuộc tấn công Man-In-The-Middle (MITM) thông qua các Chứng chỉ CA giả mạo hoặc mạng Wifi công cộng không an toàn.
- **JWT + Refresh Token Rotation**:
  - Access Token có thời gian sống ngắn (ví dụ: 15 phút).
  - Sử dụng cơ chế xoay vòng Refresh Token (Refresh Token Rotation) để giảm thiểu rủi ro khi token bị đánh cắp. Khi sử dụng Refresh Token cũ, lập tức thu hồi toàn bộ phiên đăng nhập liên quan.

### 1.1. Bảo mật Lưu trữ & Mã hóa dữ liệu di động (Mobile & Client Security Standard 2026)
- **Secure Token Storage (`flutter_secure_storage`)**:
  - Bắt buộc sử dụng **`flutter_secure_storage`** để lưu trữ Access Token, Refresh Token, Session Credentials và API Keys phía Client.
  - Tuyệt đối **KHÔNG** lưu trữ Token, Mật khẩu hoặc Thông tin nhạy cảm vào `SharedPreferences` (Android) hoặc `NSUserDefaults` (iOS) dạng plain-text.
- **Hardware-backed Encryption (Android Keystore / iOS Keychain)**:
  - Khóa mã hóa lưu trữ ở Client phải được bảo vệ trực tiếp bởi **Android Keystore System** (trên Android) và **iOS Keychain Services** (trên iOS), tận dụng phần cứng bảo mật (Secure Enclave / TEE).
- **Mã hóa CSDL Local (SQLCipher)**:
  - Nếu ứng dụng sử dụng SQLite để lưu trữ dữ liệu nhạy cảm offline (như lịch sử chat, thông tin giao dịch, dữ liệu cá nhân), bắt buộc phải tích hợp mã hóa **SQLCipher** (Mã hóa toàn bộ file database).
- **Mã hóa File & Dữ liệu Offline (AES-256)**:
  - Sử dụng thuật toán mã hóa đối xứng tiêu chuẩn **AES-256** đối với mọi dữ liệu đệm (cache), file tải xuống hoặc dữ liệu offline quan trọng trước khi ghi xuống đĩa cứng thiết bị.
- **Tuyệt đối Không Hardcode Secrets**:
  - Không hardcode API key, mảng bí mật, mật khẩu, JWT secrets hay private keys trực tiếp trong mã nguồn Dart/Python.
  - Sử dụng biến môi trường (`.env`), `String.fromEnvironment` trong quá trình build, hoặc tải động từ Secret Manager bảo mật.
- **Không Ghi Dữ liệu Nhạy cảm vào Log**:
  - Tuyệt đối **KHÔNG** ghi log JWT Access/Refresh Tokens, Mật khẩu người dùng, thông tin thẻ hoặc dữ liệu cá nhân nhạy cảm (PII) ra màn hình Console, Logcat, Xcode Console, hay gửi lên các nền tảng giám sát lỗi (Crashlytics, Sentry).
- **Tối thiểu hóa & Tự động Xóa Dữ liệu (Data Minimization & Retention Policy)**:
  - Chỉ thu thập và lưu trữ lượng dữ liệu cá nhân tối thiểu thực sự cần thiết cho nghiệp vụ của ứng dụng.
  - Khi người dùng bấm **Đăng xuất (Logout)** hoặc khi dữ liệu đệm hết hạn, bắt buộc phải thực hiện quy trình dọn dẹp: Xóa sạch `flutter_secure_storage`, dọn dẹp SQLCipher DB, và xóa hoàn toàn các file cache nhạy cảm khỏi thiết bị.

### 2. Phân quyền & Kiểm soát truy cập (Authorization)

- **RBAC + Permission**: Áp dụng phân quyền dựa trên vai trò (Role-Based Access Control) kết hợp phân quyền chi tiết (Permission-based) để kiểm soát chặt chẽ từng hành động API.
- **Ownership Check (Chống lỗi BOLA/IDOR)**: Luôn kiểm tra quyền sở hữu tài nguyên ở phía Server trước khi cho phép xem, sửa hoặc xóa dữ liệu (ví dụ: đảm bảo User A không thể cập nhật Profile của User B thông qua việc đổi ID trên URL/Body).

### 3. Kiểm soát dữ liệu đầu vào & Phòng chống tấn công
- **Validate toàn bộ Input**: Kiểm tra kiểu dữ liệu, độ dài, định dạng, whitelist ký tự cho toàn bộ dữ liệu đầu vào (cả ở Frontend và Backend).
- **Phòng chống các lỗ hổng OWASP phổ biến**:
  - **SQL Injection**: Luôn sử dụng Parameterized Queries hoặc ORM an toàn. Tuyệt đối không cộng chuỗi SQL trực tiếp từ input của user.
  - **XSS**: Lọc và Escaped dữ liệu hiển thị (HTML escaping). Sử dụng Content Security Policy (CSP) ở Frontend.
  - **CSRF**: Sử dụng Anti-CSRF Tokens cho các session dựa trên cookie, hoặc cấu hình cookie `SameSite=Strict/Lax`.
  - **SSRF**: Giới hạn dải IP mà Server có thể gửi request nội bộ; validate kỹ càng các URL được người dùng cung cấp trước khi Server thực hiện fetch.

### 4. Cấu hình hạ tầng & Kiểm soát lưu lượng
- **CORS theo Allow-list**: Không bao giờ sử dụng `Access-Control-Allow-Origin: *` trong môi trường Production. Luôn sử dụng một Allow-list các domain được tin cậy.
- **Rate Limiting**: Cấu hình giới hạn tần suất gửi yêu cầu (Rate Limit) cho từng IP hoặc từng tài khoản người dùng tại Gateway hoặc Web Server để chống tấn công brute-force và DDoS.
- **Security Headers**: Bật các HTTP Headers bảo mật cần thiết như:
  - `Strict-Transport-Security` (HSTS)
  - `X-Frame-Options: DENY` (Chống Clickjacking)
  - `X-Content-Type-Options: nosniff`
  - `Referrer-Policy: no-referrer-when-downgrade`

### 5. Vận hành, Quản lý tài nguyên & Giám sát
- **Logging & Monitoring**:
  - Ghi nhận logs cho mọi hành động nhạy cảm (đăng nhập, thay đổi quyền, thanh toán) nhưng tuyệt đối **không ghi log thông tin nhạy cảm** (mật khẩu, số thẻ tín dụng, tokens).
  - Thiết lập hệ thống giám sát cảnh báo tự động khi phát hiện lượng lỗi hoặc request tăng đột biến.
- **Secret Management**:
  - Tuyệt đối không lưu mật khẩu, API key, JWT secret trong mã nguồn.
  - Sử dụng biến môi trường (`.env`) hoặc các dịch vụ quản lý secret chuyên nghiệp (HashiCorp Vault, AWS Secrets Manager, Google Secret Manager).
- **Dependency Scanning**: Tự động quét các thư viện phụ thuộc hàng tuần (ví dụ: `snyk`, `npm audit`, hoặc GitHub Dependabot) để phát hiện và vá sớm các lỗ hổng thư viện bên thứ ba.
- **Backup & Disaster Recovery**: Thiết lập quy trình tự động sao lưu dữ liệu (Database, Storage) hàng ngày và lưu trữ offline/cross-region. Thường xuyên diễn tập khôi phục dữ liệu để chuẩn bị cho các tình huống khẩn cấp.

### 6. Quy trình phát hành (Release Lifecycle)
- Luôn thực hiện quét bảo mật tự động (SAST/DAST) và kiểm thử bảo mật thủ công (Security Testing) trước khi phát hành phiên bản mới.

## Hướng dẫn thực hiện cho Agent
1. Khi triển khai tính năng hoặc cấu hình máy chủ, rà soát lại các mục trong danh sách bảo mật trên.
2. Tuyệt đối không commit các file cấu hình chứa secrets nhạy cảm lên Git.
3. Khi viết truy vấn cơ sở dữ liệu, đảm bảo sử dụng ORM hoặc tham số hóa đầy đủ để tránh SQL Injection.
