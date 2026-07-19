import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';

/// Layout chính bao bọc toàn bộ các màn hình của thanh điều hướng BottomNavigationBar.
/// Tự động đồng bộ tab hiện tại với đường dẫn của GoRouter.
class MainNavigationLayout extends StatelessWidget {
  final Widget child;

  const MainNavigationLayout({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/' || location.startsWith('/feed')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/camera')) return 2;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/explore');
        break;
      case 2:
        context.go('/camera');
        break;
      case 3:
        context.go('/chat');
        break;
      case 4:
        // Đi tới profile của người đăng nhập hiện tại
        context.go('/profile/me');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _onItemTapped(index, context),
          backgroundColor: theme.colorScheme.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.12),
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(
                Icons.home_outlined,
                color: AppColors.textLightSecondary,
              ),
              selectedIcon: const Icon(
                Icons.home_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('home'),
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.explore_outlined,
                color: AppColors.textLightSecondary,
              ),
              selectedIcon: const Icon(
                Icons.explore_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('explore'),
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppColors.textLightSecondary,
              ),
              selectedIcon: const Icon(
                Icons.add_circle_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('camera'),
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.textLightSecondary,
              ),
              selectedIcon: const Icon(
                Icons.chat_bubble_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('chat'),
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.person_outline,
                color: AppColors.textLightSecondary,
              ),
              selectedIcon: const Icon(
                Icons.person_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
