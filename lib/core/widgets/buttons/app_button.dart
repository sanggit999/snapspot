import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Các kiểu biến thể của nút bấm [AppButton].
enum AppButtonVariant { primary, secondary, outline, text }

/// Purpose: Reusable primary/secondary/outline button component across SnapSpot.
///
/// Parameters:
/// - [label]: The text title displayed on the button.
/// - [onPressed]: Callback function when the button is clicked. If null or [isLoading] is true, the button is disabled.
/// - [isLoading]: Displays a circular progress indicator instead of label if true.
/// - [variant]: Visual style variant ([AppButtonVariant.primary], secondary, outline, text).
/// - [icon]: Optional leading icon.
/// - [width]: Optional button width. Defaults to full width ([double.infinity]).
/// - [height]: Height of the button. Defaults to 48.0.
/// - [borderRadius]: Corner radius. Defaults to 12.0.
///
/// Usage:
/// ```dart
/// AppButton(
///   label: 'Submit',
///   onPressed: () => _handleSubmit(),
///   isLoading: state.isSubmitting,
/// )
/// ```
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.width,
    this.height = 48.0,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

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
      final isLight = theme.brightness == Brightness.light;
      if (variant == AppButtonVariant.primary ||
          variant == AppButtonVariant.secondary) {
        backgroundColor = isLight ? AppColors.borderLight : AppColors.borderDark;
        foregroundColor = isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary;
      } else {
        foregroundColor = isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary;
        if (borderSide != null) {
          borderSide = BorderSide(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
