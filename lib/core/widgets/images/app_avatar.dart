import 'dart:io' as java_io;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Các kích cỡ chuẩn của Avatar [AppAvatar].
enum AppAvatarSize {
  small(24.0),
  medium(40.0),
  large(80.0);

  final double dimension;
  const AppAvatarSize(this.dimension);
}

/// Purpose: Reusable Avatar component supporting Network URLs, local Files and fallback placeholders.
///
/// Parameters:
/// - [imageUrl]: Image URL string or local file path.
/// - [size]: Avatar size enum ([AppAvatarSize.small], medium, large).
/// - [hasStory]: Adds an outer ring if true.
/// - [isStoryRead]: Mutes outer ring color if true.
/// - [onTap]: Callback when avatar is clicked.
///
/// Usage:
/// ```dart
/// AppAvatar(
///   imageUrl: user.avatarUrl,
///   size: AppAvatarSize.medium,
///   onTap: () => _viewProfile(),
/// )
/// ```
class AppAvatar extends StatelessWidget {
  final String imageUrl;
  final AppAvatarSize size;
  final bool hasStory;
  final bool isStoryRead;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    required this.imageUrl,
    this.size = AppAvatarSize.medium,
    this.hasStory = false,
    this.isStoryRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double dimension = size.dimension;
    final theme = Theme.of(context);

    Widget avatarWidget = Container(
      width: dimension,
      height: dimension,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? (imageUrl.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: theme.brightness == Brightness.light
                          ? AppColors.borderLight
                          : AppColors.borderDark,
                      child: const Center(
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => _buildPlaceholder(theme),
                  )
                : Image.file(
                    java_io.File(imageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(theme),
                  ))
            : _buildPlaceholder(theme),
      ),
    );

    if (hasStory) {
      final Color borderColor = isStoryRead
          ? (theme.brightness == Brightness.light
                ? AppColors.borderLight
                : AppColors.borderDark)
          : AppColors.primary;

      final double paddingVal = size == AppAvatarSize.large ? 4.0 : 2.5;
      final double borderVal = size == AppAvatarSize.large ? 2.5 : 1.5;

      avatarWidget = Container(
        padding: EdgeInsets.all(paddingVal),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: borderVal),
        ),
        child: avatarWidget,
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatarWidget);
    }

    return avatarWidget;
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.brightness == Brightness.light
          ? AppColors.borderLight
          : AppColors.borderDark,
      child: Icon(
        Icons.person_outline,
        size: size.dimension * 0.6,
        color: theme.brightness == Brightness.light
            ? AppColors.textLightSecondary
            : AppColors.textDarkSecondary,
      ),
    );
  }
}
