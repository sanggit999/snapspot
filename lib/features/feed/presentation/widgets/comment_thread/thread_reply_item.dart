import 'package:flutter/material.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/comment_actions.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/comment_avatar.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/comment_content.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/thread_connector.dart';

/// Render một item reply trong luồng hội thoại chuẩn Threads (Meta) / Reddit.
class ThreadReplyItem extends StatelessWidget {
  final CommentEntity reply;
  final bool isLast;
  final bool isLight;
  final Color lineColor;
  final VoidCallback onReply;
  final VoidCallback onLike;
  final VoidCallback? onOptionsTap;

  /// ID tác giả của bài viết (OP - Original Poster) để gắn nhãn "Tác giả".
  final String? postAuthorId;

  /// Phải khớp AppAvatarSize.small.dimension = 24.0
  static const double _avatarSize = 24.0;

  const ThreadReplyItem({
    super.key,
    required this.reply,
    required this.isLast,
    required this.isLight,
    required this.lineColor,
    required this.onReply,
    required this.onLike,
    this.onOptionsTap,
    this.postAuthorId,
  });

  @override
  Widget build(BuildContext context) {
    final isAuthor = postAuthorId != null && reply.isPostAuthor(postAuthorId!);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. ThreadConnector nối mượt mà từ luồng thread chính
          ThreadConnector(
            lineColor: lineColor,
            isLast: isLast,
            avatarSize: _avatarSize,
          ),

          // 2. Avatar người reply
          CommentAvatar(
            userId: reply.user.id,
            imageUrl: reply.user.avatarUrl,
          ),

          const SizedBox(width: 8),

          // 3. Cột nội dung: Bubble (Tên A ▶ Tên B, Badge Tác giả, Ghim) + Actions + 12px spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommentContent(
                  authorName: reply.user.fullName,
                  replyToName: reply.replyToUser?.fullName,
                  text: reply.content,
                  mediaUrl: reply.mediaUrl,
                  isLight: isLight,
                  isAuthor: isAuthor,
                  isPinned: reply.isPinned,
                ),
                const SizedBox(height: 4),
                CommentActions(
                  createdAt: reply.createdAt,
                  isLiked: reply.isLiked,
                  likesCount: reply.likesCount,
                  onReply: onReply,
                  onLike: onLike,
                  onOptionsTap: onOptionsTap,
                ),
                // 12px spacing TRONG IntrinsicHeight → canvas bao phủ → line không đứt.
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
