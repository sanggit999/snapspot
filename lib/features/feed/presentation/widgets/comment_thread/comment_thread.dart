import 'package:flutter/material.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/comment_actions.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/comment_avatar.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/comment_content.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/thread_connector.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/thread_reply_item.dart';

/// Entry point duy nhất cho toàn bộ nhóm bình luận + các reply lồng nhau.
class CommentThread extends StatefulWidget {
  final CommentEntity rootComment;
  final bool isLight;
  final VoidCallback onReplyToRoot;
  final VoidCallback onLikeRoot;
  final VoidCallback? onOptionsTapRoot;
  final void Function(int replyIndex) onReplyToReply;
  final void Function(int replyIndex) onLikeReply;
  final void Function(int replyIndex)? onOptionsTapReply;

  /// ID tác giả của bài viết (OP - Original Poster) để kiểm tra nhãn "Tác giả".
  final String? postAuthorId;

  /// Số lượng reply hiển thị mặc định trước khi hiện nút "Xem thêm". Mặc định = 3.
  final int initialShowCount;

  /// Callback bất đồng bộ tùy chọn khi bấm Xem thêm (dành cho API pagination/fetch thêm server).
  final Future<void> Function()? onLoadMoreReplies;

  const CommentThread({
    super.key,
    required this.rootComment,
    required this.isLight,
    required this.onReplyToRoot,
    required this.onLikeRoot,
    this.onOptionsTapRoot,
    required this.onReplyToReply,
    required this.onLikeReply,
    this.onOptionsTapReply,
    this.postAuthorId,
    this.initialShowCount = 3,
    this.onLoadMoreReplies,
  });

  @override
  State<CommentThread> createState() => _CommentThreadState();
}

class _CommentThreadState extends State<CommentThread> {
  bool _isExpanded = false;
  bool _isLoadingMore = false;

  /// Phải khớp với AppAvatarSize.small.dimension = 24.0
  static const double _avatarSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final lineColor =
        widget.isLight ? Colors.grey.shade300 : Colors.grey.shade800;
    final replies = widget.rootComment.replies;
    final hasReplies = replies.isNotEmpty;
    final totalReplies = widget.rootComment.totalRepliesCount;
    final hasMore = totalReplies > widget.initialShowCount;

    // Số lượng reply hiển thị thực tế dựa trên state _isExpanded
    final visibleCount = (_isExpanded || !hasMore)
        ? totalReplies
        : widget.initialShowCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Root Comment ─────────────────────────────────────────────────────
        _RootCommentTile(
          rootComment: widget.rootComment,
          isLight: widget.isLight,
          hasReplies: hasReplies,
          lineColor: lineColor,
          avatarSize: _avatarSize,
          postAuthorId: widget.postAuthorId,
          onReply: widget.onReplyToRoot,
          onLike: widget.onLikeRoot,
          onOptionsTap: widget.onOptionsTapRoot,
        ),

        // ── Reply list kèm hiệu ứng mở rộng mượt mà (AnimatedSize) ───────────
        if (hasReplies)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.fastOutSlowIn,
              child: Column(
                children: [
                  // Hiển thị danh sách reply trong giới hạn visibleCount
                  ...List.generate(
                    visibleCount,
                    (i) {
                      final isLastItem = (i == visibleCount - 1) &&
                          (!_isExpanded ? !hasMore : true);
                      return ThreadReplyItem(
                        reply: replies[i],
                        isLast: isLastItem,
                        isLight: widget.isLight,
                        lineColor: lineColor,
                        postAuthorId: widget.postAuthorId,
                        onReply: () => widget.onReplyToReply(i),
                        onLike: () => widget.onLikeReply(i),
                        onOptionsTap: widget.onOptionsTapReply != null
                            ? () => widget.onOptionsTapReply!(i)
                            : null,
                      );
                    },
                  ),

                  // Nút "Xem thêm X câu trả lời" khi chưa mở rộng và có nhiều cmt
                  if (hasMore && !_isExpanded)
                    _ViewMoreRepliesTile(
                      hiddenCount: totalReplies - widget.initialShowCount,
                      lineColor: lineColor,
                      isLight: widget.isLight,
                      isLoading: _isLoadingMore,
                      onTap: () async {
                        if (widget.onLoadMoreReplies != null) {
                          setState(() => _isLoadingMore = true);
                          await widget.onLoadMoreReplies!();
                          if (mounted) setState(() => _isLoadingMore = false);
                        }
                        if (mounted) {
                          setState(() => _isExpanded = true);
                        }
                      },
                    ),

                  // Nút "Thu gọn" khi đã mở rộng
                  if (hasMore && _isExpanded)
                    _CollapseRepliesTile(
                      isLight: widget.isLight,
                      onTap: () {
                        setState(() => _isExpanded = false);
                      },
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _RootCommentTile
// ─────────────────────────────────────────────────────────────────────────────

class _RootCommentTile extends StatelessWidget {
  final CommentEntity rootComment;
  final bool isLight;
  final bool hasReplies;
  final Color lineColor;
  final double avatarSize;
  final String? postAuthorId;
  final VoidCallback onReply;
  final VoidCallback onLike;
  final VoidCallback? onOptionsTap;

  const _RootCommentTile({
    required this.rootComment,
    required this.isLight,
    required this.hasReplies,
    required this.lineColor,
    required this.avatarSize,
    this.postAuthorId,
    required this.onReply,
    required this.onLike,
    this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAuthor =
        postAuthorId != null && rootComment.isPostAuthor(postAuthorId!);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AvatarWithLine(
              userId: rootComment.user.id,
              imageUrl: rootComment.user.avatarUrl,
              hasReplies: hasReplies,
              lineColor: lineColor,
              avatarSize: avatarSize,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommentContent(
                      authorName: rootComment.user.fullName,
                      replyToName: rootComment.replyToUser?.fullName,
                      text: rootComment.content,
                      mediaUrl: rootComment.mediaUrl,
                      isLight: isLight,
                      isAuthor: isAuthor,
                      isPinned: rootComment.isPinned,
                    ),
                    const SizedBox(height: 4),
                    CommentActions(
                      createdAt: rootComment.createdAt,
                      isLiked: rootComment.isLiked,
                      likesCount: rootComment.likesCount,
                      onReply: onReply,
                      onLike: onLike,
                      onOptionsTap: onOptionsTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AvatarWithLine
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarWithLine extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final bool hasReplies;
  final Color lineColor;
  final double avatarSize;

  const _AvatarWithLine({
    required this.userId,
    required this.imageUrl,
    required this.hasReplies,
    required this.lineColor,
    required this.avatarSize,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasReplies) {
      return CommentAvatar(userId: userId, imageUrl: imageUrl);
    }

    return SizedBox(
      width: avatarSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommentAvatar(userId: userId, imageUrl: imageUrl),
          Expanded(
            child: Container(
              width: 2,
              color: lineColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ViewMoreRepliesTile
// ─────────────────────────────────────────────────────────────────────────────

class _ViewMoreRepliesTile extends StatelessWidget {
  final int hiddenCount;
  final Color lineColor;
  final bool isLight;
  final bool isLoading;
  final VoidCallback onTap;

  static const double _avatarSize = 24.0;

  const _ViewMoreRepliesTile({
    required this.hiddenCount,
    required this.lineColor,
    required this.isLight,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLight ? Colors.grey.shade700 : Colors.grey.shade400;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThreadConnector(
            lineColor: lineColor,
            isLast: true,
            avatarSize: _avatarSize,
          ),
          Expanded(
            child: GestureDetector(
              onTap: isLoading ? null : onTap,
              child: Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 12),
                child: Row(
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      )
                    else ...[
                      Text(
                        'Xem thêm $hiddenCount câu trả lời',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: textColor,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CollapseRepliesTile
// ─────────────────────────────────────────────────────────────────────────────

class _CollapseRepliesTile extends StatelessWidget {
  final bool isLight;
  final VoidCallback onTap;

  const _CollapseRepliesTile({
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLight ? Colors.grey.shade600 : Colors.grey.shade500;

    return Padding(
      padding: const EdgeInsets.only(left: 36, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Thu gọn',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 14,
                color: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
