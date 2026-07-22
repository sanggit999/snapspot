import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_comment_section.dart';
import 'package:snapspot/features/feed/presentation/widgets/spot_card.dart';

/// Màn hình Chi tiết bài viết (Post Detail Screen).
/// Tự động phân biệt Tiêu đề cá nhân hóa:
/// - Khi TÔI xem bài viết CỦA CHÍNH TÔI -> Tiêu đề: "Bài viết của bạn"
/// - Khi TÔI xem bài viết CỦA TÁC GIẢ KHÁC (Nguyễn Văn Sang, Trần Lan Anh...) -> Tiêu đề: "Bài viết của [Tên tác giả]"
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

    // Kiểm tra chính xác xem tác giả bài viết có phải là người dùng đang đăng nhập hay không
    final authState = context.read<AuthCubit>().state;
    final currentUserId = authState is AuthSuccess ? authState.currentUser.id : MockData.mockUsers[0].id;
    final isMyPost = post.user.id == currentUserId;

    final titleText = isMyPost ? 'Bài viết của bạn' : 'Bài viết của ${post.user.fullName}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.5,
            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
          ),
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
                  likesCount: isLiked ? post.likesCount + 1 : post.likesCount - 1,
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
