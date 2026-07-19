# 21 - Location System

Tài liệu này đặc tả cơ chế lưu trữ, truy vấn dữ liệu không gian địa lý (GIS) và tích hợp bản đồ trên SnapSpot.

---

## 1. Lưu trữ dữ liệu GPS chuẩn PostGIS

SnapSpot sử dụng hệ quản trị cơ sở dữ liệu **PostgreSQL** kết hợp tiện ích mở rộng **PostGIS** để quản lý các tọa độ địa lý.
- **Hệ tọa độ tiêu chuẩn**: Sử dụng hệ tọa độ tham chiếu không gian **WGS 84** (Mã chuẩn: **SRID 4326**). Đây là hệ tọa độ chuẩn toàn cầu được sử dụng bởi các chip GPS trên thiết bị di động (Android/iOS) và Google Maps.
- **Kiểu dữ liệu trường tọa độ**: Cột `coordinates` trên bảng `spot` được định nghĩa dưới dạng hình học điểm:
  ```sql
  coordinates GEOGRAPHY(Point, 4326)
  ```

---

## 2. Các truy vấn không gian cốt lõi (Core GIS Queries)

Django hỗ trợ giao tiếp với PostGIS thông qua module `django.contrib.gis`.

### 2.1. Tìm kiếm địa điểm lân cận (Nearby Search - ST_DWithin)
Lọc danh sách các bài đăng nằm trong bán kính cách vị trí của người dùng một khoảng cách cụ thể (ví dụ: 10km).
- **Cú pháp Django ORM**:
  ```python
  from django.contrib.gis.geos import Point
  from django.contrib.gis.measure import D
  
  # Tạo đối tượng Point đại diện cho vị trí người dùng (Kinh độ, Vĩ độ)
  user_location = Point(105.852445, 21.028511, srid=4326)
  
  # Lọc các địa điểm trong bán kính 10,000 mét (10km)
  nearby_spots = Spot.objects.filter(
      coordinates__dwithin=(user_location, D(m=10000))
  )
  ```

### 2.2. Tính toán khoảng cách (Distance Calculation - ST_Distance)
Tính khoảng cách chính xác từ người dùng đến địa điểm đăng bài để hiển thị trên UI.
- **Cú pháp Django ORM**:
  ```python
  from django.contrib.gis.db.models.functions import Distance

  spots_with_distance = Spot.objects.annotate(
      distance=Distance('coordinates', user_location)
  ).order_by('distance')
  
  for spot in spots_with_distance:
      print(f"Địa điểm: {spot.name}, Khoảng cách: {spot.distance.km:.2f} km")
  ```

---

## 3. Tối ưu hóa Bản đồ & Gom cụm (Clustering)

Để bảo đảm hiệu năng khi hiển thị hàng trăm nghìn bức ảnh trên màn hình Bản đồ của Client:
- **Gom cụm tại Client (Mobile-side Clustering)**: Google Maps Flutter SDK hỗ trợ tự động gộp nhóm các marker ở gần nhau thành cụm số lượng để giảm giật lag khung hình khi vẽ.
- **Gom cụm tại Server (Server-side Clustering)**: Khi người dùng thu nhỏ bản đồ ở mức vĩ mô (Zoom-out xem toàn quốc gia hoặc thành phố):
  - Client gửi tọa độ khung hình hiện tại (Bounding Box: North-East, South-West).
  - Django sẽ sử dụng hàm PostGIS `ST_ClusterKMeans` hoặc phân chia lưới tọa độ để nhóm các bức ảnh lại thành các điểm đại diện trước khi trả về cho Client. Điều này giúp giảm lượng dữ liệu truyền tải qua mạng từ hàng nghìn dòng xuống còn vài chục điểm cụm.
- **Chỉ mục không gian GIST**: Bắt buộc tạo chỉ mục GIST trên cột `coordinates` để các hàm `ST_DWithin` và `ST_Distance` chạy ở độ phức tạp thuật toán cực nhỏ (thời gian phản hồi < 50ms).