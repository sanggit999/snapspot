import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Purpose: Reusable Card container component across SnapSpot.
///
/// Parameters:
/// - [child]: The content widget inside the card.
/// - [padding]: Padding surrounding the content. Defaults to 16.0.
/// - [margin]: Margin surrounding the card.
/// - [borderRadius]: Corner radius. Defaults to 16.0.
/// - [elevation]: Shadow elevation depth.
/// - [onTap]: Optional click callback.
/// - [color]: Custom background color override.
///
/// Usage:
/// ```dart
/// AppCard(
///   child: Text('Card Content'),
///   onTap: () => _handleCardClick(),
/// )
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double? elevation;
  final VoidCallback? onTap;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius = 16.0,
    this.elevation,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    Widget cardWidget = Card(
      elevation: elevation ?? (isLight ? 2.0 : 0.0),
      color: color ?? (isLight ? AppColors.surfaceLight : AppColors.surfaceDark),
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: isLight
            ? BorderSide.none
            : BorderSide(color: Colors.grey[850]!, width: 1.0),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
