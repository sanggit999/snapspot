# 25 - Permissions

Tài liệu này đặc tả cơ chế phân quyền dựa trên vai trò (Role-Based Access Control - RBAC) và giải pháp phòng ngừa lỗi phân quyền tài nguyên (BOLA/IDOR) trong hệ thống SnapSpot.

---

## 1. Phân quyền vai trò (Role-Based Access Control - RBAC)

Hệ thống SnapSpot phân chia người dùng thành 3 vai trò (Roles) chính với các quyền truy cập tăng dần:

| Vai trò | Phân quyền chi tiết |
| :--- | :--- |
| **Thành viên (Member)** | - Có quyền tạo mới, cập nhật, xóa các bài viết, bình luận, lượt thích của chính mình.<br>- Có quyền xem các nội dung công khai và gửi tin nhắn trong phòng chat mình tham gia. |
| **Kiểm duyệt viên (Moderator)**| - Thừa hưởng toàn bộ quyền của Member.<br>- Có quyền duyệt danh mục báo cáo vi phạm (reports).<br>- Có quyền ẩn/hiển thị bài viết của bất kỳ ai nếu vi phạm tiêu chuẩn cộng đồng. |
| **Quản trị viên (Admin)** | - Toàn quyền tối cao trên toàn hệ thống.<br>- Có quyền quản lý danh sách người dùng (Kích hoạt/Khóa tài khoản).<br>- Thay đổi các cấu hình hệ thống, quản lý danh sách địa điểm nổi bật. |

---

## 2. Kiểm tra Quyền sở hữu đối tượng (BOLA / IDOR Protection)

Lỗ hổng **BOLA (Broken Object Level Authorization)** hay **IDOR (Insecure Direct Object Reference)** xảy ra khi kẻ tấn công thay đổi ID của một đối tượng trong API Request (ví dụ: `DELETE /api/v1/posts/99/`) để xóa bài viết của người khác mà không bị hệ thống chặn lại.

### Quy tắc kiểm tra quyền bắt buộc tại Backend:
Mọi thao tác sửa đổi (PUT, PATCH, DELETE) đối với một tài nguyên bắt buộc phải kiểm tra quyền sở hữu (Ownership Check) ở mức đối tượng (Object-level) trước khi thực hiện câu lệnh SQL cập nhật.

### Mẫu triển khai trong Django REST Framework:
Sử dụng Custom Permission Class để tự động kiểm duyệt:
```python
from rest_framework import permissions

class IsOwnerOrReadOnly(permissions.BasePermission):
    """
    Chỉ cho phép người sở hữu tài nguyên chỉnh sửa hoặc xóa nó.
    Mọi người khác chỉ được phép xem (GET, HEAD, OPTIONS).
    """
    def has_object_permission(self, request, view, obj):
        # 1. Các phương thức đọc dữ liệu được phép đi qua
        if request.method in permissions.SAFE_METHODS:
            return True

        # 2. Kiểm tra xem người gửi yêu cầu có phải là người sở hữu đối tượng không
        # (Đối tượng có thể là Post, Comment, Profile...)
        return obj.user == request.user
```

Áp dụng lớp Permission này trực tiếp vào ViewSet:
```python
class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrReadOnly]
```
- **Lưu ý**: Lớp Permission này sẽ được DRF gọi tự động khi View truy cập đối tượng thông qua hàm `get_object()`. Đối với các API viết thủ công (Custom Actions), lập trình viên bắt buộc phải tự gọi hàm kiểm tra quyền sở hữu tương ứng trong mã nguồn dịch vụ (Service Layer).