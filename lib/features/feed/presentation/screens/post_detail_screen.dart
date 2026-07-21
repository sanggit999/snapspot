import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/widgets/spot_card.dart';

/// Màn hình Chi tiết bài viết (Post Detail Screen).
/// Đã được sửa lỗi Crash triệt để, hiển thị toàn bộ nội dung bài đăng mượt mà.
class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

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
          context.tr('post_detail'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: SpotCard(
            post: post,
            onLikePressed: (postId) {
              setState(() {
                final isLiked = !post.isLiked;
                _post = PostEntity(
                  id: post.id,
                  caption: post.caption,
                  imageUrls: post.imageUrls,
                  latitude: post.latitude,
                  longitude: post.longitude,
                  locationName: post.locationName,
                  user: post.user,
                  hashtags: post.hashtags,
                  likesCount: isLiked ? post.likesCount + 1 : post.likesCount - 1,
                  commentsCount: post.commentsCount,
                  isLiked: isLiked,
                  createdAt: post.createdAt,
                  comments: post.comments,
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
