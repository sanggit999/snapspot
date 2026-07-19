import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

class ProfilePostsGrid extends StatelessWidget {
  final List<PostEntity> userPosts;
  final String label;

  const ProfilePostsGrid({
    super.key,
    required this.userPosts,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.grid_on_rounded, size: 20),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (userPosts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                'Chưa có bài đăng nào.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              final post = userPosts[index];
              return GestureDetector(
                onTap: () {
                  context.push('/post/${post.id}');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrls[0],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
