
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/widgets/main_navigation_layout.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/auth/presentation/screens/login_screen.dart';
import 'package:snapspot/features/auth/presentation/screens/register_screen.dart';
import 'package:snapspot/features/feed/presentation/screens/home_screen.dart';
import 'package:snapspot/features/feed/presentation/screens/post_detail_screen.dart';
import 'package:snapspot/features/map/presentation/screens/map_explore_screen.dart';
import 'package:snapspot/features/camera/presentation/screens/camera_screen.dart';
import 'package:snapspot/features/camera/presentation/screens/post_editor_screen.dart';
import 'package:snapspot/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:snapspot/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:snapspot/features/profile/presentation/screens/profile_screen.dart';

/// Cấu hình cây định tuyến (Route Tree) của GoRouter cho toàn bộ ứng dụng.
/// Sử dụng ShellRoute để duy trì thanh BottomNavigationBar giữa các tab.
final goRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // 1. Kiểm tra trạng thái đăng nhập từ AuthCubit
    final authCubit = context.read<AuthCubit>();
    final isLoggedIn = authCubit.state is AuthSuccess;
    final isLoggingIn = state.matchedLocation == '/login';
    final isRegistering = state.matchedLocation == '/register';

    // 2. Nếu chưa đăng nhập và không nằm ở màn hình đăng nhập/đăng ký -> Điều hướng về /login
    if (!isLoggedIn && !isLoggingIn && !isRegistering) {
      return '/login';
    }

    // 3. Nếu đã đăng nhập mà cố truy cập /login hoặc /register -> Điều hướng về trang chủ /
    if (isLoggedIn && (isLoggingIn || isRegistering)) {
      return '/';
    }

    return null; // Không điều hướng, cho phép tiếp tục truy cập trang đích
  },
  routes: [
    // Định tuyến cho Auth nằm ngoài ShellRoute (Không hiển thị BottomBar)
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Tích hợp ShellRoute để chứa thanh điều hướng chính
    ShellRoute(
      builder: (context, state, child) => MainNavigationLayout(child: child),
      routes: [
        // Tab 1: Trang chủ / Bảng tin
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          routes: [
            // Chi tiết bài đăng (nằm đè lên tab Home)
            GoRoute(
              path: 'post/:id',
              builder: (context, state) {
                final postId = state.pathParameters['id']!;
                return PostDetailScreen(postId: postId);
              },
            ),
          ],
        ),

        // Tab 2: Khám phá bản đồ
        GoRoute(
          path: '/explore',
          builder: (context, state) => const MapExploreScreen(),
        ),

        // Tab 3: Camera & Đăng bài
        GoRoute(
          path: '/camera',
          builder: (context, state) => const CameraScreen(),
          routes: [
            // Màn hình biên tập bài viết sau khi chụp ảnh
            GoRoute(
              path: 'editor',
              builder: (context, state) {
                final imagePath = state.uri.queryParameters['imagePath'] ?? '';
                return PostEditorScreen(imagePath: imagePath);
              },
            ),
          ],
        ),

        // Tab 4: Tin nhắn / Chat
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatListScreen(),
          routes: [
            // Chi tiết phòng chat
            GoRoute(
              path: ':roomId',
              builder: (context, state) {
                final roomId = state.pathParameters['roomId']!;
                return ChatRoomScreen(roomId: roomId);
              },
            ),
          ],
        ),

        // Tab 5: Trang cá nhân
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
