# 01 - Glossary

Tài liệu này định nghĩa các thuật ngữ, khái niệm và từ viết tắt được sử dụng trong hệ thống SnapSpot.

---

## 1. Thuật ngữ Nghiệp vụ (Business Terms)

| Thuật ngữ | Ý nghĩa |
| :--- | :--- |
| **SnapSpot** | Tên ứng dụng mạng xã hội chia sẻ ảnh dựa trên vị trí. |
| **Spot (Địa điểm)** | Một vị trí địa lý cụ thể (quán cafe, điểm du lịch, nhà hàng, danh lam thắng cảnh) được đính kèm vào bài đăng của người dùng. |
| **Feed (Bảng tin)** | Trang hiển thị danh sách các bài viết chia sẻ từ cộng đồng hoặc từ những người dùng đang theo dõi. |
| **Nearby Feed (Bảng tin lân cận)** | Bảng tin lọc danh sách bài viết dựa trên vị trí hiện tại của thiết bị trong một bán kính cụ thể. |
| **Check-in** | Hành động xác nhận sự hiện diện của người dùng tại một Spot bằng cách đăng ảnh đính kèm tọa độ GPS. |
| **Story** | Tin ngắn chia sẻ dạng hình ảnh hoặc video ngắn biến mất sau 24 giờ. |
| **Distance (Khoảng cách)** | Khoảng cách đường chim bay tính từ vị trí GPS hiện tại của người dùng đến tọa độ của bài viết/địa điểm. |

---

## 2. Thuật ngữ Kỹ thuật (Technical Terms)

| Thuật ngữ | Ý nghĩa |
| :--- | :--- |
| **BOLA / IDOR** | Broken Object Level Authorization / Insecure Direct Object Reference. Lỗi bảo mật cho phép người dùng truy cập hoặc thay đổi tài nguyên của người khác bằng cách thay đổi ID trong API request. |
| **JWT** | JSON Web Token. Một phương thức bảo mật dùng để xác thực người dùng dưới dạng một chuỗi mã hóa. |
| **Refresh Token Rotation** | Cơ chế xoay vòng Refresh Token: Mỗi khi Refresh Token được dùng để lấy Access Token mới, một cặp token mới sẽ được sinh ra và token cũ bị thu hồi. |
| **Presigned URL** | Đường dẫn tải lên/tải xuống được ký sẵn bởi Storage Server (MinIO/S3), cho phép Client tải ảnh trực tiếp lên Storage mà không cần đi qua Backend Server. |
| **PostGIS** | Phần mở rộng của cơ sở dữ liệu PostgreSQL dùng để lưu trữ và truy vấn dữ liệu không gian địa lý (GIS). |
| **FCM** | Firebase Cloud Messaging. Dịch vụ của Google dùng để gửi thông báo đẩy (Push Notification) đến thiết bị di động. |
| **WS (WebSocket)** | Giao thức truyền thông hai chiều thời gian thực giữa Client và Server (sử dụng cho tính năng Chat). |
| **BLoC / Cubit** | Thư viện quản lý trạng thái (State Management) chính thức trong Flutter, giúp tách biệt giao diện (UI) và logic nghiệp vụ. |
| **Celery** | Thư viện hàng đợi tác vụ bất đồng bộ (Asynchronous Task Queue) cho Python, dùng để xử lý các tác vụ nền trong Django. |