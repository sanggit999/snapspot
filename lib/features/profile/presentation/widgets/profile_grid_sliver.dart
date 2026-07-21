import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Widget SliverGrid hiển thị danh sách ảnh bài đăng thumbnail với Lazy Loading mượt mà.
class ProfileGridSliver extends StatelessWidget {
  final List<PostEntity> posts;
  final bool isLight;
  final String emptyMessage;
  final IconData emptyIcon;

  const ProfileGridSliver({
    super.key,
    required this.posts,
    required this.isLight,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  emptyIcon,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  emptyMessage,
                  style: TextStyle(
                    color: isLight
                        ? AppColors.textLightSecondary
                        : AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(4.0),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final post = posts[index];
            final imageUrl = post.imageUrls.isNotEmpty ? post.imageUrls.first : '';

            return GestureDetector(
              onTap: () => context.push('/post/${post.id}'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => Container(
                        color: isLight
                            ? AppColors.borderLight
                            : AppColors.borderDark,
                      ),
                      errorWidget: (ctx, err, stack) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.image, color: Colors.white),
                      ),
                    ),
                    if (post.imageUrls.length > 1)
                      const Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(
                          Icons.collections_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
          childCount: posts.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
      ),
    );
  }
}
