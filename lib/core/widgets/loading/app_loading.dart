import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Purpose: Reusable Loading Indicator and Shimmer Skeleton Component across SnapSpot.
///
/// Parameters:
/// - [size]: Circle loading size. Defaults to 24.0.
/// - [color]: Progress indicator color.
///
/// Usage:
/// ```dart
/// const AppLoading();
/// ```
class AppLoading extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoading({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
