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
- **HTTPS/TLS**: Bắt buộc sử dụng HTTPS với TLS 1.2 trở lên cho toàn bộ kết nối API và giao diện Web/Mobile. Hủy bỏ hoặc tự động redirect các kết nối HTTP thường.
- **JWT + Refresh Token Rotation**:
  - Access Token có thời gian sống ngắn (ví dụ: 15 phút).
  - Sử dụng cơ chế xoay vòng Refresh Token (Refresh Token Rotation) để giảm thiểu rủi ro khi token bị đánh cắp. Khi sử dụng Refresh Token cũ, lập tức thu hồi toàn bộ phiên đăng nhập liên quan.

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
