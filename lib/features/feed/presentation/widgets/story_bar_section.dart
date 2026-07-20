import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';

/// Purpose: Horizontal Story Tray displaying user stories with animated Gradient Story Rings.
///
/// Usage:
/// ```dart
/// const StoryBarSection();
/// ```
class StoryBarSection extends StatelessWidget {
  const StoryBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final users = MockData.mockUsers;

    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: isLight ? Colors.white : AppColors.surfaceDark,
        border: Border(
          bottom: BorderSide(
            color: isLight
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: users.length + 1, // +1 cho "Tin của bạn"
        itemBuilder: (context, index) {
          if (index == 0) {
            // Nút "Tạo tin" của chính mình
            final me = users[0];
            return Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: () => context.push('/camera'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        AppAvatar(
                          imageUrl: me.avatarUrl,
                          size: AppAvatarSize.medium,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isLight ? Colors.white : AppColors.surfaceDark,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tin của bạn',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isLight
                            ? AppColors.textLightSecondary
                            : AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final user = users[index - 1];
          final bool isRead = index % 2 == 0;

          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => context.push('/user/profile/${user.id}'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isRead
                          ? null
                          : const LinearGradient(
                              colors: [
                                Color(0xFF833AB4),
                                Color(0xFFFD1D1D),
                                Color(0xFFF77737),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                      color: isRead
                          ? (isLight
                              ? AppColors.borderLight
                              : AppColors.borderDark)
                          : null,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white : AppColors.surfaceDark,
                        shape: BoxShape.circle,
                      ),
                      child: AppAvatar(
                        imageUrl: user.avatarUrl,
                        size: AppAvatarSize.medium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 62,
                    child: Text(
                      user.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.w600,
                        color: isLight
                            ? AppColors.textLightPrimary
                            : AppColors.textDarkPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
