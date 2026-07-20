import 'package:flutter/material.dart';

/// Purpose: Reusable Icon Button component across SnapSpot.
///
/// Parameters:
/// - [icon]: IconData to display.
/// - [onPressed]: Callback function when tapped.
/// - [tooltip]: Text hint for accessibility.
/// - [color]: Custom icon color.
/// - [size]: Size of the icon. Defaults to 24.0.
/// - [backgroundColor]: Optional background color for circular/rounded container.
///
/// Usage:
/// ```dart
/// AppIconButton(
///   icon: Icons.settings_outlined,
///   onPressed: () => context.push('/settings'),
/// )
/// ```
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size = 24.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(
      icon,
      size: size,
      color: color ?? Theme.of(context).iconTheme.color,
    );

    if (backgroundColor != null) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: iconWidget,
          onPressed: onPressed,
          tooltip: tooltip,
        ),
      );
    }

    return IconButton(
      icon: iconWidget,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
