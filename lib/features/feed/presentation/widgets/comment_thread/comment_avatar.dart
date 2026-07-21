import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';

/// Bọc AppAvatar với xử lý navigate đến profile.
///
/// Tại sao tách ra?
/// - CommentContent không cần biết cách navigate.
/// - Nếu sau này thêm story ring, online badge, chỉ sửa ở đây.
///
/// Lưu ý: Luôn dùng AppAvatarSize.small (24px) trong ngữ cảnh comment thread.
/// Nếu cần size khác ở tương lai, mở rộng thêm enum param.
class CommentAvatar extends StatelessWidget {
  final String userId;
  final String imageUrl;

  const CommentAvatar({
    super.key,
    required this.userId,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AppAvatar(
      imageUrl: imageUrl,
      size: AppAvatarSize.small,
      onTap: () => context.push('/user/profile/$userId'),
    );
  }
}
