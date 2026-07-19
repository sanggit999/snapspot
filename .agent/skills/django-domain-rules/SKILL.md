---
name: django-domain-rules
description: Quy chuẩn cấu trúc dự án backend Django REST Framework (DRF) theo Domain (Organize by Domain), tách biệt rõ ràng vai trò giữa View/ViewSet, Serializer, Repository, Business Logic và tối ưu hóa thiết kế hệ thống.
version: 1.1.0
author: Antigravity
tags:
  - backend
  - django
  - django-rest-framework
  - drf
  - domain-driven
  - clean-architecture
  - best-practices
---

# Quy chuẩn Thiết kế Backend Django REST Framework (DRF) theo Domain

## Tổng quan
Kỹ năng này định hướng cấu trúc thư mục và thiết kế hệ thống Backend sử dụng **Django** và **Django REST Framework (DRF)** theo mô hình Domain-driven / Clean Architecture. Việc tuân thủ quy chuẩn này giúp ứng dụng có tính mô-đun cao, dễ viết Unit Test, dễ bảo trì và mở rộng khi dự án phát triển.

## Khi nào cần sử dụng
- Khi khởi tạo hoặc cấu trúc lại các Django App trong dự án.
- Khi viết mã nguồn cho các lớp của DRF: `APIView`, `GenericAPIView`, `ViewSet`, `ModelViewSet`, `Serializer`, `ModelSerializer`.
- Khi thiết kế luồng xử lý dữ liệu: **Client Request ➡️ DRF View/ViewSet ➡️ Serializer (Validation) ➡️ Service (Business Logic) ➡️ Repository / Custom Manager (Database Access) ➡️ DB**.

---

## Các Quy tắc Kiến trúc Chính

### 1. Cấu trúc thư mục theo Domain (Organize by Domain)
- **Nguyên tắc**: Không gom nhóm file theo loại file trên toàn bộ dự án. Mỗi Django App đại diện cho một Domain nghiệp vụ duy nhất và chứa toàn bộ các file liên quan đến domain đó.
- **So sánh cấu trúc**:
  - ❌ **Tránh (Organize by File Type toàn dự án)**:
    ```text
    src/
      views/
        user_views.py
        order_views.py
      models/
        user.py
        order.py
      serializers/
        user_serializer.py
        order_serializer.py
    ```
  - ✅ **Khuyến khích (Organize by Domain - Mỗi App là một Domain)**:
    ```text
    src/
      users/                 # Django App: Users Domain
        models.py            # Chỉ chứa ORM Models của User
        views.py             # DRF ViewSets / APIViews của User
        serializers.py       # DRF Serializers của User
        services.py          # Business Logic nghiệp vụ của User
        repositories.py      # Đóng gói truy vấn DB liên quan đến User
        tests/               # Unit & Integration Tests của User Domain
      orders/                # Django App: Orders Domain
        models.py
        views.py
        serializers.py
        services.py
        repositories.py
        tests/
    ```

### 2. Mỗi App chỉ giải quyết một nghiệp vụ (Single Responsibility)
- **Nguyên tắc**: Mỗi Django app đại diện cho một domain duy nhất và chỉ chịu trách nhiệm giải quyết một nghiệp vụ cốt lõi. 
- **Cách xử lý**: Không để một app phình to gánh nhiều nghiệp vụ chéo nhau. Ví dụ: Nếu app `users` bắt đầu xử lý cả thanh toán và gửi thông báo hệ thống, hãy tách thành các app chuyên biệt như `payments` và `notifications`.

### 3. View mỏng (Thin View) trong Django REST Framework
- **Nguyên tắc**: Các `APIView`, `GenericAPIView`, `ViewSet` hay `ModelViewSet` của DRF phải luôn mỏng. Nhiệm vụ duy nhất của View là:
  1. Kiểm tra quyền truy cập sơ bộ (`permission_classes`, `authentication_classes`).
  2. Nhận dữ liệu request và đưa vào Serializer để kiểm tra tính hợp lệ (`serializer.is_valid()`).
  3. Gọi lớp Service thực hiện nghiệp vụ và nhận kết quả.
  4. Trả về HTTP Response.
- **Tuyệt đối không viết Business Logic hoặc thực hiện tính toán nghiệp vụ trong View/ViewSet.**
- **Không lạm dụng các phương thức vòng đời của DRF**: Tránh viết business logic phức tạp trong `perform_create()`, `perform_update()`, hay `perform_destroy()` của `ModelViewSet`. Các phương thức này chỉ nên đóng vai trò kích hoạt Service.
- ❌ **Bad (Viết logic nghiệp vụ trực tiếp trong DRF ViewSet/APIView)**:
  ```python
  from rest_framework.viewsets import ModelViewSet
  from rest_framework.response import Response
  from rest_framework import status

  class OrderViewSet(ModelViewSet):
      queryset = Order.objects.all()
      serializer_class = OrderSerializer

      # Lạm dụng perform_create để xử lý logic thanh toán và trừ tiền
      def perform_create(self, serializer):
          user = self.request.user
          items_data = serializer.validated_data['items']
          total_price = sum(item['price'] * item['quantity'] for item in items_data)
          
          if user.balance < total_price:
              raise serializers.ValidationError("Insufficient balance")
          
          user.balance -= total_price
          user.save()
          
          # Lưu đơn hàng và gửi email trực tiếp tại View
          order = serializer.save(user=user, total_price=total_price)
          send_order_confirmation_email(user.email, order.id)
  ```
- ✅ **Good (Thin View/ViewSet - Ủy thác toàn bộ nghiệp vụ cho Service)**:
  ```python
  from rest_framework.viewsets import ViewSet
  from rest_framework.response import Response
  from rest_framework import status

  class OrderViewSet(ViewSet):
      # ViewSet chỉ làm nhiệm vụ nhận request và gọi Service
      def create(self, request):
          serializer = OrderCreateInputSerializer(data=request.data)
          serializer.is_valid(raise_exception=True)
          
          try:
              order = OrderService.create_order(
                  user=request.user, 
                  items_data=serializer.validated_data['items']
              )
              output_serializer = OrderDetailSerializer(order)
              return Response(output_serializer.data, status=status.HTTP_201_CREATED)
          except InsufficientBalanceError as e:
              return Response({"detail": str(e)}, status=status.HTTP_400_BAD_REQUEST)
  ```

### 4. DRF Serializer chỉ chịu trách nhiệm Validation và Serialization
- **Nguyên tắc**: DRF Serializer (`Serializer` hoặc `ModelSerializer`) hoạt động như một Data Transfer Object (DTO). 
  - **Validation**: Đảm bảo dữ liệu đầu vào đúng định dạng, đúng kiểu dữ liệu, hợp lệ về mặt cú pháp (sử dụng các hàm `validate_<field_name>()` hoặc `validate()`).
  - **Serialization**: Chuyển đổi dữ liệu từ Python objects/Model instances thành kiểu JSON để trả về Client.
- **Không viết Business Logic hay thực hiện ghi DB liên kết chéo trong phương thức `create()` hoặc `update()` của Serializer.**
- ❌ **Bad (Xử lý nghiệp vụ và lưu bản ghi liên kết trong Serializer)**:
  ```python
  class UserRegisterSerializer(serializers.ModelSerializer):
      class Meta:
          model = User
          fields = ['email', 'password']

      def create(self, validated_data):
          # Lồng ghép logic tạo profile và gửi mail chào mừng trong Serializer
          user = User.objects.create_user(**validated_data)
          UserProfile.objects.create(user=user, points=100) # Logic nghiệp vụ ngầm
          send_welcome_email(user.email)
          return user
  ```
- ✅ **Good (Serializer thuần túy làm validation, Service đảm nhận khâu xử lý)**:
  ```python
  class UserRegisterSerializer(serializers.Serializer):
      email = serializers.EmailField()
      password = serializers.CharField(write_only=True, min_length=8)

      def validate_email(self, value):
          # Chỉ kiểm tra tính hợp lệ của dữ liệu đầu vào
          if User.objects.filter(email=value).exists():
              raise serializers.ValidationError("Email already registered.")
          return value
  ```

### 5. Truy cập Database thông qua Repository hoặc Django Manager/QuerySet
- **Nguyên tắc**: Không viết các câu lệnh ORM phức tạp (chứa nhiều filter, select_related, prefetch_related, aggregate) rải rác trong các View hay Service.
  - Sử dụng **Repository Pattern** để đóng gói toàn bộ các thao tác truy vấn và ghi cơ sở dữ liệu. Điều này giúp dễ dàng Mock dữ liệu khi viết Unit Test.
  - Hoặc sử dụng **Custom QuerySet và Manager** của Django để đóng gói logic truy vấn có thể tái sử dụng.
- ❌ **Bad (Viết query ORM phức tạp trực tiếp trong Service/View)**:
  ```python
  # Trong Service
  def get_monthly_sales_report(year, month):
      # Query ORM phức tạp bị phơi bày trực tiếp ở tầng Business Logic
      return Order.objects.filter(
          created_at__year=year, 
          created_at__month=month, 
          status='completed'
      ).select_related('user').prefetch_related('items').aggregate(total=Sum('total_price'))
  ```
- ✅ **Good (Đóng gói truy vấn vào Repository hoặc Custom QuerySet)**:
  ```python
  # Trong orders/repositories.py
  class OrderRepository:
      @staticmethod
      def get_completed_orders_by_month(year: int, month: int):
          return Order.objects.filter(
              created_at__year=year,
              created_at__month=month,
              status='completed'
          ).select_related('user').prefetch_related('items')

      @staticmethod
      def calculate_total_sales(orders_queryset) -> float:
          return orders_queryset.aggregate(total=Sum('total_price'))['total'] or 0.0
  ```

### 6. Ưu tiên Composition hơn Inheritance (Composition over Inheritance)
- **Nguyên tắc**: Khi thiết kế các class Service, Repository, Helper, hãy ưu tiên cấu thành từ các đối tượng nhỏ hơn (Composition) và tiêm phụ thuộc (Dependency Injection) thay vì kế thừa từ các Class cha cồng kềnh. Kế thừa sâu khiến code bị thắt chặt (tight coupling), khó mở rộng và khó viết Unit Test cô lập.
- ❌ **Bad (Kế thừa quá nhiều từ Base class)**:
  ```python
  class BaseService:
      def log_activity(self, message): ...
      def send_sms(self, phone, content): ...

  # UserService bị phụ thuộc cứng vào các phương thức của BaseService
  class UserService(BaseService):
      def register_user(self, data):
          # Xử lý logic...
          self.log_activity("User registered")
          self.send_sms(data['phone'], "Welcome!")
  ```
- ✅ **Good (Sử dụng Composition / Dependency Injection)**:
  ```python
  class UserService:
      # Inject các service chuyên biệt thông qua Constructor
      def __init__(self, sms_service: SMSService, logger: ActivityLogger):
          self.sms_service = sms_service
          self.logger = logger

      def register_user(self, data):
          # Xử lý logic...
          self.logger.log("User registered")
          self.sms_service.send_welcome_sms(data['phone'])
  ```

### 7. Không lạm dụng Django Signals
- **Nguyên tắc**: Tránh lạm dụng Django Signals (`pre_save`, `post_save`, `post_delete`, v.v.) để thực hiện business logic chính. Signals thực thi ngầm (implicit execution), gây khó khăn khi debug luồng code và làm sai lệch môi trường kiểm thử (Unit Test).
  - **Trường hợp được dùng**: Chỉ dùng cho các tác vụ hệ thống độc lập, không ảnh hưởng đến luồng chạy chính (ví dụ: tự động dọn dẹp file vật lý trên S3 khi model chứa liên kết file bị xóa).
  - **Trường hợp tránh dùng**: Các logic nghiệp vụ bắt buộc (như tạo profile khi đăng ký user, gửi hóa đơn khi đặt hàng). **Phải gọi tường minh (explicit call)** trong Service.
- ❌ **Bad (Sử dụng Signal xử lý business logic ngầm)**:
  ```python
  # Tự động trừ kho hàng ngầm khi Order được lưu - Rất khó debug khi có lỗi
  @receiver(post_save, sender=Order)
  def update_inventory_on_order(sender, instance, created, **kwargs):
      if created:
          for item in instance.items.all():
              item.product.inventory -= item.quantity
              item.product.save()
  ```
- ✅ **Good (Gọi tường minh trong Service để kiểm soát luồng dữ liệu)**:
  ```python
  class OrderService:
      @staticmethod
      def create_order(user, items_data):
          with transaction.atomic():
              order = OrderRepository.create(user=user)
              # Gọi trực tiếp nghiệp vụ cập nhật kho
              InventoryService.decrease_stock(items_data)
              # Gọi trực tiếp gửi mail thông báo
              NotificationService.send_order_email(user.email, order)
              return order
  ```

---

## Hướng dẫn thực hiện cho Agent (DRF Specific Checklist)

1. **Phân tích yêu cầu / Tạo App**:
   - Mỗi app Django phải giải quyết một Single Responsibility (Một App = Một Domain).
   - Kiểm tra cấu trúc thư mục của app để đảm bảo tính tự đóng gói (Self-contained) theo Domain.
2. **Kiểm tra DRF View/ViewSet**:
   - Đảm bảo View không chứa bất kỳ tính toán logic nghiệp vụ hay truy vấn DB phức tạp nào.
   - Kiểm tra xem View đã ủy thác công việc cho lớp Service (`services.py`) chưa.
3. **Kiểm tra DRF Serializer**:
   - Serializer chỉ được dùng để validate dữ liệu (`is_valid()`) và serialize/deserialize.
   - Phương thức `create()` hoặc `update()` của Serializer không được chứa logic liên kết chéo hay gửi thông báo.
4. **Kiểm tra Truy cập Cơ sở Dữ liệu**:
   - Đảm bảo các câu lệnh ORM phức tạp nằm trong `repositories.py` hoặc Django custom `QuerySet` / `Manager`.
   - Tránh viết ORM queries tùy tiện trong views hoặc services.
5. **Kiểm tra Kiến trúc Class**:
   - Đảm bảo hạn chế kế thừa sâu. Khuyến khích sử dụng Composition.
6. **Kiểm tra Django Signals**:
   - Kiểm tra xem có logic nghiệp vụ chính nào đang chạy ngầm trong `signals.py` hay không. Yêu cầu refactor sang gọi tường minh trong lớp Service.
