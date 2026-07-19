# 35 - Release Notes

Tài liệu này ghi nhận lịch sử các phiên bản phát hành (Release Notes) và nhật ký cập nhật của hệ thống SnapSpot.

---

## 🚀 Phiên bản v1.0.0-draft (15-07-2026)

Đây là phiên bản dự thảo đầu tiên xác lập toàn bộ kiến trúc, thiết kế và quy chuẩn phát triển của dự án SnapSpot trước khi bước vào giai đoạn lập trình.

### 🌟 Các tài liệu và cấu trúc đã hoàn thành:
1. **Thiết lập Sơ đồ Cấu trúc Tài liệu chính thức (`docs/`)**:
   - Hoàn thành đầy đủ 36 tệp tài liệu Markdown mô tả chi tiết: Kiến trúc hệ thống, quy chuẩn API, thiết kế Database PostGIS, cơ chế xác thực JWT RTR, hệ thống Chat WebSocket, luồng tải ảnh Presigned URL, kiểm thử tự động, quy chuẩn bảo mật (OWASP, BOLA/IDOR), Dockerization và quy trình tự động hóa CI/CD qua GitHub Actions.
   - Tạo tệp chỉ mục **`docs/README.md`** hỗ trợ liên kết nhanh.
2. **Thiết lập Khung Quy chuẩn phát triển cho AI Agent (`.agent/skills/`)**:
   - **`flutter-code-quality`**: Quy chuẩn Clean Architecture và cấu trúc code Flutter.
   - **`flutter-widget-testing`**: Quy chuẩn viết unit test và widget test.
   - **`flutter-state-management`**: Quy chuẩn sử dụng BLoC (Cubit) quản lý trạng thái.
   - **`comment-rules`**: Quy tắc viết comment bằng tiếng Việt rõ ràng, tập trung giải thích lý do (Why) thay vì hành động (What).
   - **`import-rules`**: Bắt buộc import tuyệt đối (package:snapspot/...), cấm relative import (`../`).
   - **`api-design-rules`**: Chuẩn hóa RESTful API.
   - **`security-rules`**: Các nguyên tắc bảo mật và vận hành hệ thống.

---

## 📈 Lịch sử các phiên bản dự kiến tiếp theo:
- **v1.0.0-beta.1 (Dự kiến 09/2026)**: Hoàn thành phiên bản MVP chạy thực tế trong nội bộ (đăng nhập, chụp ảnh kèm GPS, hiển thị bản đồ và bảng tin lân cận).
- **v1.0.0-stable (Dự kiến 10/2026)**: Bản phát hành chính thức đầu tiên lên Google Play Store và Apple App Store.
- **v2.0.0 (Dự kiến 12/2026)**: Bản cập nhật lớn bổ sung Chat thời gian thực và Stories 24h.