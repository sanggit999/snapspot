import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_comment_section.dart';
import 'package:snapspot/features/feed/presentation/widgets/spot_card.dart';

/// Màn hình Chi tiết bài viết (Post Detail Screen).
/// Hiển thị tên tác giả bài viết ở AppBar Title chuẩn UI/UX cá nhân hóa (Bài viết của Trần Lan Anh).
class PostDetailScreen extends StatefulWidget {
  final String postId;
  final bool focusComment;

  const PostDetailScreen({
    super.key,
    required this.postId,
    this.focusComment = false,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostEntity? _post;

  @override
  void initState() {
    super.initState();
    _findPost();
  }

  void _findPost() {
    final matching = MockData.mockPosts.where((p) => p.id == widget.postId);
    if (matching.isNotEmpty) {
      _post = matching.first;
    } else {
      _post = MockData.mockPosts[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    if (_post == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr('post_detail'))),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final post = _post!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bài viết của ${post.user.fullName}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: PostCommentSection(
          autoFocusInput: widget.focusComment,
          headerWidget: SpotCard(
            post: post,
            isInDetailScreen: true,
            onLikePressed: (postId) {
              setState(() {
                final isLiked = !post.isLiked;
                _post = post.copyWith(
                  isLiked: isLiked,
                  likesCount:
                      isLiked ? post.likesCount + 1 : post.likesCount - 1,
                );
              });
            },
          ),
          comments: post.comments,
          postAuthorId: post.user.id,
          onCommentSubmitted: (content) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
