import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Section Header hiển thị Ảnh bìa, Avatar, Tên, Bio và Nút Hành Động Chuẩn 2026.
/// Phân biệt rõ ràng giữa Trang cá nhân CỦA TÔI và Trang cá nhân CỦA USER KHÁC.
class ProfileHeaderSection extends StatefulWidget {
  final UserEntity user;
  final bool isMe;

  const ProfileHeaderSection({
    super.key,
    required this.user,
    required this.isMe,
  });

  @override
  State<ProfileHeaderSection> createState() => _ProfileHeaderSectionState();
}

class _ProfileHeaderSectionState extends State<ProfileHeaderSection> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

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
                  imageUrl: widget.user.avatarUrl,
                  size: AppAvatarSize.large,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),

        // Tên và Trạng thái loại tài khoản
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.user.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.verified,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.user.isPrivate ? Icons.lock_outline : Icons.public_outlined,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              widget.user.isPrivate ? context.tr('private') : context.tr('public'),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),

        // Bio
        if (widget.user.bio.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            child: Text(
              widget.user.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, height: 1.35),
            ),
          ),

        const SizedBox(height: 12),

        // Hàng Nút Hành Động Chuẩn Instagram / TikTok (2 Nút song song)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              if (widget.isMe) ...[
                // Nút 1: Chỉnh sửa trang cá nhân
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/edit-profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                      side: BorderSide(
                        color: isLight ? Colors.grey[300]! : Colors.grey[700]!,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text(
                      'Chỉnh sửa',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Nút 2: Chia sẻ trang cá nhân
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(
                        ClipboardData(text: 'https://snapspot.app/u/${widget.user.username}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã sao chép liên kết trang cá nhân @${widget.user.username}!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                      side: BorderSide(
                        color: isLight ? Colors.grey[300]! : Colors.grey[700]!,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.share_outlined, size: 17),
                    label: const Text(
                      'Chia sẻ trang',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ] else ...[
                // Nút 1: Theo dõi / Đang theo dõi
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _isFollowing = !_isFollowing;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFollowing
                                ? 'Đã theo dõi @${widget.user.username}'
                                : 'Đã bỏ theo dõi @${widget.user.username}',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFollowing
                          ? (isLight ? Colors.grey[200] : Colors.grey[800])
                          : AppColors.primary,
                      foregroundColor: _isFollowing
                          ? (isLight ? Colors.black87 : Colors.white)
                          : Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(
                      _isFollowing ? Icons.check : Icons.person_add_alt_1_rounded,
                      size: 17,
                    ),
                    label: Text(
                      _isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Nút 2: Nhắn tin Direct Chat
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.push('/chat/room_1');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                      side: BorderSide(
                        color: isLight ? Colors.grey[300]! : Colors.grey[700]!,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 17),
                    label: const Text(
                      'Nhắn tin',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
