import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Section hiển thị danh sách bình luận cao cấp:
/// - Thả tim từng bình luận (Like Comment).
/// - Trả lời bình luận (Reply) lùi lề lồng nhau.
/// - Ô nhập liệu chuẩn hóa style + Đính kèm Ảnh & GIF.
class PostCommentSection extends StatefulWidget {
  final List<CommentEntity> comments;
  final void Function(String content)? onCommentSubmitted;

  const PostCommentSection({
    super.key,
    required this.comments,
    this.onCommentSubmitted,
  });

  @override
  State<PostCommentSection> createState() => _PostCommentSectionState();
}

class _PostCommentSectionState extends State<PostCommentSection> {
  late List<CommentEntity> _commentList;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedMediaUrl;
  CommentEntity? _replyToComment; // Bình luận đang được trả lời
  bool _isSending = false;

  final List<String> _mockGifs = [
    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExM3hndnp0MWszcmUyd3JodXU1dndmNmFvdTJ1anR3azRtZXc0eHl5eCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l41K3o5TKS79ht83S/giphy.gif',
    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNndicmVldmUybHZ1dzN4bGt3eHdtNGlyOGZ3azNvaWRoOTdrMWd1ayZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/26u4b45b8KXYCUsU0/giphy.gif',
    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcjlza3g1Z3J5cnNmYnNxbWhsNWNsdHFoenNmN2gxdjlyZXNudjlnMCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o7TKSjRrfIPjeiVyM/giphy.gif',
    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcGZtbXU2Mmxwd3VqNWFndnlndXBnaW1sbnAwOHdqamk1aWZvZXZxeiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/xT0xezQGU5xCDJuCPe/giphy.gif',
  ];

  @override
  void initState() {
    super.initState();
    _commentList = List.from(widget.comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

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

  void _initiateReply(CommentEntity comment) {
    setState(() {
      _replyToComment = comment;
      _commentController.text = '@${comment.user.username} ';
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length),
      );
    });
    _inputFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyToComment = null;
      _commentController.clear();
    });
  }

  void _toggleLikeComment(CommentEntity comment, {bool isReply = false, String? parentId}) {
    setState(() {
      if (!isReply) {
        final idx = _commentList.indexWhere((c) => c.id == comment.id);
        if (idx != -1) {
          final target = _commentList[idx];
          final newIsLiked = !target.isLiked;
          _commentList[idx] = target.copyWith(
            isLiked: newIsLiked,
            likesCount: newIsLiked ? target.likesCount + 1 : target.likesCount - 1,
          );
        }
      } else if (parentId != null) {
        final parentIdx = _commentList.indexWhere((c) => c.id == parentId);
        if (parentIdx != -1) {
          final parent = _commentList[parentIdx];
          final replyIdx = parent.replies.indexWhere((r) => r.id == comment.id);
          if (replyIdx != -1) {
            final replyTarget = parent.replies[replyIdx];
            final newIsLiked = !replyTarget.isLiked;
            final updatedReplies = List<CommentEntity>.from(parent.replies);
            updatedReplies[replyIdx] = replyTarget.copyWith(
              isLiked: newIsLiked,
              likesCount: newIsLiked ? replyTarget.likesCount + 1 : replyTarget.likesCount - 1,
            );
            _commentList[parentIdx] = parent.copyWith(replies: updatedReplies);
          }
        }
      }
    });
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty && _selectedMediaUrl == null) return;

    setState(() {
      _isSending = true;
    });

    final newComment = CommentEntity(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      postId: _commentList.isNotEmpty ? _commentList.first.postId : 'post_1',
      user: MockData.mockUsers[0], // Nguyễn Văn Sang (Chính mình)
      content: text,
      mediaUrl: _selectedMediaUrl,
      parentId: _replyToComment?.id,
      createdAt: DateTime.now(),
    );

    setState(() {
      if (_replyToComment != null) {
        // Đính kèm vào bình luận con
        final parentIdx = _commentList.indexWhere((c) => c.id == _replyToComment!.id);
        if (parentIdx != -1) {
          final parent = _commentList[parentIdx];
          final updatedReplies = List<CommentEntity>.from(parent.replies)..add(newComment);
          _commentList[parentIdx] = parent.copyWith(replies: updatedReplies);
        } else {
          _commentList.add(newComment);
        }
      } else {
        _commentList.add(newComment);
      }

      _commentController.clear();
      _selectedMediaUrl = null;
      _replyToComment = null;
      _isSending = false;
    });

    widget.onCommentSubmitted?.call(text);

    // Cuộn xuống đáy
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final currentUser = MockData.mockUsers[0];

    return Column(
      children: [
        // 1. Tiêu đề số lượng bình luận
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                '${context.tr('comments')} (${_commentList.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 2. Danh sách các bình luận kèm các phản hồi lồng nhau
        Expanded(
          child: _commentList.isEmpty
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
                  itemCount: _commentList.length,
                  itemBuilder: (context, index) {
                    final comment = _commentList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bình luận chính (Root Comment)
                        _buildCommentItem(
                          context,
                          comment: comment,
                          isLight: isLight,
                          onReply: () => _initiateReply(comment),
                          onLike: () => _toggleLikeComment(comment),
                        ),

                        // Danh sách bình luận phản hồi lùi lề (Replies)
                        if (comment.replies.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 36.0),
                            child: Column(
                              children: comment.replies
                                  .map(
                                    (reply) => _buildCommentItem(
                                      context,
                                      comment: reply,
                                      isLight: isLight,
                                      isReply: true,
                                      onReply: () => _initiateReply(comment),
                                      onLike: () => _toggleLikeComment(
                                        reply,
                                        isReply: true,
                                        parentId: comment.id,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),

        // 3. Banner Hiển thị Trạng thái "Đang trả lời @user..."
        if (_replyToComment != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: isLight ? Colors.purple[50] : Colors.purple[900]?.withValues(alpha: 0.3),
            child: Row(
              children: [
                const Icon(Icons.reply_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Đang trả lời ${_replyToComment!.user.fullName} (@${_replyToComment!.user.username})',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _cancelReply,
                  child: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
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

        // 5. Ô nhập liệu bình luận mới (Chuẩn hóa Style Input hoàn hảo)
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

              // Ô nhập liệu TextField
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
                    hintText: _replyToComment != null
                        ? 'Trả lời bình luận...'
                        : 'Thêm bình luận...',
                    hintStyle: const TextStyle(fontSize: 13.5, color: Colors.grey),
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
                        // Nút Đính kèm Ảnh (Nhỏ gọn sát lề)
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
                        // Nút Đính kèm GIF (Nhỏ gọn sát lề)
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

              // Nút Gửi màu Primary
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

  Widget _buildCommentItem(
    BuildContext context, {
    required CommentEntity comment,
    required bool isLight,
    bool isReply = false,
    required VoidCallback onReply,
    required VoidCallback onLike,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(
            imageUrl: comment.user.avatarUrl,
            size: isReply ? AppAvatarSize.small : AppAvatarSize.small,
            onTap: () => context.push('/user/profile/${comment.user.id}'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[100] : Colors.grey[900],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isLight
                              ? AppColors.textLightPrimary
                              : AppColors.textDarkPrimary,
                        ),
                      ),
                      if (comment.content.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          comment.content,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isLight
                                ? AppColors.textLightPrimary
                                : AppColors.textDarkPrimary,
                          ),
                        ),
                      ],
                      if (comment.mediaUrl != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: comment.mediaUrl!,
                            height: 120,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 120,
                              color: Colors.grey[800],
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image_outlined, size: 30),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // Dải tương tác bên dưới Comment (Thời gian • Nút Trả lời • Nút Tim)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        DateFormat('HH:mm dd/MM/yyyy').format(comment.createdAt),
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onReply,
                      child: const Text(
                        'Trả lời',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Nút Thả tim bình luận
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 14,
                            color: comment.isLiked ? Colors.redAccent : Colors.grey,
                          ),
                          if (comment.likesCount > 0) ...[
                            const SizedBox(width: 3),
                            Text(
                              '${comment.likesCount}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: comment.isLiked ? Colors.redAccent : Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
