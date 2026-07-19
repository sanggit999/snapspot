# 23 - Search System

Tài liệu này đặc tả cơ chế tìm kiếm, lập chỉ mục và gợi ý từ khóa (Search & Autocomplete System) trên SnapSpot.

---

## 1. Phạm vi Tìm kiếm (Search Scope)

Hệ thống cung cấp một thanh tìm kiếm hợp nhất (Unified Search Bar) cho phép tìm kiếm qua 3 đối tượng:
- **Người dùng (Users)**: Tìm theo `username` hoặc tên hiển thị.
- **Địa điểm (Spots/Places)**: Tìm theo tên địa điểm, thành phố hoặc địa chỉ.
- **Hashtags**: Tìm kiếm các thẻ xu hướng đính kèm trong mô tả bài viết (ví dụ: `#dulich`, `#cafe`).

---

## 2. Giải pháp kỹ thuật: PostgreSQL Full-Text Search

Để giảm tải chi phí hạ tầng và tránh phải cài đặt các cụm Elasticsearch phức tạp ở giai đoạn đầu (Version 1 & 2), SnapSpot sử dụng tính năng **Full-Text Search (FTS)** tích hợp sẵn trong PostgreSQL.

### 2.1. Tìm kiếm chuỗi khớp một phần (Trigram Search)
Để hỗ trợ người dùng tìm kiếm khi gõ sai chính tả hoặc gõ không dấu (ví dụ: gõ "hoan kiem" vẫn tìm ra "Hồ Hoàn Kiếm"):
- Kích hoạt extension **`pg_trgm`** trong PostgreSQL.
- Tạo chỉ mục **GIN (Generalized Inverted Index)** kết hợp toán tử trigram trên các cột tìm kiếm chính:
  ```sql
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE INDEX spot_name_trgm_idx ON spot USING GIN (name gin_trgm_ops);
  ```
- **Trong Django ORM**: Sử dụng lookup `trigram_similar` để tìm kiếm tương tự:
  ```python
  from django.contrib.postgres.search import TrigramSimilarity

  results = Spot.objects.annotate(
      similarity=TrigramSimilarity('name', query),
  ).filter(similarity__gt=0.3).order_by('-similarity')
  ```

---

## 3. Thuật toán xếp hạng Xu hướng (Trending Ranking)

Khi người dùng tìm kiếm mà không nhập từ khóa (giao diện trống), hệ thống sẽ hiển thị danh sách **"Địa điểm nổi bật"** và **"Hashtags thịnh hành"**.

### Công thức tính điểm xu hướng (Trending Score):
Điểm xu hướng của một địa điểm/hạt thẻ được tính toán định kỳ 1 giờ/lần bởi Celery Beat và lưu vào bộ nhớ đệm Redis:
```text
Score = (C * 10) + (L * 2) + (Co * 5)
```
Trong đó:
- **`C`**: Số lượt check-in (đăng bài) mới tại địa điểm trong vòng 7 ngày qua.
- **`L`**: Số lượt thích (like) mới nhận được trong vòng 7 ngày qua.
- **`Co`**: Số lượng bình luận (comment) mới nhận được trong vòng 7 ngày qua.

Địa điểm có điểm số `Score` cao nhất sẽ được đẩy lên đầu trang Khám phá (Explore Page) dưới dạng gợi ý.