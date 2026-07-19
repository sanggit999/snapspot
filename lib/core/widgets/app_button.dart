import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Các kiểu biến thể của nút bấm.
enum AppButtonVariant { primary, secondary, outline, text }

/// Nút bấm dùng chung trên toàn ứng dụng.
/// Hỗ trợ hiển thị trạng thái đang tải (Loading) để tránh việc người dùng bấm nhiều lần.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    // Định cấu hình màu nền & màu chữ dựa trên biến thể nút
    Color? backgroundColor;
    Color? foregroundColor;
    BorderSide? borderSide;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = theme.colorScheme.primary;
        foregroundColor = theme.colorScheme.onPrimary;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = theme.colorScheme.secondary;
        foregroundColor = theme.colorScheme.onPrimary;
        break;
      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        borderSide = BorderSide(color: theme.colorScheme.primary, width: 1.5);
        break;
      case AppButtonVariant.text:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        break;
    }

    if (isDisabled) {
      if (variant == AppButtonVariant.primary ||
          variant == AppButtonVariant.secondary) {
        backgroundColor = theme.brightness == Brightness.light
            ? AppColors.borderLight
            : AppColors.borderDark;
        foregroundColor = theme.brightness == Brightness.light
            ? AppColors.textLightSecondary
            : AppColors.textDarkSecondary;
      } else {
        foregroundColor = theme.brightness == Brightness.light
            ? AppColors.textLightSecondary
            : AppColors.textDarkSecondary;
        if (borderSide != null) {
          borderSide = BorderSide(
            color: theme.brightness == Brightness.light
                ? AppColors.borderLight
                : AppColors.borderDark,
            width: 1.5,
          );
        }
      }
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: borderSide ?? BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor,
                  ),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
