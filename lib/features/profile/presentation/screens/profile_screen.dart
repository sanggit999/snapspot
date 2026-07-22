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

/// Màn hình Trang cá nhân (Profile Screen) chuẩn Type Scale & Multi-Language UI/UX.
class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTabIndex = 0; // 0: Bài viết, 1: Đã lưu (Tôi) / Điểm check-in (User khác)
  String _selectedCollectionName = 'ALL'; // Mặc định 'ALL' để dùng l10n context.tr('all')

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

    // 1. Danh sách bài viết của người dùng hiện tại
    final userPosts = MockData.mockPosts
        .where((p) => p.user.id == user.id)
        .toList();

    // 2. Danh sách tất cả bài viết đã Bookmark (Dành cho Tôi)
    final bookmarkedPosts = MockData.mockPosts
        .where((p) => p.isBookmarked)
        .toList();

    // 3. Lọc danh sách bài viết đã lưu theo Thư mục được chọn
    final filteredBookmarkedPosts = (_selectedCollectionName == 'ALL' || _selectedCollectionName == 'Tất cả')
        ? bookmarkedPosts
        : bookmarkedPosts
            .where((p) => p.savedCollectionName == _selectedCollectionName)
            .toList();

    // 4. Danh sách các địa điểm Check-in (Dành cho User khác)
    final checkInPosts = userPosts
        .where((p) => p.latitude != 0)
        .toList();

    final secondaryList = isMe ? filteredBookmarkedPosts : checkInPosts;
    final currentPosts = _selectedTabIndex == 0 ? userPosts : secondaryList;

    // Xác định câu thông báo trống đa ngôn ngữ
    String getEmptyMessage() {
      if (_selectedTabIndex == 0) {
        return isMe
            ? context.tr('no_posts_me')
            : context.tr('no_posts_user', args: {'username': user.username});
      } else {
        if (isMe) {
          if (_selectedCollectionName == 'ALL' || _selectedCollectionName == 'Tất cả') {
            return context.tr('no_saved_posts');
          } else {
            return context.tr('no_saved_in_collection', args: {'name': _selectedCollectionName});
          }
        } else {
          return context.tr('no_checkin_user', args: {'username': user.username});
        }
      }
    }

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
              leading: !isMe && Navigator.canPop(context)
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isLight
                            ? AppColors.textLightPrimary
                            : AppColors.textDarkPrimary,
                      ),
                      onPressed: () => context.pop(),
                    )
                  : null,
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
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('@${user.username}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
              ],
            ),

            // 2. Section Header: Cover, Avatar, FullName, Bio, Nút Hành Động
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

            // 4. Section TabBar Chuyển đổi giữa [Bài viết] và [Đã lưu (Tôi) / Điểm check-in (User khác)]
            SliverPersistentHeader(
              pinned: true,
              delegate: ProfileTabHeaderDelegate(
                selectedIndex: _selectedTabIndex,
                secondaryCount: isMe ? bookmarkedPosts.length : checkInPosts.length,
                isMe: isMe,
                onTabSelected: (index) {
                  setState(() => _selectedTabIndex = index);
                },
                isLight: isLight,
              ),
            ),

            // 5. Section Thư mục Bộ sưu tập (Chỉ hiển thị khi là TÔI và ở Tab Đã lưu)
            if (isMe && _selectedTabIndex == 1)
              SliverToBoxAdapter(
                child: ProfileCollectionsTray(
                  bookmarkedPosts: bookmarkedPosts,
                  selectedCollection: _selectedCollectionName,
                  onCollectionSelected: (colName) {
                    setState(() {
                      _selectedCollectionName = colName ?? 'ALL';
                    });
                  },
                  isLight: isLight,
                ),
              ),

            // 6. Section Lưới hiển thị bài đăng
            ProfileGridSliver(
              posts: currentPosts,
              isLight: isLight,
              emptyMessage: getEmptyMessage(),
              emptyIcon: _selectedTabIndex == 0
                  ? Icons.photo_library_outlined
                  : (isMe ? Icons.bookmark_border_rounded : Icons.location_off_outlined),
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
