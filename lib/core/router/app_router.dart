import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/di/service_locator.dart';
import 'package:snapspot/core/router/app_routes.dart';
import 'package:snapspot/core/router/routes/auth_routes.dart';
import 'package:snapspot/core/router/routes/camera_routes.dart';
import 'package:snapspot/core/router/routes/chat_routes.dart';
import 'package:snapspot/core/router/routes/feed_routes.dart';
import 'package:snapspot/core/router/routes/map_routes.dart';
import 'package:snapspot/core/router/routes/profile_routes.dart';
import 'package:snapspot/core/widgets/navigation/main_navigation_layout.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';

/// Key định vị Navigator ngoài cùng để điều hướng toàn màn hình (không hiển thị BottomBar)
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Cấu hình cây định tuyến (Route Tree) của GoRouter cho toàn bộ ứng dụng SnapSpot.
final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,

  // ── 1. Route Guards & Auth Redirect ─────────────────────────────────────────
  redirect: (context, state) {
    final authState = getIt<AuthCubit>().state;
    final isLoggedIn = authState is AuthSuccess;
    final isLoggingIn = state.matchedLocation == AppRoutes.login;
    final isRegistering = state.matchedLocation == AppRoutes.register;

    // Chưa đăng nhập & truy cập route bảo mật -> Chuyển về màn hình Login
    if (!isLoggedIn && !isLoggingIn && !isRegistering) {
      return AppRoutes.login;
    }

    // Đã đăng nhập nhưng truy cập màn hình Login / Register -> Chuyển về Home
    if (isLoggedIn && (isLoggingIn || isRegistering)) {
      return AppRoutes.home;
    }

    return null;
  },

  // ── 2. Custom 404 Error Page ────────────────────────────────────────────────
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Không tìm thấy trang')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              'Trang bạn tìm kiếm không tồn tại hoặc đã thay đổi',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Về Trang Chủ'),
            ),
          ],
        ),
      ),
    );
  },

  // ── 3. Route Tree Assembly ──────────────────────────────────────────────────
  routes: [
    // A. Màn hình Auth (Fullscreen)
    ...buildAuthRoutes(_rootNavigatorKey),

    // B. Màn hình Chi tiết / Edior / Settings (Fullscreen)
    ...buildFeedFullscreenRoutes(_rootNavigatorKey),
    buildCameraEditorRoute(_rootNavigatorKey),
    buildChatRoomRoute(_rootNavigatorKey),
    ...buildProfileFullscreenRoutes(_rootNavigatorKey),

    // C. ShellRoute chứa các Tab điều hướng chính (Có Bottom Navigation Bar)
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationLayout(child: child);
      },
      routes: [
        buildHomeTabRoute(),
        buildMapTabRoute(),
        buildCameraTabRoute(),
        buildChatTabRoute(),
        ...buildProfileTabRoutes(),
      ],
    ),
  ],
);
