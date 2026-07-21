import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/router/app_routes.dart';
import 'package:snapspot/features/feed/presentation/screens/home_screen.dart';
import 'package:snapspot/features/feed/presentation/screens/post_detail_screen.dart';

/// Các Route liên quan đến Feed & Bài viết
List<RouteBase> buildFeedFullscreenRoutes(GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.postDetail,
      name: AppRoutes.postDetailName,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        final focusComment = state.uri.queryParameters['focusComment'] == 'true';
        return PostDetailScreen(
          postId: postId,
          focusComment: focusComment,
        );
      },
    ),
    // Short Alias route `/p/:id`
    GoRoute(
      path: AppRoutes.postDetailAlias,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        final focusComment = state.uri.queryParameters['focusComment'] == 'true';
        return PostDetailScreen(
          postId: postId,
          focusComment: focusComment,
        );
      },
    ),
  ];
}

/// Route Trang chủ HomeScreen nằm bên trong ShellRoute (có BottomBar)
GoRoute buildHomeTabRoute() {
  return GoRoute(
    path: AppRoutes.home,
    name: AppRoutes.homeName,
    builder: (context, state) => const HomeScreen(),
  );
}
