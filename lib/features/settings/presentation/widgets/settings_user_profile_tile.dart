import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Tile thông tin tài khoản người dùng tóm tắt trong màn hình Cài đặt chuẩn Type Scale UI/UX.
class SettingsUserProfileTile extends StatelessWidget {
  final UserEntity user;
  const SettingsUserProfileTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? Colors.grey[50] : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLight ? AppColors.borderLight : AppColors.borderDark,
        ),
      ),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: user.avatarUrl,
            size: AppAvatarSize.medium,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
