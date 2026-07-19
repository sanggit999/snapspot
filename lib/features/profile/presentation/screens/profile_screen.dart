import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/localization/language_cubit.dart';
import 'package:snapspot/core/theme/theme_cubit.dart';
import 'package:snapspot/core/widgets/app_avatar.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:snapspot/core/network/mock_data.dart';

/// Màn hình Trang cá nhân (Profile Screen).
/// Hiển thị thông số (Followers, Following, Posts), lưới ảnh bài viết và phần Cài đặt nhanh (Theme, Ngôn ngữ).
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

  void _showSettingsBottomSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, currentThemeMode) {
            return BlocBuilder<LanguageCubit, Locale>(
              builder: (context, currentLocale) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.tr('settings'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Cài đặt Ngôn ngữ
                      Text(
                        context.tr('language'),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Tiếng Việt 🇻🇳'),
                              selected: currentLocale.languageCode == 'vi',
                              onSelected: (val) {
                                if (val) {
                                  context.read<LanguageCubit>().setLanguage('vi');
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('English 🇬🇧'),
                              selected: currentLocale.languageCode == 'en',
                              onSelected: (val) {
                                if (val) {
                                  context.read<LanguageCubit>().setLanguage('en');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Cài đặt Giao diện
                      Text(
                        context.tr('theme_mode'),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: Text(context.tr('light_theme')),
                              selected: currentThemeMode == AppThemeMode.light,
                              onSelected: (val) {
                                if (val) {
                                  context.read<ThemeCubit>().setThemeMode(AppThemeMode.light);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ChoiceChip(
                              label: Text(context.tr('dark_theme')),
                              selected: currentThemeMode == AppThemeMode.dark,
                              onSelected: (val) {
                                if (val) {
                                  context.read<ThemeCubit>().setThemeMode(AppThemeMode.dark);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ChoiceChip(
                              label: Text(context.tr('system_theme')),
                              selected: currentThemeMode == AppThemeMode.system,
                              onSelected: (val) {
                                if (val) {
                                  context.read<ThemeCubit>().setThemeMode(AppThemeMode.system);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Nút Đăng xuất
                      if (userId == 'me')
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showLogoutDialog(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.logout),
                          label: Text(context.tr('logout')),
                        ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.tr('logout')),
          content: Text(context.tr('logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.tr('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthCubit>().logout().then((_) {
                  // Chuyển hướng sang trang đăng nhập
                  if (context.mounted) {
                    context.go('/login');
                  }
                });
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(context.tr('logout')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = _getDisplayedUser(context);
    final isMe = userId == 'me' || user.id == 'usr_1'; // Nguyễn Văn Sang là me

    // Lọc tất cả bài đăng của người dùng này
    final userPosts = MockData.mockPosts
        .where((p) => p.user.id == user.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('@${user.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsBottomSheet(context, theme),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Profile (Cover mờ mờ + Avatar + Tên + Bio)
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Cover background gradient
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Avatar đè lên
                Positioned(
                  top: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 4,
                      ),
                    ),
                    child: AppAvatar(
                      imageUrl: user.avatarUrl,
                      size: AppAvatarSize.large,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Tên và Trạng thái loại tài khoản
            Center(
              child: Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  user.isPrivate ? Icons.lock_outline : Icons.public_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  user.isPrivate ? context.tr('private') : context.tr('public'),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),

            // Bio
            if (user.bio.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                child: Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, height: 1.3),
                ),
              ),

            // Nút nhắn tin hoặc chỉnh sửa
            if (!isMe)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 8,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Mở phòng chat
                    context.push('/chat/room_1');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Nhắn tin'),
                ),
              ),

            const SizedBox(height: 16),

            // 2. Hộp Stats (Posts, Followers, Following)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? Colors.white
                      : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      userPosts.length.toString(),
                      context.tr('posts_count'),
                    ),
                    _buildStatItem(
                      user.followersCount.toString(),
                      context.tr('followers_count'),
                    ),
                    _buildStatItem(
                      user.followingCount.toString(),
                      context.tr('following_count'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Grid ảnh bài viết
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.grid_on_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('posts_count').toUpperCase(),
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
