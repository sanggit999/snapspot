# 06 - Folder Structure

Tài liệu này quy chuẩn hóa cấu trúc thư mục (Folder Structure) mã nguồn cho cả dự án **Frontend (Flutter)** và **Backend (Django)** của SnapSpot.

---

## 1. Cấu trúc thư mục Frontend (Flutter)

Mã nguồn Frontend tuân thủ mô hình **Clean Architecture chia theo Feature**. Mỗi tính năng (Feature) chứa đầy đủ các phân lớp dữ liệu (Data), nghiệp vụ (Domain) và giao diện (Presentation).

```text
lib/
├── main.dart                  # Điểm khởi chạy ứng dụng
├── app.dart                   # Cấu hình MaterialApp, GoRouter và Global Theme
├── core/                      # Các thành phần dùng chung cho toàn bộ dự án
│   ├── constants/             # Khai báo màu sắc, kích thước, chuỗi tĩnh
│   ├── errors/                # Định nghĩa các lớp lỗi (Failure, Exception)
│   ├── network/               # Cấu hình API client (Dio), interceptors
│   ├── theme/                 # Cấu hình ThemeData (Light/Dark mode)
│   └── utils/                 # Các hàm tiện ích bổ trợ (định dạng ngày, tiền tệ)
└── features/                  # Danh sách các mô-đun tính năng chính
    ├── auth/                  # Tính năng Xác thực
    │   ├── data/              # Lớp dữ liệu của tính năng
    │   │   ├── datasources/   # Gọi API từ remote server hoặc đọc cache local
    │   │   ├── models/        # Định nghĩa các lớp Data Transfer Object (DTO)
    │   │   └── repositories/  # Triển khai cụ thể các interface repository
    │   ├── domain/            # Lớp nghiệp vụ cốt lõi
    │   │   ├── entities/      # Lớp thực thể nghiệp vụ tinh khiết
    │   │   ├── repositories/  # Định nghĩa interface (mẫu hợp đồng dữ liệu)
    │   │   └── usecases/      # Các hành động nghiệp vụ cụ thể (Đăng nhập, Đăng ký)
    │   └── presentation/      # Lớp hiển thị UI & điều khiển logic
    │       ├── blocs/         # Quản lý trạng thái màn hình (BLoC / Cubit)
    │       ├── screens/       # Các màn hình chính (LoginScreen, RegisterScreen)
    │       └── widgets/       # Các sub-widgets nhỏ bổ trợ riêng cho feature
    ├── feed/                  # Tính năng Bảng tin hình ảnh
    ├── map/                   # Tính năng Bản đồ tương tác & vị trí
    ├── camera/                # Tính năng Chụp và xử lý ảnh tải lên
    └── profile/               # Tính năng Quản lý thông tin cá nhân
```

---

## 2. Cấu trúc thư mục Backend (Django)

Mã nguồn Backend tổ chức theo cấu trúc ứng dụng phân tách (App-based) kết hợp lớp nghiệp vụ (Service Layer) để tách rời logic nghiệp vụ phức tạp ra khỏi phần điều khiển View.

```text
backend/
├── manage.py                  # Công cụ dòng lệnh quản lý Django
├── requirements.txt           # Danh sách thư viện Python phụ thuộc
├── Dockerfile                 # Dockerfile cho Django web service
├── docker-compose.yml         # File cấu hình docker-compose môi trường dev
├── config/                    # Cấu hình chung của dự án Django
│   ├── __init__.py
│   ├── settings.py            # Cài đặt môi trường, DB, Redis, Celery
│   ├── urls.py                # Định tuyến URL chính của hệ thống
│   ├── wsgi.py                # Cấu hình máy chủ Web WSGI
│   ├── asgi.py                # Cấu hình máy chủ Web ASGI (Daphne/Channels)
│   └── routing.py             # Định tuyến kết nối WebSocket
└── apps/                      # Các ứng dụng thành phần nghiệp vụ
    ├── authentication/        # Quản lý Users, JWT, Đăng ký/Đăng nhập
    │   ├── models.py          # Thiết kế bảng dữ liệu CustomUser
    │   ├── views.py           # API endpoints nhận request và trả response
    │   ├── serializers.py     # Chuyển đổi kiểu dữ liệu JSON sang Object
    │   ├── services.py        # Chứa logic xác thực, tạo token, gửi OTP
    │   └── urls.py
    ├── posts/                 # Quản lý Bài viết, Lượt thích, Bình luận
    │   ├── models.py          # Bảng Post, Comment, Like
    │   ├── views.py
    │   ├── services.py        # Logic tạo bài đăng, nén ảnh, tăng view
    │   └── serializers.py
    ├── locations/             # Quản lý Điểm check-in & Bản đồ
    │   ├── models.py          # Bảng Spot lưu tọa độ địa lý PostGIS
    │   ├── services.py        # Tính khoảng cách, lọc tọa độ lân cận
    │   └── views.py
    ├── chats/                 # Hệ thống Trò chuyện thời gian thực
    │   ├── consumers.py       # Xử lý kết nối, gửi/nhận tin nhắn qua WebSocket
    │   ├── models.py          # Bảng Message, ChatRoom
    │   └── serializers.py
    └── notifications/         # Quản lý Thông báo đẩy (FCM)
        ├── services.py        # Gửi payload thông báo qua FCM SDK
        └── models.py
```