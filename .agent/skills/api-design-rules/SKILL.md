---
name: api-design-rules
description: Quy chuẩn thiết kế RESTful API trong hệ thống, bao gồm cấu trúc URL, phương thức HTTP, phân trang, bảo mật, chuẩn hóa response và tài liệu hóa OpenAPI.
version: 1.0.0
author: Antigravity
tags:
  - api-design
  - rest
  - backend
  - best-practices
---

# Quy tắc Thiết kế API hệ thống

## Tổng quan
Kỹ năng này định hình các quy chuẩn thiết kế và tích hợp API giữa Backend và Frontend. Việc tuân thủ quy tắc thiết kế RESTful giúp hệ thống đồng nhất, dễ mở rộng, bảo mật và dễ tích hợp.

## Khi nào cần sử dụng
- Khi thiết kế endpoint mới ở Backend hoặc viết hàm gọi API (Service/Repository) ở Frontend.
- Khi đánh giá (audit) hoặc refactor các API endpoint hiện tại.

## Các quy tắc thiết kế API chính

### 1. Cấu trúc URL và Tài nguyên (Resource)
- Định dạng URL bắt buộc: `/api/v1/resources` (Ví dụ: `/api/v1/products`).
- **Chỉ dùng danh từ số nhiều** làm tên resource trong URL (Ví dụ: `/api/v1/users`, không dùng `/api/v1/user`).
- **Không đưa hành động nghiệp vụ (business action) vào URL**:
  - ❌ Tránh: `/api/v1/orders/approveOrder`, `/api/v1/users/delete-all`
  - ✅ Khuyến khích: Sử dụng HTTP Methods hoặc mô hình hóa hành động thành một trạng thái/tài nguyên phụ (Ví dụ: `PATCH /api/v1/orders/{id}` với body `{ "status": "approved" }`).

### 2. Ý nghĩa và cách dùng các phương thức HTTP (HTTP Methods)
- **GET**: Chỉ dùng để truy vấn/lấy dữ liệu (không được làm thay đổi trạng thái dữ liệu).
- **POST**: Dùng để tạo mới tài nguyên.
- **PUT**: Dùng để thay thế/ghi đè toàn bộ tài nguyên hiện có.
- **PATCH**: Dùng để cập nhật một phần tài nguyên.
- **DELETE**: Dùng để xóa tài nguyên.

### 3. Phân trang, Lọc, Sắp xếp và Tìm kiếm
- Các API lấy danh sách luôn phải hỗ trợ các chức năng thông qua **query parameters**:
  - **Phân trang (Pagination)**: `page`, `limit` hoặc `cursor`, `size`.
  - **Bộ lọc (Filtering)**: Ví dụ: `?status=active&category=shoes`.
  - **Sắp xếp (Sorting)**: Ví dụ: `?sort=created_at:desc` hoặc `?sort=-price`.
  - **Tìm kiếm (Searching)**: Ví dụ: `?search=keyword`.

### 4. Chuẩn hóa Response và Error Response
- **Response thành công**: Trả về cấu trúc JSON đồng nhất. Ví dụ:
  ```json
  {
    "success": true,
    "data": { ... }, // hoặc [...] đối với danh sách
    "meta": { "page": 1, "limit": 10, "total": 100 } // nếu là danh sách phân trang
  }
  ```
- **Response thất bại**: Luôn trả về cấu trúc lỗi tiêu chuẩn cùng với **HTTP Status Code đúng chuẩn**:
  - `400 Bad Request`: Lỗi dữ liệu đầu vào.
  - `401 Unauthorized`: Chưa xác thực/token hết hạn.
  - `403 Forbidden`: Không có quyền truy cập.
  - `404 Not Found`: Tài nguyên không tồn tại.
  - `500 Internal Server Error`: Lỗi hệ thống.
  ```json
  {
    "success": false,
    "error": {
      "code": "VALIDATION_ERROR",
      "message": "Dữ liệu đầu vào không hợp lệ.",
      "details": { "email": "Email không đúng định dạng." }
    }
  }
  ```

### 5. Bảo mật và Tài liệu hóa API
- Sử dụng **JWT (JSON Web Token)** hoặc **OAuth2** cho cơ chế xác thực. Token phải được truyền qua HTTP Header `Authorization: Bearer <token>`.
- Tài liệu hóa toàn bộ API bằng **OpenAPI/Swagger** (đối với REST API) hoặc schema documentation (đối với GraphQL).

## Hướng dẫn thực hiện cho Agent
1. Khi thiết kế endpoint mới, kiểm tra cấu trúc URL xem đã đúng dạng số nhiều và có hành động nghiệp vụ trong URL hay không.
2. Kiểm tra việc phân trang, lọc, sắp xếp đã được cấu hình ở query parameters chưa.
3. Đảm bảo HTTP Status Code trả về tương ứng chính xác với kết quả xử lý.
