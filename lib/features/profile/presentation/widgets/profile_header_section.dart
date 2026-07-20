import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

class ProfileHeaderSection extends StatelessWidget {
  final UserEntity user;
  final bool isMe;

  const ProfileHeaderSection({
    super.key,
    required this.user,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Text(
              user.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, height: 1.3),
            ),
          ),

        // Nút nhắn tin hoặc chỉnh sửa
        if (!isMe)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
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
      ],
    );
  }
}
