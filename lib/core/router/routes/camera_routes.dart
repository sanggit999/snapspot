import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/router/app_routes.dart';
import 'package:snapspot/features/camera/presentation/screens/camera_screen.dart';
import 'package:snapspot/features/camera/presentation/screens/post_editor_screen.dart';

/// Route Chỉnh sửa ảnh (PostEditorScreen) nằm ngoài ShellRoute
GoRoute buildCameraEditorRoute(GlobalKey<NavigatorState> rootNavigatorKey) {
  return GoRoute(
    path: AppRoutes.cameraEditor,
    name: AppRoutes.cameraEditorName,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final imagePath = state.uri.queryParameters['imagePath'] ?? '';
      return PostEditorScreen(imagePath: imagePath);
    },
  );
}

/// Route Máy ảnh (CameraScreen) nằm trong ShellRoute (Main Tab)
GoRoute buildCameraTabRoute() {
  return GoRoute(
    path: AppRoutes.camera,
    name: AppRoutes.cameraName,
    builder: (context, state) => const CameraScreen(),
  );
}
