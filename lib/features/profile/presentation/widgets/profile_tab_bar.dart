import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Delegate dựng TabBar ghim cố định trên CustomScrollView của ProfileScreen.
/// Phân biệt rõ ràng giữa Tab Đã lưu (của Tôi) và Tab Điểm check-in (của User khác).
class ProfileTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final int secondaryCount;
  final bool isMe;
  final ValueChanged<int> onTabSelected;
  final bool isLight;

  const ProfileTabHeaderDelegate({
    required this.selectedIndex,
    required this.secondaryCount,
    required this.isMe,
    required this.onTabSelected,
    required this.isLight,
  });

  @override
  double get minExtent => 44.0;

  @override
  double get maxExtent => 44.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: isLight ? Colors.white : AppColors.surfaceDark,
      child: Row(
        children: [
          // Tab 1: Bài viết
          Expanded(
            child: InkWell(
              onTap: () => onTabSelected(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.grid_on_rounded,
                    color: selectedIndex == 0 ? AppColors.primary : Colors.grey,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2.5,
                    color: selectedIndex == 0 ? AppColors.primary : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),

          // Tab 2: Đã lưu (của Tôi) hoặc Điểm check-in (của User khác)
          Expanded(
            child: InkWell(
              onTap: () => onTabSelected(1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isMe ? Icons.bookmark_rounded : Icons.location_on_rounded,
                        color: selectedIndex == 1 ? AppColors.primary : Colors.grey,
                        size: 22,
                      ),
                      if (secondaryCount > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: selectedIndex == 1 ? AppColors.primary : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$secondaryCount',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2.5,
                    color: selectedIndex == 1 ? AppColors.primary : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(ProfileTabHeaderDelegate oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.secondaryCount != secondaryCount ||
        oldDelegate.isMe != isMe ||
        oldDelegate.isLight != isLight;
  }
}
