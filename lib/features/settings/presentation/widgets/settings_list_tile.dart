import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Item ListTile danh mục cài đặt chuẩn Type Scale UI/UX Light & Dark Mode.
class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        size: 22,
        color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
      ),
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tính năng "$title" sẽ sớm được phát triển.'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
