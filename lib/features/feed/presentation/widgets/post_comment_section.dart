import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/app_avatar.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

class PostCommentSection extends StatelessWidget {
  final List<CommentEntity> comments;
  const PostCommentSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${context.tr('comments')} (${comments.length})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        if (comments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text('Chưa có bình luận nào. Hãy là người đầu tiên!'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAvatar(
                      imageUrl: comment.user.avatarUrl,
                      size: AppAvatarSize.small,
                      onTap: () => context.push('/user/profile/${comment.user.id}'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.brightness == Brightness.light
                                    ? Colors.black87
                                    : Colors.white70,
                              ),
                              children: [
                                TextSpan(
                                  text: '${comment.user.fullName} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: comment.content),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('HH:mm dd/MM/yyyy')
                                .format(comment.createdAt),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
