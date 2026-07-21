import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/widgets/navigation/main_navigation_layout.dart';
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
import 'package:snapspot/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:snapspot/features/profile/presentation/screens/change_password_screen.dart';
import 'package:snapspot/features/settings/presentation/screens/settings_screen.dart';

// Key định vị Navigator ngoài cùng để điều hướng toàn màn hình (không có BottomBar)
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Cấu hình cây định tuyến (Route Tree) của GoRouter cho toàn bộ ứng dụng SnapSpot.
/// Đặt đúng chuẩn Clean Architecture tại lib/core/router/app_router.dart.
final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
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
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterScreen(),
    ),

    // Các màn hình hiển thị toàn màn hình (Không có BottomBar) được định nghĩa ngang hàng ở ROOT level
    GoRoute(
      path: '/post/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        final focusComment = state.uri.queryParameters['focusComment'] == 'true';
        return PostDetailScreen(
          postId: postId,
          focusComment: focusComment,
        );
      },
    ),
    GoRoute(
      path: '/camera/editor',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final imagePath = state.uri.queryParameters['imagePath'] ?? '';
        return PostEditorScreen(imagePath: imagePath);
      },
    ),
    GoRoute(
      path: '/chat/:roomId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        return ChatRoomScreen(roomId: roomId);
      },
    ),
    GoRoute(
      path: '/user/profile/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return ProfileScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/change-password',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    // Tích hợp ShellRoute để chứa thanh điều hướng chính
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const MapExploreScreen(),
        ),
        GoRoute(
          path: '/camera',
          builder: (context, state) => const CameraScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatListScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(userId: 'me'),
        ),
      ],
    ),
  ],
);
