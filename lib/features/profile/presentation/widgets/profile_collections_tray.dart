import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Widget hiển thị danh sách các thư mục Bộ sưu tập theo chủ đề (Collections Tray).
class ProfileCollectionsTray extends StatelessWidget {
  final List<PostEntity> bookmarkedPosts;
  final bool isLight;

  const ProfileCollectionsTray({
    super.key,
    required this.bookmarkedPosts,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final collections = [
      {'name': 'Địa điểm muốn đến', 'icon': Icons.map_outlined, 'color': AppColors.primary},
      {'name': 'Quán cà phê đẹp', 'icon': Icons.local_cafe_outlined, 'color': Colors.amber.shade700},
      {'name': 'Ảnh chụp đẹp', 'icon': Icons.photo_camera_outlined, 'color': Colors.purple},
    ];

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
                '${collections.length} thư mục',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 95,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final col = collections[index];
              final colName = col['name'] as String;
              final colIcon = col['icon'] as IconData;
              final colColor = col['color'] as Color;

              final matchingCount = bookmarkedPosts
                  .where((p) => p.savedCollectionName == colName)
                  .length;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 135,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[100] : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isLight
                          ? AppColors.borderLight
                          : AppColors.borderDark,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(colIcon, color: colColor, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        colName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$matchingCount bài lưu',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
