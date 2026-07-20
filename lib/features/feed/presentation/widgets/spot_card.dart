import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/utils/geo_utils.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Thẻ hiển thị thông tin bài đăng check-in địa điểm.
/// Hỗ trợ Carousel ảnh, Double-tap to Like với hiệu ứng động, hiển thị khoảng cách động.
class SpotCard extends StatefulWidget {
  final PostEntity post;
  final double? userLat;
  final double? userLng;
  final void Function(String)? onLikePressed;

  const SpotCard({
    super.key,
    required this.post,
    this.userLat,
    this.userLng,
    this.onLikePressed,
  });

  @override
  State<SpotCard> createState() => _SpotCardState();
}

class _SpotCardState extends State<SpotCard>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  bool _showHeartAnimation = false;
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_heartController);
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (!widget.post.isLiked) {
      widget.onLikePressed?.call(widget.post.id);
    }
    setState(() {
      _showHeartAnimation = true;
    });
    _heartController.forward(from: 0.0).then((_) {
      setState(() {
        _showHeartAnimation = false;
      });
    });
  }

  String _getDistanceString(BuildContext context) {
    if (widget.userLat == null || widget.userLng == null) return '';
    final distance = GeoUtils.calculateDistance(
      widget.userLat!,
      widget.userLng!,
      widget.post.latitude,
      widget.post.longitude,
    );
    return context.tr(
      'distance_away',
      args: {'distance': distance.toStringAsFixed(1)},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final distanceStr = _getDistanceString(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header: Avatar + Tên + Nút Follow/Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                AppAvatar(
                  imageUrl: widget.post.user.avatarUrl,
                  size: AppAvatarSize.medium,
                  onTap: () => context.push('/user/profile/${widget.post.user.id}'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.push('/user/profile/${widget.post.user.id}'),
                        child: Text(
                          widget.post.user.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        '@${widget.post.user.username}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // 2. Body: Image Carousel hỗ trợ Double-tap to Like
          GestureDetector(
            onDoubleTap: _handleDoubleTap,
            onTap: () => context.push('/post/${widget.post.id}'),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.1, // Tỷ lệ vuông nhẹ cho ảnh sang xịn
                  child: PageView.builder(
                    itemCount: widget.post.imageUrls.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, idx) {
                      return CachedNetworkImage(
                        imageUrl: widget.post.imageUrls[idx],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.brightness == Brightness.light
                              ? AppColors.borderLight.withValues(alpha: 0.5)
                              : AppColors.borderDark.withValues(alpha: 0.5),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Indicator dots cho nhiều ảnh
                if (widget.post.imageUrls.length > 1)
                  Positioned(
                    bottom: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.post.imageUrls.length, (
                        index,
                      ) {
                        final isActive = _currentImageIndex == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: isActive ? 12 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        );
                      }),
                    ),
                  ),

                // Hiệu ứng Trái tim khi Double-tap
                if (_showHeartAnimation)
                  AnimatedBuilder(
                    animation: _heartScale,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartScale.value,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 15,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // 3. Location Bar (Glassmorphic look or clean info)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.post.locationName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (distanceStr.isNotEmpty)
                  Text(
                    distanceStr,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),

          // 4. Caption & Hashtags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.brightness == Brightness.light
                      ? Colors.black87
                      : Colors.white70,
                ),
                children: [
                  TextSpan(
                    text: '${widget.post.user.username} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: widget.post.caption),
                ],
              ),
            ),
          ),

          // 5. Interactivity Actions (Like, Comment, Share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Nút Like
                IconButton(
                  icon: Icon(
                    widget.post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.post.isLiked ? Colors.red : null,
                    size: 24,
                  ),
                  onPressed: () => widget.onLikePressed?.call(widget.post.id),
                ),
                Text(
                  '${widget.post.likesCount}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),

                // Nút Comment
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined, size: 22),
                  onPressed: () => context.push('/post/${widget.post.id}'),
                ),
                Text(
                  '${widget.post.commentsCount}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),

                // Nút Share
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 22),
                  onPressed: () {
                    // Mở chia sẻ
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link copied to clipboard!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
