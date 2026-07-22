import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Widget hiển thị danh sách các thư mục Bộ sưu tập theo chủ đề (Collections Tray).
/// Hỗ trợ lọc (filter) hiển thị danh sách bài viết theo Bộ sưu tập được chọn chuẩn Type Scale & Multi-Language.
class ProfileCollectionsTray extends StatelessWidget {
  final List<PostEntity> bookmarkedPosts;
  final String? selectedCollection;
  final ValueChanged<String?> onCollectionSelected;
  final bool isLight;

  const ProfileCollectionsTray({
    super.key,
    required this.bookmarkedPosts,
    required this.selectedCollection,
    required this.onCollectionSelected,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final collections = [
      {'key': 'ALL', 'name': context.tr('all'), 'icon': Icons.collections_bookmark_rounded, 'color': AppColors.primary},
      {'key': 'Địa điểm muốn đến', 'name': 'Địa điểm muốn đến', 'icon': Icons.map_outlined, 'color': AppColors.primary},
      {'key': 'Quán cà phê đẹp', 'name': 'Quán cà phê đẹp', 'icon': Icons.local_cafe_outlined, 'color': Colors.amber.shade700},
      {'key': 'Ảnh chụp đẹp', 'name': 'Ảnh chụp đẹp', 'icon': Icons.photo_camera_outlined, 'color': Colors.purple},
      {'key': 'Kinh nghiệm du lịch', 'name': 'Kinh nghiệm du lịch', 'icon': Icons.explore_outlined, 'color': Colors.teal},
    ];

    final activeCollectionKey = selectedCollection ?? 'ALL';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              Text(
                context.tr('your_collections'),
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Text(
                (activeCollectionKey == 'ALL' || activeCollectionKey == 'Tất cả')
                    ? context.tr('all_folders')
                    : context.tr('filtering_by', args: {'name': activeCollectionKey}),
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: (activeCollectionKey == 'ALL' || activeCollectionKey == 'Tất cả')
                      ? (isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary)
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 98,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final col = collections[index];
              final colKey = col['key'] as String;
              final colName = col['name'] as String;
              final colIcon = col['icon'] as IconData;
              final colColor = col['color'] as Color;
              final isSelected = activeCollectionKey == colKey || (colKey == 'ALL' && activeCollectionKey == 'Tất cả');

              final matchingCount = (colKey == 'ALL' || colKey == 'Tất cả')
                  ? bookmarkedPosts.length
                  : bookmarkedPosts
                      .where((p) => p.savedCollectionName == colKey)
                      .length;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (isSelected && colKey != 'ALL') {
                      onCollectionSelected('ALL');
                    } else {
                      onCollectionSelected(colKey);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 140,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: isLight ? 0.12 : 0.25)
                          : (isLight ? Colors.grey[100] : AppColors.surfaceDark),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isLight ? AppColors.borderLight : AppColors.borderDark),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(colIcon, color: isSelected ? AppColors.primary : colColor, size: 22),
                            const Spacer(),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          colName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : (isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.tr('saved_posts_count', args: {'count': '$matchingCount'}),
                          style: TextStyle(
                            fontSize: 11.0,
                            color: isSelected
                                ? AppColors.primary
                                : (isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Divider(height: 1),
        ),
      ],
    );
  }
}
