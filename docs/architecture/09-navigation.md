# 09 - Navigation

Tài liệu này đặc tả quy chuẩn thiết kế hệ thống điều hướng và định tuyến (Routing & Navigation) trong ứng dụng Flutter của SnapSpot sử dụng thư viện **GoRouter**.

---

## 1. Lý do lựa chọn GoRouter
- **Declarative Routing**: Định nghĩa toàn bộ cây đường dẫn (Route Tree) tại một nơi duy nhất.
- **Deep Linking**: Hỗ trợ tốt việc truy cập trực tiếp từ liên kết ngoài (ví dụ: bấm vào link chia sẻ trên Web mở trực tiếp màn hình chi tiết bài viết trên App).
- **Redirection Guards**: Quản lý phân quyền truy cập trang một cách bảo mật và tập trung (ví dụ: chặn người dùng chưa đăng nhập truy cập vào màn hình Chat).

---

## 2. Cấu trúc cây định tuyến (Route Tree)

```text
/                      # Màn hình chính (Home Feed / Nearby Feed)
├── /explore           # Màn hình Khám phá & Tìm kiếm
├── /camera            # Màn hình Chụp và Đăng bài viết
├── /chat              # Màn hình Danh sách hội thoại
│   └── /chat/:roomId  # Màn hình Chi tiết phòng chat (Dynamic Route)
├── /profile           # Màn hình Trang cá nhân
│   └── /profile/:id   # Màn hình Trang cá nhân người khác (Dynamic Route)
└── /login             # Màn hình Đăng nhập (nằm ngoài cấu trúc ShellRoute)
```

---

## 3. Cấu hình GoRouter chi tiết

Đường dẫn cấu hình router chính được đặt tại `lib/core/network/app_router.dart` hoặc `lib/app.dart`.

```dart
final goRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // 1. Lấy trạng thái đăng nhập từ AuthCubit (BLoC)
    final isLoggedIn = context.read<AuthCubit>().state.isLoggedIn;
    final isLoggingIn = state.matchedLocation == '/login';

    // 2. Nếu chưa đăng nhập và không phải đang ở trang login -> Điều hướng về /login
    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }

    // 3. Nếu đã đăng nhập mà cố tình truy cập /login -> Điều hướng về trang chủ /
    if (isLoggedIn && isLoggingIn) {
      return '/';
    }

    return null; // Không điều hướng, cho phép tiếp tục truy cập trang đích
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Sử dụng ShellRoute để duy trì thanh điều hướng BottomNavigationBar
    ShellRoute(
      builder: (context, state, child) => MainNavigationLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        // Dynamic Route truyền Route Parameter
        GoRoute(
          path: '/profile/:id',
          builder: (context, state) {
            final userId = state.pathParameters['id']!;
            return ProfileScreen(userId: userId);
          },
        ),
      ],
    ),
  ],
);
```

---

## 4. Quy tắc điều chuyển trang (Navigation API)

### 4.1. Sử dụng `context.go()`
- **Tác dụng**: Thay thế toàn bộ ngăn xếp màn hình cũ bằng đường dẫn mới.
- **Khi nào dùng**: Khi chuyển tab chính trên thanh điều hướng BottomNavigationBar hoặc sau khi đăng nhập/đăng xuất thành công.
- *Ví dụ*: `context.go('/explore');`

### 4.2. Sử dụng `context.push()`
- **Tác dụng**: Đè một màn hình mới lên trên màn hình hiện tại (vẫn giữ nút Quay lại - Back button).
- **Khi nào dùng**: Khi đi vào trang con chi tiết (như xem chi tiết một bài viết từ trang chủ).
- *Ví dụ*: `context.push('/profile/$userId');`