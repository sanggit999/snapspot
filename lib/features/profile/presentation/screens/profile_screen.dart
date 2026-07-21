import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_collections_tray.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_grid_sliver.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_header_section.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_stats_section.dart';
import 'package:snapspot/features/profile/presentation/widgets/profile_tab_bar.dart';

/// Màn hình Trang cá nhân (Profile Screen).
/// Mã nguồn tối giản, mô-đun hóa cao theo chuẩn Clean Architecture & Reusable Widget Rules.
class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTabIndex = 0; // 0: Bài viết của tôi, 1: Đã lưu (Bookmarked)

  UserEntity _getDisplayedUser(BuildContext context) {
    if (widget.userId == 'me' || widget.userId.isEmpty) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthSuccess) {
        return authState.currentUser;
      }
      return MockData.mockUsers[0];
    }

    return MockData.mockUsers.firstWhere(
      (u) => u.id == widget.userId,
      orElse: () {
        final authState = context.read<AuthCubit>().state;
        if (authState is AuthSuccess) {
          return authState.currentUser;
        }
        return MockData.mockUsers[0];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _getDisplayedUser(context);
    final isMe = widget.userId == 'me' || user.id == 'usr_1';
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // 1. Danh sách bài viết của người dùng
    final userPosts = MockData.mockPosts
        .where((p) => p.user.id == user.id)
        .toList();

    // 2. Danh sách bài viết đã Bookmark
    final bookmarkedPosts = MockData.mockPosts
        .where((p) => p.isBookmarked)
        .toList();

    final currentPosts = _selectedTabIndex == 0 ? userPosts : bookmarkedPosts;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. AppBar thu nhỏ tự động khi cuộn
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
                padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
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

            // 4. Section TabBar Chuyển đổi giữa Bài viết và Đã lưu
            SliverPersistentHeader(
              pinned: true,
              delegate: ProfileTabHeaderDelegate(
                selectedIndex: _selectedTabIndex,
                bookmarkedCount: bookmarkedPosts.length,
                onTabSelected: (index) {
                  setState(() => _selectedTabIndex = index);
                },
                isLight: isLight,
              ),
            ),

            // 5. Section Thư mục Bộ sưu tập (Chỉ hiển thị tại Tab Đã lưu)
            if (_selectedTabIndex == 1)
              SliverToBoxAdapter(
                child: ProfileCollectionsTray(
                  bookmarkedPosts: bookmarkedPosts,
                  isLight: isLight,
                ),
              ),

            // 6. Section Lưới hiển thị bài đăng
            ProfileGridSliver(
              posts: currentPosts,
              isLight: isLight,
              emptyMessage: _selectedTabIndex == 0
                  ? 'Chưa có bài đăng nào'
                  : 'Chưa có bài viết nào được lưu',
              emptyIcon: _selectedTabIndex == 0
                  ? Icons.photo_library_outlined
                  : Icons.bookmark_border_rounded,
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}
