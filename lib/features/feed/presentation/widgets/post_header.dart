import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Purpose: Clean and elegant header section for feed posts.
class PostHeader extends StatelessWidget {
  final PostEntity post;

  const PostHeader({super.key, required this.post});

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    } else {
      return DateFormat('dd/MM').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Row(
        children: [
          // Avatar với Story Ring
          AppAvatar(
            imageUrl: post.user.avatarUrl,
            size: AppAvatarSize.medium,
            hasStory: true,
            onTap: () => context.push('/user/profile/${post.user.id}'),
          ),
          const SizedBox(width: 12),
          // Thông tin Người dùng & Thời gian
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        post.user.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: isLight
                              ? AppColors.textLightPrimary
                              : AppColors.textDarkPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '@${post.user.username}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isLight
                            ? AppColors.textLightSecondary
                            : AppColors.textDarkSecondary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '•',
                        style: TextStyle(
                          fontSize: 10,
                          color: isLight
                              ? AppColors.textLightSecondary
                              : AppColors.textDarkSecondary,
                        ),
                      ),
                    ),
                    Text(
                      _formatTimeAgo(post.createdAt),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isLight
                            ? AppColors.textLightSecondary
                            : AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Nút More options
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: isLight
                  ? AppColors.textLightSecondary
                  : AppColors.textDarkSecondary,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tùy chọn bài viết'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
