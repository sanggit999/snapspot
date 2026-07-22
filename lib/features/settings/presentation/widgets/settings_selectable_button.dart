import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Nút bấm chọn lựa chọn tùy chỉnh (Ngôn ngữ, Giao diện) chuẩn Type Scale UI/UX.
class SettingsSelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SettingsSelectableButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isLight ? Colors.grey[100] : AppColors.surfaceDark),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isLight ? AppColors.borderLight : AppColors.borderDark),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }
}
