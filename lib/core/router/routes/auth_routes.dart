import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/router/app_routes.dart';
import 'package:snapspot/features/auth/presentation/screens/login_screen.dart';
import 'package:snapspot/features/auth/presentation/screens/register_screen.dart';

/// Danh sách các Route liên quan đến Xác thực (Auth).
/// Tất cả hiển thị Fullscreen nằm ngoài ShellRoute (Không chứa BottomBar).
List<RouteBase> buildAuthRoutes(GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.registerName,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const RegisterScreen(),
    ),
  ];
}
