import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Purpose: Reusable Confirmation Dialog across SnapSpot.
///
/// Parameters:
/// - [title]: Dialog header title.
/// - [content]: Explanation text or custom widget.
/// - [confirmText]: Text for positive action button.
/// - [cancelText]: Text for negative action button.
/// - [onConfirm]: Callback when confirm button is pressed.
/// - [isDangerous]: Colors confirm button in red if true.
///
/// Usage:
/// ```dart
/// AppDialog.show(
///   context,
///   title: 'Confirm Logout',
///   content: 'Are you sure you want to log out?',
///   onConfirm: () => _logout(),
/// );
/// ```
class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDangerous;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText = 'Xác nhận',
    this.cancelText = 'Hủy',
    this.isDangerous = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (ctx) => AppDialog(
        title: title,
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () {
          Navigator.of(ctx).pop(true);
          onConfirm();
        },
        isDangerous: isDangerous,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return AlertDialog(
      backgroundColor: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            style: TextStyle(
              color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous ? AppColors.error : AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
