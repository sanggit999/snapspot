import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/constants/collection_icons.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/profile/domain/entities/collection_entity.dart';
import 'package:snapspot/features/profile/presentation/blocs/collections_cubit.dart';
import 'package:snapspot/features/profile/presentation/blocs/collections_state.dart';
import 'package:snapspot/features/profile/presentation/widgets/create_collection_dialog.dart';

/// Widget hiển thị danh sách các thư mục Bộ sưu tập theo chủ đề (Collections Tray).
/// Render 100% ĐỘNG từ CollectionsCubit, hỗ trợ Lọc, Tạo mới, Chỉnh sửa & Xóa bộ sưu tập.
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

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCollectionKey = selectedCollection ?? 'ALL';

    return BlocBuilder<CollectionsCubit, CollectionsState>(
      builder: (context, state) {
        List<CollectionEntity> userCollections = [];
        if (state is CollectionsLoaded) {
          userCollections = state.collections;
        }

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
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  // Nút 1: Nút "Tất cả" bài viết đã lưu
                  _buildCollectionChip(
                    context: context,
                    id: 'ALL',
                    name: context.tr('all'),
                    icon: Icons.collections_bookmark_rounded,
                    color: AppColors.primary,
                    matchingCount: bookmarkedPosts.length,
                    isSelected: activeCollectionKey == 'ALL' || activeCollectionKey == 'Tất cả',
                    onTap: () {
                      onCollectionSelected('ALL');
                    },
                  ),

                  // Các bộ sưu tập cá nhân hóa của người dùng (Render Động)
                  ...userCollections.map((col) {
                    final matchingCount = bookmarkedPosts
                        .where((p) => p.savedCollectionName == col.name)
                        .length;

                    return _buildCollectionChip(
                      context: context,
                      id: col.id,
                      name: col.name,
                      icon: AppCollectionIcons.getIcon(col.iconName),
                      color: _parseColor(col.colorHex),
                      matchingCount: matchingCount,
                      isSelected: activeCollectionKey == col.name || activeCollectionKey == col.id,
                      isPrivate: col.isPrivate,
                      onTap: () {
                        if (activeCollectionKey == col.name) {
                          onCollectionSelected('ALL');
                        } else {
                          onCollectionSelected(col.name);
                        }
                      },
                      onLongPress: () async {
                        HapticFeedback.mediumImpact();
                        await CreateCollectionDialog.show(context, collection: col);
                      },
                    );
                  }),

                  // Nút Tạo bộ sưu tập đầu tiên (Hàng ngang side-by-side 100% cùng hàng với nút Tất cả)
                  if (userCollections.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            await CreateCollectionDialog.show(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 74,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: isLight ? 0.08 : 0.18),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.18),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  context.tr('create_first_collection'),
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Nút Tạo mới (khi đã có ít nhất 1 Bộ sưu tập)
                  if (userCollections.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          await CreateCollectionDialog.show(context);
                        },
                        child: Container(
                          width: 110,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isLight ? Colors.grey[100] : AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isLight ? AppColors.borderLight : AppColors.borderDark,
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                context.tr('create_new'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Divider(height: 1),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCollectionChip({
    required BuildContext context,
    required String id,
    required String name,
    required IconData icon,
    required Color color,
    required int matchingCount,
    required bool isSelected,
    bool isPrivate = false,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        onLongPress: onLongPress,
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
                  Icon(icon, color: isSelected ? AppColors.primary : color, size: 22),
                  const Spacer(),
                  if (isPrivate)
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: isLight ? Colors.grey[600] : Colors.grey[400],
                    )
                  else if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                name,
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
  }
}
