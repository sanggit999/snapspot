import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/router/app_routes.dart';
import 'package:snapspot/features/profile/presentation/screens/change_password_screen.dart';
import 'package:snapspot/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:snapspot/features/profile/presentation/screens/profile_screen.dart';
import 'package:snapspot/features/settings/presentation/screens/settings_screen.dart';

/// Các Route quản lý Profile, Cài đặt và Chỉnh sửa thông tin cá nhân (Fullscreen)
List<RouteBase> buildProfileFullscreenRoutes(GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.settings,
      name: AppRoutes.settingsName,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      name: AppRoutes.editProfileName,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      name: AppRoutes.changePasswordName,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
  ];
}

/// Các Route Trang cá nhân nằm trong ShellRoute (Main Tab)
List<RouteBase> buildProfileTabRoutes() {
  return [
    GoRoute(
      path: AppRoutes.profile,
      name: AppRoutes.profileName,
      builder: (context, state) => const ProfileScreen(userId: 'me'),
    ),
    GoRoute(
      path: AppRoutes.userProfile,
      name: AppRoutes.userProfileName,
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return ProfileScreen(userId: userId);
      },
    ),
    // Aliases cho user profile
    GoRoute(
      path: AppRoutes.userProfileAlias1,
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return ProfileScreen(userId: userId);
      },
    ),
    GoRoute(
      path: AppRoutes.userProfileAlias2,
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return ProfileScreen(userId: userId);
      },
    ),
    GoRoute(
      path: AppRoutes.userProfileAlias3,
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return ProfileScreen(userId: userId);
      },
    ),
    GoRoute(
      path: AppRoutes.saved,
      name: AppRoutes.savedName,
      builder: (context, state) => const ProfileScreen(userId: 'me'),
    ),
    GoRoute(
      path: AppRoutes.bookmarks,
      name: AppRoutes.bookmarksName,
      builder: (context, state) => const ProfileScreen(userId: 'me'),
    ),
  ];
}
