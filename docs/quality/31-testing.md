# 31 - Testing

Tài liệu này đặc tả quy chuẩn viết và vận hành các bài kiểm thử tự động (Automated Testing) cho cả hai phân hệ Frontend và Backend của SnapSpot.

---

## 1. Quy chuẩn Kiểm thử Frontend (Flutter)

Mục tiêu kiểm thử di động nhằm bảo đảm độ ổn định của các Use Cases nghiệp vụ và các Widgets giao diện dùng chung.

### 1.1. Viết Unit Test cho Logic (Domain/Usecases/Notifiers)
- **Cấu trúc bài viết**: Tuân thủ nghiêm ngặt mô hình **AAA (Arrange - Act - Assert)**:
  - **Arrange**: Chuẩn bị dữ liệu đầu vào, khởi tạo các mock dependencies.
  - **Act**: Kích hoạt hàm/hành động cần kiểm thử.
  - **Assert**: Kiểm tra kết quả đầu ra có khớp với mong đợi không.
- **Thư viện Mocking**: Sử dụng **`mocktail`** hoặc **`mockito`** để giả lập các cuộc gọi mạng từ Repository/DataSource.
- *Ví dụ*:
  ```dart
  class MockAuthRepository extends Mock implements AuthRepository {}

  void main() {
    late LoginUseCase loginUseCase;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(mockAuthRepository);
    });

    test('Đăng nhập thành công trả về thực thể User', () async {
      // 1. Arrange
      final user = User(id: '1', email: 'test@email.com');
      when(() => mockAuthRepository.login('test@email.com', 'pwd123'))
          .thenAnswer((_) async => user);

      // 2. Act
      final result = await loginUseCase.execute('test@email.com', 'pwd123');

      // 3. Assert
      expect(result, equals(user));
      verify(() => mockAuthRepository.login('test@email.com', 'pwd123')).called(1);
    });
  }
  ```

### 1.2. Viết Widget Test (Kiểm thử Giao diện)
- Sử dụng công cụ `WidgetTester` tích hợp sẵn trong Flutter SDK.
- Kiểm thử các widgets độc lập (ví dụ: `AppButton` có hiển thị spinner khi `isLoading = true` không).
- Mô phỏng tương tác vuốt, chạm của người dùng để kiểm tra luồng phản hồi.

---

## 2. Quy chuẩn Kiểm thử Backend (Django)

Backend viết test dựa trên framework kiểm thử tích hợp sẵn của Django (`django.test`).

### 2.1. Kiểm thử API Endpoints (Integration Tests)
- Kế thừa từ lớp `APITestCase` của Django REST Framework.
- Sử dụng `APIClient` để giả lập các HTTP Requests thực tế (GET, POST, PUT, DELETE).
- Kiểm tra tính đúng đắn của HTTP Status Code, định dạng JSON trả về, và tính bảo mật phân quyền.
- *Ví dụ*:
  ```python
  from django.urls import reverse
  from rest_framework import status
  from rest_framework.test import APITestCase
  from django.contrib.auth import get_user_model

  class PostAPITests(APITestCase):
      def setUp(self):
          self.user = get_user_model().objects.create_user(
              username='testuser', email='test@test.com', password='password123'
          )
          self.client.force_authenticate(user=self.user)
          self.create_url = reverse('post-list') # /api/v1/posts/

      def test_create_post_success(self):
          data = {'caption': 'Ảnh chụp đẹp', 'latitude': 21.0285, 'longitude': 105.8524}
          response = self.client.post(self.create_url, data, format='json')
          self.assertEqual(response.status_code, status.HTTP_201_CREATED)
          self.assertTrue(response.data['success'])
  ```

### 2.2. Giả lập dịch vụ bên ngoài (Mocking External Services)
- Sử dụng thư viện `unittest.mock` của Python để giả lập phản hồi từ các API bên thứ ba (như Firebase FCM Server, MinIO Storage, Google Maps API) để các bài test có thể chạy offline độc lập và nhanh chóng.
- **Chỉ tiêu chất lượng**: Độ phủ mã nguồn (Code Coverage) tối thiểu đạt **70%** đối với các nghiệp vụ chính trước khi được phép merge code vào nhánh `main`.