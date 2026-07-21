import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_header_section.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_stats_section.dart';

/// Màn hình Trang cá nhân (Profile Screen).
/// Tối ưu hóa hiệu năng cuộn theo chuẩn flutter-layout-rules sử dụng CustomScrollView và Slivers.
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
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // Lọc tất cả bài đăng của người dùng từ MockData
    final userPosts = MockData.mockPosts
        .where((p) => p.user.id == user.id)
        .toList();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. SliverAppBar thu nhỏ tự động khi cuộn
            SliverAppBar(
              pinned: true,
              expandedHeight: 56.0,
              elevation: 0,
              backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
              title: Text(
                '@${user.username}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: isLight
                      ? AppColors.textLightPrimary
                      : AppColors.textDarkPrimary,
                ),
              ),
              actions: [
                if (isMe)
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => context.push('/settings'),
                  ),
              ],
            ),

            // 2. Section Header: Cover, Avatar, FullName, Bio
            SliverToBoxAdapter(
              child: ProfileHeaderSection(user: user, isMe: isMe),
            ),

            // 3. Section Thống kê: Số bài viết, Người theo dõi, Đang theo dõi
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                child: ProfileStatsSection(
                  postsCount: userPosts.length,
                  followersCount: user.followersCount,
                  followingCount: user.followingCount,
                  postsLabel: context.tr('posts_count'),
                  followersLabel: context.tr('followers_count'),
                  followingLabel: context.tr('following_count'),
                ),
              ),
            ),

            // 4. Tiêu đề danh sách Bài viết
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.grid_on_rounded,
                        size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      context.tr('posts_count'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${userPosts.length} bài đăng',
                      style: TextStyle(
                        fontSize: 12,
                        color: isLight
                            ? AppColors.textLightSecondary
                            : AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. SliverGrid: Hiển thị Lưới bài viết với Lazy Loading chuẩn 2026
            if (userPosts.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Text(
                      'Chưa có bài đăng nào',
                      style: TextStyle(
                        color: isLight
                            ? AppColors.textLightSecondary
                            : AppColors.textDarkSecondary,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(4.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = userPosts[index];
                      final imageUrl = post.imageUrls.isNotEmpty
                          ? post.imageUrls.first
                          : '';

                      return GestureDetector(
                        onTap: () => context.push('/post/${post.id}'),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.image, color: Colors.white),
                                ),
                              ),
                              if (post.imageUrls.length > 1)
                                const Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Icon(
                                    Icons.collections_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: userPosts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                ),
              ),

            // Khoảng trống đệm dưới cùng
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}
