import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_header_section.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_posts_grid.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_stats_section.dart';

/// Màn hình Trang cá nhân (Profile Screen).
/// Áp dụng mẫu thiết kế Widget Composition Pattern ghép nối từ các widget nhỏ chuyên biệt.
class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  UserEntity _getDisplayedUser(BuildContext context) {
    if (userId == 'me') {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthSuccess) {
        return authState.currentUser;
      }
      return MockData.mockUsers[0];
    }

    return MockData.mockUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => MockData.mockUsers[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _getDisplayedUser(context);
    final isMe = userId == 'me' || user.id == 'usr_1';

    // Lọc tất cả bài đăng của người dùng này từ MockData
    final userPosts = MockData.mockPosts
        .where((p) => p.user.id == user.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('@${user.username}'),
        actions: [
          if (isMe)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header: Cover, Avatar, FullName, Bio
            ProfileHeaderSection(user: user, isMe: isMe),
            const SizedBox(height: 16),

            // 2. Stats đếm: Bài viết, Follower, Following
            ProfileStatsSection(
              postsCount: userPosts.length,
              followersCount: user.followersCount,
              followingCount: user.followingCount,
              postsLabel: context.tr('posts_count'),
              followersLabel: context.tr('followers_count'),
              followingLabel: context.tr('following_count'),
            ),
            const SizedBox(height: 24),

            // 3. Lưới danh sách bài viết
            ProfilePostsGrid(
              userPosts: userPosts,
              label: context.tr('posts_count'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
