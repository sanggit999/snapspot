import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';

/// Purpose: Main Shell Navigation Layout wrapping bottom navigation destinations across SnapSpot.
/// Nâng cấp giao diện Glassmorphism với Nút Đăng Bài Nổi Bật ở Trung Tâm.
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
        context.go('/profile/me');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isLight ? Colors.white : AppColors.surfaceDark,
          border: Border(
            top: BorderSide(
              color: isLight
                  ? Colors.black.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 58,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tab 1: Home
                _buildNavItem(
                  context,
                  index: 0,
                  selectedIndex: selectedIndex,
                  activeIcon: Icons.home_rounded,
                  inactiveIcon: Icons.home_outlined,
                  label: context.tr('home'),
                ),
                // Tab 2: Explore Map
                _buildNavItem(
                  context,
                  index: 1,
                  selectedIndex: selectedIndex,
                  activeIcon: Icons.explore_rounded,
                  inactiveIcon: Icons.explore_outlined,
                  label: context.tr('explore'),
                ),
                // Tab 3: Camera / Add (Nút Center nổi bật)
                GestureDetector(
                  onTap: () => _onItemTapped(2, context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF833AB4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                // Tab 4: Chat
                _buildNavItem(
                  context,
                  index: 3,
                  selectedIndex: selectedIndex,
                  activeIcon: Icons.chat_bubble_rounded,
                  inactiveIcon: Icons.chat_bubble_outline_rounded,
                  label: context.tr('chat'),
                ),
                // Tab 5: Profile
                _buildNavItem(
                  context,
                  index: 4,
                  selectedIndex: selectedIndex,
                  activeIcon: Icons.person_rounded,
                  inactiveIcon: Icons.person_outline_rounded,
                  label: context.tr('profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required int selectedIndex,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return InkWell(
      onTap: () => _onItemTapped(index, context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                key: ValueKey<bool>(isSelected),
                size: 24,
                color: isSelected
                    ? AppColors.primary
                    : (isLight
                        ? AppColors.textLightSecondary
                        : AppColors.textDarkSecondary),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isLight
                        ? AppColors.textLightSecondary
                        : AppColors.textDarkSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
