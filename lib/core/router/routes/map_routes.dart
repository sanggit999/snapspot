import 'package:go_router/go_router.dart';
import 'package:snapspot/core/router/app_routes.dart';
import 'package:snapspot/features/map/presentation/screens/map_explore_screen.dart';

/// Route Khám phá Bản đồ nằm trong ShellRoute (Main Tab)
GoRoute buildMapTabRoute() {
  return GoRoute(
    path: AppRoutes.explore,
    name: AppRoutes.exploreName,
    builder: (context, state) => const MapExploreScreen(),
  );
}
