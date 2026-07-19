# 16 - API Standard

Tài liệu này quy chuẩn hóa thiết kế và xây dựng RESTful API trong hệ thống SnapSpot.

---

## 1. Định dạng URL (URL Conventions)

- **Cấu trúc URL bắt buộc**: `/api/v1/{resources}/`
- **Quy tắc đặt tên tài nguyên**:
  - Chỉ dùng **danh từ số nhiều** cho tên tài nguyên (Ví dụ: `/api/v1/users/`, `/api/v1/posts/`).
  - Sử dụng chữ thường và phân tách bằng dấu gạch ngang (kebab-case) nếu tên tài nguyên có nhiều từ (Ví dụ: `/api/v1/chat-rooms/`).
- **Không đưa hành động nghiệp vụ vào URL**:
  - ❌ Tránh: `POST /api/v1/posts/1/likePost/`
  - ✅ Khuyến khích: `POST /api/v1/posts/1/likes/` (Tạo mới lượt thích) hoặc `DELETE /api/v1/posts/1/likes/` (Xóa lượt thích).

---

## 2. Ngữ nghĩa HTTP Methods

Hệ thống tuân thủ chặt chẽ ý nghĩa của các phương thức HTTP:
- **`GET`**: Lấy thông tin tài nguyên. Không được làm thay đổi dữ liệu phía Server.
- **`POST`**: Tạo mới một tài nguyên.
- **`PUT`**: Thay thế/ghi đè toàn bộ tài nguyên.
- **`PATCH`**: Cập nhật một phần dữ liệu của tài nguyên.
- **`DELETE`**: Xóa tài nguyên (soft delete hoặc hard delete tùy nghiệp vụ).

---

## 3. Cấu trúc Response chuẩn (Response Envelope)

Mọi phản hồi từ API đều được bọc trong một định dạng JSON nhất quán.

### 3.1. Phản hồi thành công (Success Response)
- Trả về HTTP Status Code: `200 OK` hoặc `201 Created`.
- Cấu trúc:
  ```json
  {
    "success": true,
    "data": {
      "id": 12,
      "username": "sangnguyen"
    }
  }
  ```

### 3.2. Phản hồi lỗi (Error Response)
- Trả về các HTTP Status Code lỗi tương ứng (`400`, `401`, `403`, `404`, `429`, `500`).
- Cấu trúc:
  ```json
  {
    "success": false,
    "error": {
      "code": "VALIDATION_FAILED",
      "message": "Dữ liệu gửi lên không hợp lệ.",
      "details": {
        "email": ["Email này đã được sử dụng."]
      }
    }
  }
  ```

---

## 4. Phân trang dữ liệu (Pagination Standard)

Đối với các API trả về danh sách tài nguyên (GET list), hệ thống bắt buộc phải hỗ trợ phân trang thông qua 2 query parameters là `page` và `limit`.

- **Cấu trúc dữ liệu trả về**:
  ```json
  {
    "success": true,
    "data": [
      { "id": 1, "caption": "Ảnh đẹp" },
      { "id": 2, "caption": "Check-in cafe" }
    ],
    "meta": {
      "current_page": 1,
      "limit": 10,
      "total_items": 145,
      "total_pages": 15
    }
  }
  ```

---

## 5. Danh sách HTTP Status Codes sử dụng
- **`200 OK`**: Yêu cầu xử lý thành công.
- **`201 Created`**: Tạo mới tài nguyên thành công (sau lệnh POST).
- **`204 No Content`**: Xóa thành công hoặc cập nhật thành công nhưng không có dữ liệu trả về.
- **`400 Bad Request`**: Dữ liệu gửi lên bị lỗi cú pháp hoặc lỗi validation nghiệp vụ.
- **`401 Unauthorized`**: Token xác thực không hợp lệ hoặc hết hạn.
- **`403 Forbidden`**: Token hợp lệ nhưng người dùng không có quyền truy cập tài nguyên.
- **`404 Not Found`**: Không tìm thấy tài nguyên.
- **`429 Too Many Requests`**: Vượt quá giới hạn lượt gọi API (Rate Limiting).
- **`500 Internal Server Error`**: Lỗi hệ thống phát sinh ở phía Server.