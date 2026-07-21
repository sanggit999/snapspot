import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/comment_thread.dart';

/// Section hiển thị danh sách Bình luận theo chuẩn giao diện Reddit / Threads.
///
/// Chịu trách nhiệm duy nhất:
/// - Quản lý state danh sách bình luận (like, reply, submit).
/// - Dựng khung layout tổng thể (header, list, input bar).
/// - Delegate toàn bộ UI thread cho [CommentThread].
class PostCommentSection extends StatefulWidget {
  final List<CommentEntity> comments;
  final String? postAuthorId;
  final void Function(String content)? onCommentSubmitted;

  const PostCommentSection({
    super.key,
    required this.comments,
    this.postAuthorId,
    this.onCommentSubmitted,
  });

  @override
  State<PostCommentSection> createState() => _PostCommentSectionState();
}

class _PostCommentSectionState extends State<PostCommentSection> {
  late List<CommentEntity> _comments;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedMediaUrl;
  CommentEntity? _parentComment; // Bình luận gốc (Level 0) đang được trả lời
  CommentEntity? _replyTarget; // Đối tượng trực tiếp được bấm trả lời
  bool _isSending = false;

  /// GIF mẫu dùng trong GIF picker. static const: không đổi giữa các instance.
  static const List<String> _mockGifs = [
    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExM3hndnp0MWszcmUyd3JodXU1dndmNmFvdTJ1anR3azRtZXc0eHl5eCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l41K3o5TKS79ht83S/giphy.gif',
    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNndicmVldmUybHZ1dzN4bGt3eHdtNGlyOGZ3azNvaWRoOTdrMWd1ayZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/26u4b45b8KXYCUsU0/giphy.gif',
    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcjlza3g1Z3J5cnNmYnNxbWhsNWNsdHFoenNmN2gxdjlyZXNudjlnMCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o7TKSjRrfIPjeiVyM/giphy.gif',
    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcGZtbXU2Mmxwd3VqNWFndnlndXBnaW1sbnAwOHdqamk1aWZvZXZxeiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/xT0xezQGU5xCDJuCPe/giphy.gif',
  ];

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.comments);
    _sortComments();
  }

  void _sortComments() {
    _comments.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  // ── Business Logic ─────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedMediaUrl = image.path;
        });
      }
    } catch (_) {
      setState(() {
        _selectedMediaUrl =
            'https://images.unsplash.com/photo-1528127269322-539801943592?w=600';
      });
    }
  }

  void _openGifPicker() {
    final isLight = Theme.of(context).brightness == Brightness.light;

    showModalBottomSheet(
      context: context,
      backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chọn ảnh GIF',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _mockGifs.length,
                  itemBuilder: (ctx, index) {
                    final gifUrl = _mockGifs[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMediaUrl = gifUrl;
                          });
                          Navigator.pop(ctx);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: gifUrl,
                            width: 140,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initiateReply({
    required CommentEntity rootComment,
    required CommentEntity targetComment,
  }) {
    setState(() {
      _parentComment = rootComment;
      _replyTarget = targetComment;
      _commentController.text = '@${targetComment.user.username} ';
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length),
      );
    });
    _inputFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _parentComment = null;
      _replyTarget = null;
      _commentController.clear();
    });
  }

  void _toggleLikeComment(CommentEntity comment, {String? parentId}) {
    setState(() {
      if (parentId == null) {
        final idx = _comments.indexWhere((c) => c.id == comment.id);
        if (idx != -1) {
          final target = _comments[idx];
          final newIsLiked = !target.isLiked;
          _comments[idx] = target.copyWith(
            isLiked: newIsLiked,
            likesCount:
                newIsLiked ? target.likesCount + 1 : target.likesCount - 1,
          );
        }
      } else {
        final parentIdx = _comments.indexWhere((c) => c.id == parentId);
        if (parentIdx != -1) {
          final parent = _comments[parentIdx];
          final replyIdx =
              parent.replies.indexWhere((r) => r.id == comment.id);
          if (replyIdx != -1) {
            final replyTarget = parent.replies[replyIdx];
            final newIsLiked = !replyTarget.isLiked;
            final updatedReplies = List<CommentEntity>.from(parent.replies);
            updatedReplies[replyIdx] = replyTarget.copyWith(
              isLiked: newIsLiked,
              likesCount: newIsLiked
                  ? replyTarget.likesCount + 1
                  : replyTarget.likesCount - 1,
            );
            _comments[parentIdx] = parent.copyWith(replies: updatedReplies);
          }
        }
      }
    });
  }

  void _togglePinComment(CommentEntity comment, {String? parentId}) {
    final isCurrentlyPinned = comment.isPinned;
    setState(() {
      if (parentId == null) {
        final index = _comments.indexWhere((c) => c.id == comment.id);
        if (index != -1) {
          final newIsPinned = !isCurrentlyPinned;
          final updatedComment =
              _comments[index].copyWith(isPinned: newIsPinned);
          _comments.removeAt(index);
          if (newIsPinned) {
            _comments.insert(0, updatedComment);
          } else {
            _comments.add(updatedComment);
          }
        }
      } else {
        final parentIdx = _comments.indexWhere((c) => c.id == parentId);
        if (parentIdx != -1) {
          final parent = _comments[parentIdx];
          final replyIdx = parent.replies.indexWhere((r) => r.id == comment.id);
          if (replyIdx != -1) {
            final replyTarget = parent.replies[replyIdx];
            final newIsPinned = !isCurrentlyPinned;
            final updatedReplies = List<CommentEntity>.from(parent.replies);
            updatedReplies[replyIdx] =
                replyTarget.copyWith(isPinned: newIsPinned);
            _comments[parentIdx] = parent.copyWith(replies: updatedReplies);
          }
        }
      }
    });

    _sortComments();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCurrentlyPinned
              ? 'Đã bỏ ghim bình luận.'
              : 'Đã ghim bình luận nổi bật!',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteComment(CommentEntity comment, {String? parentId}) {
    setState(() {
      if (parentId == null) {
        _comments.removeWhere((c) => c.id == comment.id);
      } else {
        final parentIdx = _comments.indexWhere((c) => c.id == parentId);
        if (parentIdx != -1) {
          final parent = _comments[parentIdx];
          final updatedReplies = List<CommentEntity>.from(parent.replies)
            ..removeWhere((r) => r.id == comment.id);
          _comments[parentIdx] = parent.copyWith(replies: updatedReplies);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa bình luận.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCommentOptionsMenu({
    required CommentEntity comment,
    required bool isLight,
    String? parentId,
  }) {
    final currentUserId = MockData.mockUsers[0].id; // 'usr_1' (Nguyễn Văn Sang)
    final postAuthorId = widget.postAuthorId ?? 'usr_2'; // 'usr_2' (Trần Lan Anh)

    // User hiện tại hoặc Tác giả bài viết có quyền ghim & xóa
    final isPostAuthor = currentUserId == postAuthorId || postAuthorId == 'usr_2';
    final isCommentOwner = comment.user.id == currentUserId;

    showModalBottomSheet(
      context: context,
      backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),

                // 1. Tùy chọn Ghim / Bỏ ghim (Dành cho Tác giả bài viết)
                if (isPostAuthor)
                  ListTile(
                    leading: Icon(
                      comment.isPinned
                          ? Icons.push_pin_outlined
                          : Icons.push_pin_rounded,
                      color: Colors.amber.shade700,
                    ),
                    title: Text(
                      comment.isPinned
                          ? 'Bỏ ghim bình luận'
                          : 'Ghim bình luận nổi bật',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _togglePinComment(comment, parentId: parentId);
                    },
                  ),

                // 2. Tùy chọn Xóa bình luận (Tác giả bài viết hoặc Chủ comment)
                if (isCommentOwner || isPostAuthor)
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded,
                        color: Colors.redAccent),
                    title: const Text(
                      'Xóa bình luận',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _deleteComment(comment, parentId: parentId);
                    },
                  ),

                // 3. Tùy chọn Báo cáo bình luận
                if (!isCommentOwner)
                  ListTile(
                    leading: const Icon(Icons.flag_outlined, color: Colors.grey),
                    title: const Text('Báo cáo bình luận này'),
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã gửi báo cáo vi phạm.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty && _selectedMediaUrl == null) return;

    setState(() {
      _isSending = true;
    });

    final newComment = CommentEntity(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      postId: _comments.isNotEmpty ? _comments.first.postId : 'post_1',
      user: MockData.mockUsers[0], // Nguyễn Văn Sang (Chính mình)
      content: text,
      mediaUrl: _selectedMediaUrl,
      parentId: _parentComment?.id,
      createdAt: DateTime.now(),
    );

    setState(() {
      if (_parentComment != null) {
        final parentIdx =
            _comments.indexWhere((c) => c.id == _parentComment!.id);
        if (parentIdx != -1) {
          final parent = _comments[parentIdx];
          final updatedReplies = List<CommentEntity>.from(parent.replies)
            ..add(newComment);
          _comments[parentIdx] = parent.copyWith(replies: updatedReplies);
        } else {
          _comments.add(newComment);
        }
      } else {
        _comments.add(newComment);
      }

      _commentController.clear();
      _selectedMediaUrl = null;
      _parentComment = null;
      _replyTarget = null;
      _isSending = false;
    });

    widget.onCommentSubmitted?.call(text);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  int _getTotalCount() {
    int total = _comments.length;
    for (var c in _comments) {
      total += c.replies.length;
    }
    return total;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final currentUser = MockData.mockUsers[0];

    return Column(
      children: [
        // 1. Header Đếm số lượng bình luận
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                '${context.tr('comments')} (${_getTotalCount()})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 2. Danh sách Bình luận dạng Threaded Comment
        Expanded(
          child: _comments.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Chưa có bình luận nào. Hãy là người đầu tiên!',
                      style: TextStyle(
                        color: isLight
                            ? AppColors.textLightSecondary
                            : AppColors.textDarkSecondary,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final rootComment = _comments[index];
                    return RepaintBoundary(
                      child: CommentThread(
                        rootComment: rootComment,
                        isLight: isLight,
                        postAuthorId: widget.postAuthorId ?? 'usr_2',
                        onReplyToRoot: () => _initiateReply(
                          rootComment: rootComment,
                          targetComment: rootComment,
                        ),
                        onLikeRoot: () => _toggleLikeComment(rootComment),
                        onOptionsTapRoot: () => _showCommentOptionsMenu(
                          comment: rootComment,
                          isLight: isLight,
                        ),
                        onReplyToReply: (i) => _initiateReply(
                          rootComment: rootComment,
                          targetComment: rootComment.replies[i],
                        ),
                        onLikeReply: (i) => _toggleLikeComment(
                          rootComment.replies[i],
                          parentId: rootComment.id,
                        ),
                        onOptionsTapReply: (i) => _showCommentOptionsMenu(
                          comment: rootComment.replies[i],
                          isLight: isLight,
                          parentId: rootComment.id,
                        ),
                      ),
                    );
                  },
                ),
        ),

        // 3. Banner Hiển thị Trạng thái "Đang trả lời @user..."
        if (_replyTarget != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: isLight
                ? Colors.purple[50]
                : Colors.purple[900]?.withValues(alpha: 0.3),
            child: Row(
              children: [
                const Icon(Icons.reply_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Đang trả lời ${_replyTarget!.user.fullName} (@${_replyTarget!.user.username})',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _cancelReply,
                  child: const Icon(Icons.close_rounded,
                      size: 18, color: Colors.grey),
                ),
              ],
            ),
          ),

        // 4. Khung Xem trước Ảnh/GIF đính kèm
        if (_selectedMediaUrl != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: isLight ? Colors.grey[100] : Colors.grey[900],
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: _selectedMediaUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image, size: 30),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Ảnh / GIF đính kèm',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.cancel_rounded,
                      size: 20, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _selectedMediaUrl = null;
                    });
                  },
                ),
              ],
            ),
          ),

        // 5. Ô nhập liệu bình luận mới
        Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 8,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : AppColors.surfaceDark,
            border: Border(
              top: BorderSide(
                color: isLight ? AppColors.borderLight : AppColors.borderDark,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              AppAvatar(
                imageUrl: currentUser.avatarUrl,
                size: AppAvatarSize.small,
              ),
              const SizedBox(width: 8),

              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _inputFocusNode,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submitComment(),
                  style: TextStyle(
                    fontSize: 14,
                    color: isLight
                        ? AppColors.textLightPrimary
                        : AppColors.textDarkPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: _replyTarget != null
                        ? 'Trả lời ${_replyTarget!.user.username}...'
                        : 'Thêm bình luận...',
                    hintStyle:
                        const TextStyle(fontSize: 13.5, color: Colors.grey),
                    filled: true,
                    fillColor: isLight ? Colors.grey[100] : Colors.grey[900],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.image_outlined,
                              size: 21,
                              color: isLight
                                  ? AppColors.textLightSecondary
                                  : AppColors.textDarkSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        GestureDetector(
                          onTap: _openGifPicker,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.gif_box_outlined,
                              size: 23,
                              color: isLight
                                  ? AppColors.textLightSecondary
                                  : AppColors.textDarkSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              IconButton(
                icon: _isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                onPressed: _submitComment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
