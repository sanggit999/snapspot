# 07 - Clean Architecture

Tài liệu này đặc tả quy chuẩn áp dụng **Clean Architecture** trong dự án Frontend (Flutter) của SnapSpot.

---

## 1. Nguyên lý cốt lõi (Core Principles)

Mục tiêu chính của Clean Architecture là tách biệt mã nguồn thành các lớp có trách nhiệm riêng biệt, giúp dự án:
- **Độc lập với Framework**: UI có thể thay đổi (từ Flutter sang Web/Desktop) mà không cần viết lại logic nghiệp vụ.
- **Dễ dàng kiểm thử (Testability)**: Các logic nghiệp vụ cốt lõi có thể được kiểm thử đơn độc mà không cần chạy giao diện, gọi API thực tế hay khởi chạy Database.
- **Độc lập dữ liệu**: Logic nghiệp vụ không quan tâm dữ liệu lấy từ PostgreSQL, Firebase hay Local Database (Hive).

### Sơ đồ luồng phụ thuộc (Dependency Rule)
Mối quan hệ phụ thuộc luôn hướng vào trong. Lớp bên trong không có bất kỳ thông tin nào về lớp bên ngoài.
```text
  [ Presentation (UI/Notifier) ] ──> [ Domain (Use Case/Entity) ] <── [ Data (Repository/DataSource) ]
```

---

## 2. Đặc tả các phân lớp (Architecture Layers)

### 2.1. Lớp Nghiệp vụ (Domain Layer)
Đây là lớp quan trọng nhất, chứa toàn bộ nghiệp vụ cốt lõi của ứng dụng. Lớp này là **Dart thuần túy (Pure Dart)**, không được import bất kỳ thư viện Flutter UI nào.

- **Entity (Thực thể)**: Định nghĩa đối tượng nghiệp vụ cốt lõi. Chỉ chứa dữ liệu và logic tự thân của đối tượng, không chứa logic lưu trữ/chuyển đổi dữ liệu.
  - *Ví dụ*: Lớp `User` chứa `id`, `email`, `username`.
- **Repository Interface (Hợp đồng dữ liệu)**: Định nghĩa các phương thức giao tiếp dữ liệu dưới dạng lớp trừu tượng (abstract class).
  - *Ví dụ*: `abstract class AuthRepository { Future<User> login(String email, String password); }`.
- **Use Case (Nghiệp vụ ứng dụng)**: Thực hiện một hành động nghiệp vụ cụ thể bằng cách kết hợp dữ liệu từ một hoặc nhiều Repositories.
  - *Ví dụ*: `LoginUseCase` gọi hàm `login` của `AuthRepository` và thực hiện kiểm tra kiểm duyệt bổ sung.

---

### 2.2. Lớp Dữ liệu (Data Layer)
Lớp này chịu trách nhiệm cung cấp dữ liệu cho lớp Domain. Nó trực tiếp tương tác với môi trường bên ngoài (API, Database).

- **Model (Mẫu dữ liệu DTO)**: Kế thừa từ Entity của lớp Domain nhưng bổ sung các hàm tuần tự hóa/giải tuần tự hóa dữ liệu JSON (`fromJson`, `toJson`).
  - *Ví dụ*: `UserModel extends User` chứa code chuyển đổi JSON.
- **DataSource (Nguồn dữ liệu)**: 
  - **RemoteDataSource**: Gọi API endpoint thông qua Dio client.
  - **LocalDataSource**: Đọc/ghi cache dữ liệu cục bộ sử dụng Hive hoặc Flutter Secure Storage.
- **Repository Implementation (Triển khai cụ thể)**: Lớp thực hiện các hàm đã định nghĩa trong Repository Interface ở Domain Layer. Nó quyết định khi nào lấy dữ liệu từ mạng (Remote), khi nào lấy từ bộ nhớ cục bộ (Local).
  - *Ví dụ*: `AuthRepositoryImpl` triển khai `AuthRepository`.

---

### 2.3. Lớp Giao diện (Presentation Layer)
Lớp này hiển thị giao diện người dùng và nhận tương tác từ họ để cập nhật giao diện.

- **UI (Screens & Widgets)**: Chỉ chứa khai báo giao diện người dùng (Widgets). Nó lắng nghe trạng thái (State) từ Cubit/BLoC để tự động vẽ lại màn hình.
- **State Holder (Cubit / BLoC)**: Quản lý trạng thái của màn hình. Nó nhận các tương tác người dùng gửi từ giao diện, gọi Use Cases tương ứng của Domain Layer và cập nhật trạng thái (State) mới để giao diện thay đổi theo.

---

## 3. Quy tắc phát triển bắt buộc (Development Rules)

- **Rule-1**: Lớp **Domain** tuyệt đối không được import bất kỳ file nào từ lớp **Data** hoặc lớp **Presentation**.
- **Rule-2**: Lớp **Presentation** không được gọi trực tiếp **DataSource**. Mọi tương tác dữ liệu phải đi qua Cubit gọi Use Case hoặc Repository.
- **Rule-3**: Sử dụng cơ chế Tiêm phụ thuộc (Dependency Injection) của **RepositoryProvider** và **BlocProvider** (hoặc `get_it`) để truyền các triển khai cụ thể (`RepositoryImpl`, `DataSource`) vào các Use Cases và Cubits, giúp duy trì tính lỏng lẻo (loose coupling).