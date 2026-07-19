import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

class PostDetailContent extends StatelessWidget {
  final PostEntity post;
  const PostDetailContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Địa điểm check-in
          InkWell(
            onTap: () {
              context.go('/explore');
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      post.locationName,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Caption
          Text(
            post.caption,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
          ),
          // Hashtags
          if (post.hashtags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: post.hashtags.map((tag) {
                return Text(
                  '#$tag',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 8),
          // Thời gian đăng bài
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(post.createdAt),
            style: theme.textTheme.labelSmall?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
