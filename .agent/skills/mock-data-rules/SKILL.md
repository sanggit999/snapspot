---
name: mock-data-rules
description: Quy chuẩn tạo và quản lý dữ liệu giả lập (Mock Data) phục vụ cho việc phát triển và viết kiểm thử (Unit/Integration Test) ở cả Frontend (Flutter) và Backend (Django REST Framework).
version: 1.0.0
author: Antigravity
tags:
  - testing
  - mock-data
  - flutter
  - django
  - backend
  - frontend
  - best-practices
---

# Quy chuẩn Quản lý và Tạo Mock Data cho FE & BE

## Tổng quan
Mock Data (Dữ liệu giả lập) đóng vai trò cực kỳ quan trọng trong cả quá trình phát triển độc lập (Frontend phát triển song song khi Backend chưa hoàn thiện API) và viết các bài kiểm thử (Unit Test, Integration Test) tự động. Quy chuẩn này thiết lập cách tổ chức, sinh dữ liệu giả lập chuẩn xác, an toàn và dễ bảo trì cho cả **Frontend (Flutter)** và **Backend (Django REST Framework)**.

## Khi nào cần sử dụng
- **Ở Frontend (Flutter)**: Khi viết Unit Test cho Repositories, BLoC/Riverpod, Service hoặc viết Widget Test cần dữ liệu tĩnh; hoặc khi cần giả lập API Response để dựng UI trước.
- **Ở Backend (Django/DRF)**: Khi viết Unit Test cho Services, Repositories, API Views, cần tạo dữ liệu mẫu trong Database (sử dụng Factory) hoặc mock các tích hợp bên thứ ba (gửi mail, thanh toán, SMS).

---

## 1. Quy chuẩn Mock Data cho Frontend (Flutter)

### 1.1. Sử dụng Mocking Library (`mocktail` hoặc `mockito`)
- Khuyến khích sử dụng **`mocktail`** cho các dự án mới vì nó hỗ trợ cơ chế null-safety tốt, cú pháp ngắn gọn và không yêu cầu chạy lệnh build_runner để tự động tạo code mock như `mockito`.
- Định nghĩa rõ ràng các class Mock kế thừa từ `Mock` và implement interface của class thật.

### 1.2. Tổ chức Mock Fixtures (JSON Files)
- Đối với các Response API phức tạp, hãy lưu dữ liệu thô dưới dạng file `.json` trong thư mục `test/fixtures/` để dễ quản lý và cập nhật.
- Viết một helper class tiện ích để đọc các file JSON này thành dạng String/Map phục vụ test.

### 1.3. Khởi tạo Mock Entities thông qua Factory/Helper Methods
- Tránh hardcode dữ liệu model trực tiếp trong từng file test. Thay vào đó, hãy viết các static method `mock()` hoặc tạo các generator helper class trong thư mục test để khởi tạo nhanh các Model instance với dữ liệu mặc định và cho phép tùy chỉnh thông qua các tham số.

### 1.4. Ví dụ minh họa (Flutter/Dart)

- **Bước 1: Tạo file JSON Fixture** (`test/fixtures/user_profile.json`):
  ```json
  {
    "id": "usr_12345",
    "email": "testuser@example.com",
    "full_name": "Nguyen Van A",
    "avatar_url": "https://example.com/avatar.png"
  }
  ```

- **Bước 2: Viết Helper đọc Fixture & Khởi tạo Model Mock** (`test/helpers/fixture_helper.dart`):
  ```dart
  import 'dart:convert';
  import 'dart:io';
  import 'package:snapspot/features/users/domain/entities/user.dart';

  class FixtureHelper {
    static Map<String, dynamic> getJson(String path) {
      final file = File('test/fixtures/$path');
      return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
    }

    // Helper tạo Entity nhanh với dữ liệu mặc định
    static User makeMockUser({
      String? id,
      String? email,
      String? fullName,
    }) {
      return User(
        id: id ?? 'usr_default',
        email: email ?? 'default@example.com',
        fullName: fullName ?? 'Default Name',
        avatarUrl: 'https://example.com/default.png',
      );
    }
  }
  ```

- **Bước 3: Viết Unit Test sử dụng Mocktail** (`test/features/users/user_repository_test.dart`):
  ```dart
  import 'package:flutter_test/flutter_test.dart';
  import 'package:mocktail/mocktail.dart';
  import 'package:fpdart/fpdart.dart';
  import 'package:snapspot/features/users/domain/repositories/user_repository.dart';
  import 'package:snapspot/features/users/data/datasources/user_remote_datasource.dart';
  import '../../helpers/fixture_helper.dart';

  // Định nghĩa class Mock
  class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

  void main() {
    late MockUserRemoteDataSource mockDataSource;
    late UserRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockUserRemoteDataSource();
      repository = UserRepositoryImpl(remoteDataSource: mockDataSource);
    });

    test('should return User Entity when remote data source is successful', () async {
      // Arrange: Đọc từ JSON fixture
      final jsonMap = FixtureHelper.getJson('user_profile.json');
      final mockModel = UserModel.fromJson(jsonMap);

      when(() => mockDataSource.getUserProfile(any()))
          .thenAnswer((_) async => mockModel);

      // Act
      final result = await repository.getUserProfile('usr_12345');

      // Assert: Repository phải trả về Entity (không phải Model)
      // Mapper (Extension trong data/mappers/) được gọi bên trong Repository
      // Model.toEntity() là Extension method từ user_mapper.dart, không nằm trong UserModel class
      expect(result, isA<Right<Failure, UserEntity>>());
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (entity) {
          expect(entity, isA<UserEntity>()); // Phải là Entity, không phải Model
          expect(entity.email, equals('testuser@example.com'));
        },
      );
      verify(() => mockDataSource.getUserProfile('usr_12345')).called(1);
    });
  }
  ```

---

## 2. Quy chuẩn Mock Data cho Backend (Django REST Framework)

### 2.1. Sử dụng `factory_boy` và `Faker` thay vì Django Fixtures
- **Tuyệt đối tránh** sử dụng Django JSON/YAML fixtures để tạo cơ sở dữ liệu test vì chúng cực kỳ khó bảo trì khi Schema Database thay đổi.
- Sử dụng **`factory_boy`** phối hợp với **`Faker`** để định nghĩa cấu trúc dữ liệu mẫu một cách linh động, tự động tạo các bản ghi liên quan (ForeignKey) và sinh dữ liệu giả lập thực tế (tên, email, địa chỉ, v.v.).

### 2.2. Đóng gói các Factory trong thư mục App
- Đặt file định nghĩa factory tại `tests/factories.py` hoặc thư mục `tests/factories/` bên trong từng Django App tương ứng với Domain đó để đảm bảo tính tự đóng gói.

### 2.3. Mock các tác vụ tích hợp bên ngoài (External Integrations)
- Sử dụng thư viện **`unittest.mock`** (`patch`, `MagicMock`) đi kèm của Python để giả lập hành vi của các dịch vụ bên thứ ba (gửi email, SMS, Payment Gateway như Stripe/ZaloPay, push notification, Amazon S3).
- Không bao giờ được phép gọi API thật của bên thứ ba trong quá trình chạy Unit Test hoặc Integration Test.

### 2.4. Ví dụ minh họa (Django REST Framework)

- **Bước 1: Định nghĩa Factory** (`src/users/tests/factories.py`):
  ```python
  import factory
  from django.contrib.auth import get_user_model
  from faker import Factory as FakerFactory

  User = get_user_model()
  faker = FakerFactory.create('vi_VN') # Hỗ trợ sinh dữ liệu chuẩn tiếng Việt

  class UserFactory(factory.django.DjangoModelFactory):
      class Meta:
          model = User

      email = factory.Sequence(lambda n: f'user{n}@example.com')
      username = factory.Sequence(lambda n: f'user_{n}')
      first_name = factory.LazyAttribute(lambda _: faker.first_name())
      last_name = factory.LazyAttribute(lambda _: faker.last_name())
      is_active = True

      # Đối với quan hệ 1-1 (UserProfile)
      @factory.post_generation
      def create_profile(obj, create, extracted, **kwargs):
          if not create:
              return
          # Giả sử UserProfile tự động được tạo qua logic nghiệp vụ hoặc gọi trực tiếp ở đây
          from src.users.models import UserProfile
          UserProfile.objects.get_or_create(user=obj, address=faker.address())
  ```

- **Bước 2: Viết Test Mock Tích hợp Bên Ngoài** (`src/orders/tests/test_services.py`):
  ```python
  from django.test import TestCase
  from unittest.mock import patch, MagicMock
  from src.users.tests.factories import UserFactory
  from src.orders.services import OrderService

  class OrderServiceTest(TestCase):
      def setUp(self):
          self.user = UserFactory() # Tạo nhanh User và Profile từ Factory

      # Mock hàm gửi email thông báo từ Service để tránh chạy gửi mail thật
      @patch('src.orders.services.NotificationService.send_order_email')
      def test_create_order_success(self, mock_send_email):
          # Setup mock return value
          mock_send_email.return_value = True
          
          items_data = [{'product_id': 1, 'quantity': 2, 'price': 50000}]
          
          # Thực hiện hành động
          order = OrderService.create_order(user=self.user, items_data=items_data)
          
          # Assert
          self.assertEqual(order.user, self.user)
          self.assertEqual(order.total_price, 100000)
          
          # Đảm bảo hàm gửi email được gọi đúng 1 lần với đúng tham số
          mock_send_email.assert_called_once_with(self.user.email, order)
  ```

---

## Hướng dẫn thực hiện cho Agent (Mock Data Checklist)

### Đối với Frontend (Flutter/Dart):
1. **Kiểm tra Mocking Library**: Ưu tiên sử dụng `mocktail`.
2. **Kiểm tra Fixture**: Dữ liệu JSON API phức tạp phải nằm trong thư mục `test/fixtures/`.
3. **Tránh Hardcode Entities**: Khuyến khích tạo các hàm helper generator như `makeMockUser()` thay vì tự định nghĩa chay đối tượng trong từng file test.
4. **Không gọi API thật**: Đảm bảo toàn bộ tầng Network Client (`http.Client` hoặc `Dio`) đều được mock triệt để.

### Đối với Backend (Django/DRF):
1. **Sử dụng Factory Boy**: Tuyệt đối không dùng file JSON fixture của Django để tạo DB test. Rà soát xem test đã dùng `UserFactory()` thay thế cho các câu lệnh `User.objects.create()` lặp đi lặp lại chưa.
2. **Độc lập và Cô lập**: Rà soát các API gọi bên ngoài (như cổng thanh toán, AI model API, AWS S3). Toàn bộ phải được mock bằng `@patch` hoặc `unittest.mock`.
3. **Cơ sở dữ liệu sạch**: Đảm bảo các test case kế thừa từ `django.test.TestCase` để tự động rollback cơ sở dữ liệu sau mỗi hàm test, giữ môi trường sạch sẽ.
