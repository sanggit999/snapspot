import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Widget hiển thị danh sách các thư mục Bộ sưu tập theo chủ đề (Collections Tray).
/// Hỗ trợ lọc (filter) hiển thị danh sách bài viết theo Bộ sưu tập được chọn.
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
      {'name': 'Tất cả', 'icon': Icons.collections_bookmark_rounded, 'color': AppColors.primary},
      {'name': 'Địa điểm muốn đến', 'icon': Icons.map_outlined, 'color': AppColors.primary},
      {'name': 'Quán cà phê đẹp', 'icon': Icons.local_cafe_outlined, 'color': Colors.amber.shade700},
      {'name': 'Ảnh chụp đẹp', 'icon': Icons.photo_camera_outlined, 'color': Colors.purple},
      {'name': 'Kinh nghiệm du lịch', 'icon': Icons.explore_outlined, 'color': Colors.teal},
    ];

    final activeCollection = selectedCollection ?? 'Tất cả';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              const Text(
                'Bộ sưu tập của bạn',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                activeCollection == 'Tất cả' ? 'Tất cả thư mục' : 'Đang lọc: $activeCollection',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: activeCollection == 'Tất cả' ? Colors.grey : AppColors.primary,
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
              final colName = col['name'] as String;
              final colIcon = col['icon'] as IconData;
              final colColor = col['color'] as Color;
              final isSelected = activeCollection == colName;

              final matchingCount = colName == 'Tất cả'
                  ? bookmarkedPosts.length
                  : bookmarkedPosts
                      .where((p) => p.savedCollectionName == colName)
                      .length;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (isSelected && colName != 'Tất cả') {
                      onCollectionSelected('Tất cả');
                    } else {
                      onCollectionSelected(colName);
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
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : (isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$matchingCount bài lưu',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isSelected ? AppColors.primary : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
