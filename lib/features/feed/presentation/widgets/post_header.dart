import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/widgets/app_avatar.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';

class PostHeader extends StatelessWidget {
  final PostEntity post;
  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: post.user.avatarUrl,
            size: AppAvatarSize.medium,
            onTap: () => context.push('/user/profile/${post.user.id}'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.user.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '@${post.user.username}',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          // Nút Like
          IconButton(
            icon: Icon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              color: post.isLiked ? Colors.red : null,
            ),
            onPressed: () {
              context.read<FeedCubit>().toggleLike(post.id);
            },
          ),
          Text(
            '${post.likesCount}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
