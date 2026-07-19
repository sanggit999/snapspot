# 04 - Non-Functional Requirements

Tài liệu này định nghĩa các yêu cầu phi chức năng (Non-Functional Requirements - NFR) nhằm bảo đảm chất lượng dịch vụ, độ tin cậy và hiệu năng hoạt động của hệ thống SnapSpot.

---

## 1. Yêu cầu về Hiệu năng & Khả năng đáp ứng (Performance & Latency)

- **NFR-101 (Thời gian khởi động)**: Ứng dụng di động phải có thời gian khởi động (Startup time) dưới **2 giây** trong điều kiện mạng bình thường.
- **NFR-102 (Tốc độ tải bảng tin)**: Tải trang Feed đầu tiên phải hoàn tất dưới **1 giây**. Dữ liệu ảnh và video phải được nén tối ưu ở phía Server trước khi phân phối.
- **NFR-103 (Thời gian phản hồi API)**: Ít nhất **95%** các API requests thông thường (không bao gồm upload media) phải được Backend xử lý và phản hồi dưới **500ms**.
- **NFR-104 (Truyền tải media)**: Áp dụng cơ chế **Lazy Loading** (chỉ tải ảnh khi hiển thị trên màn hình) và **Infinite Scroll** (tải thêm dữ liệu khi cuộn đến cuối trang) để tối ưu dung lượng RAM và băng thông thiết bị di động.
- **NFR-105 (Caching phía client)**: Sử dụng cơ sở dữ liệu cục bộ (Hive) trên thiết bị di động để lưu trữ tạm thời (cache) thông tin người dùng và các bài đăng gần đây, giúp ứng dụng có thể hiển thị dữ liệu ngay cả khi mất kết nối mạng.

---

## 2. Yêu cầu về Bảo mật (Security)

- **NFR-201 (Mã hóa dữ liệu truyền tải)**: Toàn bộ dữ liệu truyền tải giữa Client và Server bắt buộc phải đi qua giao thức bảo mật **HTTPS** (TLS 1.2 hoặc cao hơn) và **WSS** (Secure WebSocket).
- **NFR-202 (Mã hóa dữ liệu lưu trữ)**:
  - Mật khẩu người dùng ở database phải được băm bằng thuật toán an toàn như **bcrypt** hoặc **PBKDF2**.
  - Các thông tin nhạy cảm lưu dưới client (Access Token, Refresh Token) bắt buộc phải lưu trong vùng nhớ an toàn **Flutter Secure Storage** (Keychain trên iOS và Keystore/EncryptedSharedPreferences trên Android).
- **NFR-203 (Xác thực & Xoay vòng Token)**:
  - Sử dụng cơ chế xác thực JWT với Access Token thời hạn ngắn (15 phút) và Refresh Token thời hạn dài (30 ngày).
  - Áp dụng cơ chế xoay vòng Refresh Token (Refresh Token Rotation) để ngăn chặn việc sử dụng lại token đã bị đánh cắp.
- **NFR-204 (Rate Limiting)**: Các API nhạy cảm (Đăng nhập, gửi OTP, đăng ký) phải bị giới hạn tần suất yêu cầu (ví dụ: tối đa 5 requests/phút từ cùng một địa chỉ IP) để chống tấn công brute-force.
- **NFR-205 (Kiểm soát phân quyền - BOLA/IDOR)**: Server bắt buộc phải kiểm tra quyền sở hữu tài nguyên đối với mọi request thay đổi dữ liệu (PUT/PATCH/DELETE).

---

## 3. Yêu cầu về Độ tin cậy & Tính sẵn sàng (Availability & Reliability)

- **NFR-301 (Uptime)**: Hệ thống Backend phải bảo đảm độ sẵn sàng hoạt động tối thiểu **99.9%** (Uptime) trong suốt cả năm (cho phép tối đa khoảng 8.76 giờ downtime ngoại tuyến).
- **NFR-302 (Sao lưu dữ liệu)**: Dữ liệu cơ sở dữ liệu PostgreSQL phải được sao lưu tự động hàng ngày (Daily Backup) và lưu trữ riêng biệt tại một máy chủ vật lý hoặc vùng dịch vụ khác (Cross-region).

---

## 4. Khả năng mở rộng (Scalability)

- **NFR-401 (Hỗ trợ CDN)**: Toàn bộ tệp tin hình ảnh, video của người dùng phải được phân phối qua mạng lưới phân phối nội dung (CDN) để giảm tải cho máy chủ lưu trữ gốc (MinIO) và tăng tốc độ tải file cho người dùng ở các khu vực địa lý khác nhau.
- **NFR-402 (Mở rộng dịch vụ)**: Hệ thống Backend phải được đóng gói bằng **Docker** để sẵn sàng chuyển đổi và triển khai tự động trên Kubernetes cluster khi số lượng người dùng đồng thời tăng cao.

---

## 5. Trải nghiệm & Bản địa hóa (Usability & Localization)

- **NFR-501 (Bản địa hóa)**: Ứng dụng phải hỗ trợ đầy đủ 2 ngôn ngữ ban đầu là **tiếng Việt** và **tiếng Anh**, tự động nhận diện ngôn ngữ hệ thống của thiết bị di động.
- **NFR-502 (Giao diện Dark Mode)**: Hỗ trợ chuyển đổi mượt mà giữa chế độ sáng (Light Mode) và chế độ tối (Dark Mode) theo cấu hình hệ điều hành của người dùng.