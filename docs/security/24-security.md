# 24 - Security

Tài liệu này đặc tả các quy chuẩn bảo mật (Security Standards) bắt buộc phải tuân thủ khi thiết kế, triển khai và vận hành hệ thống SnapSpot.

---

## 1. Bảo mật đường truyền & Kết nối (Network Security)

- **Bắt buộc HTTPS/TLS**: Toàn bộ kết nối giữa các thành phần (Client -> Gateway, Gateway -> Backend, Backend -> MinIO) đều phải sử dụng giao thức mã hóa SSL/TLS 1.2 hoặc 1.3.
- **Cấu hình CORS (Cross-Origin Resource Sharing)**:
  - Tuyệt đối không dùng cấu hình mở `CORS_ORIGIN_ALLOW_ALL = True` trên môi trường Production.
  - Chỉ cho phép các domain tin cậy nằm trong danh sách Allow-list (ví dụ: tên miền web chính thức của SnapSpot, hệ thống quản trị admin portal).
- **Rate Limiting**:
  - Tích hợp rate limit trên Nginx ở tầng mạng và DRF Throttle ở tầng ứng dụng.
  - Đối với API thông thường: Tối đa 60 requests/phút từ mỗi IP.
  - Đối với API nhạy cảm (Login, Register, OTP): Tối đa 5 requests/phút.

---

## 2. Phòng chống các lỗ hổng bảo mật phổ biến (OWASP Top 10)

### 2.1. Chống SQL Injection
- Tuyệt đối không sử dụng các câu lệnh truy vấn SQL thô dưới dạng cộng chuỗi (`f"SELECT * FROM ... WHERE id = '{user_id}'"`).
- Bắt buộc sử dụng hệ thống **Django ORM** để tương tác với cơ sở dữ liệu. Django ORM tự động sử dụng truy vấn tham số hóa (Parameterized Queries) để loại bỏ nguy cơ SQLi.

### 2.2. Chống XSS (Cross-Site Scripting)
- Toàn bộ dữ liệu đầu vào dạng chữ gửi lên từ người dùng (Caption bài viết, nội dung comment) bắt buộc phải được làm sạch (Sanitize) ở Backend trước khi lưu vào Database. Loại bỏ các thẻ HTML nhạy cảm (như `<script>`, `<iframe>`).

### 2.3. Chống CSRF (Cross-Site Request Forgery)
- Đối với API thiết kế dạng Stateless (Xác thực qua Header JWT), nguy cơ CSRF rất thấp.
- Đối với các trang Admin Portal sử dụng session cookie, bắt buộc phải đính kèm **CSRF Token** trong mỗi request POST/PUT/DELETE và cấu hình cookie ở chế độ `SameSite=Lax` hoặc `SameSite=Strict`.

### 2.4. Chống SSRF (Server-Side Request Forgery)
- Khi Backend cần tải dữ liệu từ một liên kết do người dùng cung cấp (ví dụ: lấy ảnh profile từ link mạng xã hội bên thứ ba):
  - Phải kiểm tra (validate) URL gửi lên. Chỉ cho phép các giao thức `http` và `https`.
  - Chặn các yêu cầu gọi đến dải IP nội bộ hoặc mạng nội bộ (như `127.0.0.1`, `192.168.*.*`, `10.*.*.*`).

---

## 3. Cấu hình Security Headers (Nginx Gateway)

Bắt buộc cấu hình các HTTP Security Headers sau trên Nginx để tăng cường bảo mật trình duyệt và thiết bị di động:
- **`Strict-Transport-Security` (HSTS)**: Ép buộc trình duyệt luôn giao tiếp bằng HTTPS.
- **`X-Frame-Options`**: Thiết lập `DENY` để chống tấn công Clickjacking.
- **`X-Content-Type-Options`**: Thiết lập `nosniff` để chặn trình duyệt tự ý suy đoán định dạng MIME (MIME-sniffing).
- **`Content-Security-Policy` (CSP)**: Định nghĩa rõ nguồn tải tài nguyên (scripts, styles, images) được phép hoạt động.

---

## 4. Quản lý thông tin nhạy cảm (Secret Management)
- Tuyệt đối **không được commit** các thông tin nhạy cảm (Database Password, JWT Secret Key, Firebase Credentials, S3 Access Keys) vào mã nguồn Git.
- Sử dụng các tệp tin cấu hình môi trường `.env` (được đưa vào danh sách `.gitignore`).
- Trên môi trường production, sử dụng công cụ quản lý bí mật chuyên dụng như **HashiCorp Vault** hoặc cơ chế quản lý Secrets của nhà cung cấp Cloud (AWS Secrets Manager, Docker Secrets).