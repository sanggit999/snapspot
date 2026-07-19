import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_comment_input.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_comment_section.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_detail_content.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_header.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_image_carousel.dart';

/// Màn hình Chi tiết bài viết.
/// Áp dụng mẫu Widget Composition Pattern chia nhỏ cây giao diện thành các phần riêng biệt.
class PostDetailScreen extends StatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onSendCommentPressed(PostEntity post) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<FeedCubit>().addComment(
            post.id,
            text,
            authState.currentUser,
          );
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('post_detail')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is FeedLoaded) {
            final matchingPosts =
                state.posts.where((p) => p.id == widget.postId).toList();

            if (matchingPosts.isEmpty) {
              return Center(child: Text(context.tr('no_posts_found')));
            }

            final post = matchingPosts.first;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Slider hình ảnh
                        PostImageCarousel(imageUrls: post.imageUrls),

                        // 2. Thông tin tác giả & Thích
                        PostHeader(post: post),
                        const Divider(height: 1),

                        // 3. Toạ độ & Caption
                        PostDetailContent(post: post),
                        const Divider(height: 1),

                        // 4. Danh sách bình luận
                        PostCommentSection(comments: post.comments),
                      ],
                    ),
                  ),
                ),
                // 5. Khung nhập bình luận ở đáy màn hình
                PostCommentInput(
                  controller: _commentController,
                  onSendPressed: () => _onSendCommentPressed(post),
                ),
              ],
            );
          }

          return Center(child: Text(context.tr('no_posts_found')));
        },
      ),
    );
  }
}
