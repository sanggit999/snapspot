import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/services/app_share_service.dart';
import 'package:snapspot/core/utils/geo_utils.dart';
import 'package:snapspot/core/utils/number_formatter.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/core/widgets/images/image_gallery_viewer_dialog.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_header.dart';

/// Thẻ hiển thị bài đăng check-in với trải nghiệm tương tác (UX) đột phá 2026.
/// Hỗ trợ Long-Press Quick Emoji Reaction, Double-Tap Haptic Pulse, và Luồng Chia sẻ 3-trong-1 trỏ trực tiếp App Android & iOS.
class SpotCard extends StatefulWidget {
  final PostEntity post;
  final double? userLat;
  final double? userLng;
  final bool isInDetailScreen;
  final void Function(String)? onLikePressed;
  final void Function(String)? onSharePressed;

  const SpotCard({
    super.key,
    required this.post,
    this.userLat,
    this.userLng,
    this.isInDetailScreen = false,
    this.onLikePressed,
    this.onSharePressed,
  });

  @override
  State<SpotCard> createState() => _SpotCardState();
}

class _SpotCardState extends State<SpotCard>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  bool _isBookmarked = false;
  String? _savedCollectionName;
  String? _selectedReactionEmoji;
  late int _localSharesCount;

  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.post.isBookmarked;
    _savedCollectionName = widget.post.savedCollectionName;
    _localSharesCount = widget.post.sharesCount;
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_heartController);
  }

  @override
  void didUpdateWidget(covariant SpotCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.sharesCount != widget.post.sharesCount) {
      _localSharesCount = widget.post.sharesCount;
    }
    if (oldWidget.post.isBookmarked != widget.post.isBookmarked ||
        oldWidget.post.savedCollectionName != widget.post.savedCollectionName) {
      _isBookmarked = widget.post.isBookmarked;
      _savedCollectionName = widget.post.savedCollectionName;
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    HapticFeedback.mediumImpact();
    if (!widget.post.isLiked) {
      widget.onLikePressed?.call(widget.post.id);
    }
    _heartController.forward(from: 0.0);
  }

  void _navigateToDetail({bool focusComment = false}) {
    if (!widget.isInDetailScreen) {
      final uri = focusComment
          ? '/post/${widget.post.id}?focusComment=true'
          : '/post/${widget.post.id}';
      context.push(uri);
    }
  }

  void _openImageGallery() {
    if (widget.isInDetailScreen && widget.post.imageUrls.isNotEmpty) {
      ImageGalleryViewerDialog.show(
        context,
        imageUrls: widget.post.imageUrls,
        initialIndex: _currentImageIndex,
      );
    } else {
      _navigateToDetail();
    }
  }

  void _incrementShareCount() {
    setState(() {
      _localSharesCount++;
    });
    widget.onSharePressed?.call(widget.post.id);
  }

  /// UX Đột phá: Long-Press mở Quick Reaction Bar với 5 Emoji cảm xúc bóng bẩy
  void _openQuickReactionsBar() {
    HapticFeedback.selectionClick();
    final isLight = Theme.of(context).brightness == Brightness.light;
    final emojis = ['❤️', '🔥', '😍', '👏', '📍'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isLight
              ? Colors.white.withValues(alpha: 0.95)
              : AppColors.surfaceDark.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: emojis.map((emoji) {
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedReactionEmoji = emoji;
                  if (!widget.post.isLiked) {
                    widget.onLikePressed?.call(widget.post.id);
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã bày tỏ cảm xúc $emoji'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Transform.scale(
                scale: _selectedReactionEmoji == emoji ? 1.3 : 1.0,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Mở Hộp thoại Chia sẻ Tối ưu Top 3 Ứng dụng Phổ biến (1. Zalo, 2. Messenger, 3. Facebook + 4. Khác...)
  /// Trỏ trực tiếp kích hoạt App trên Android & iOS qua AppShareService
  void _openExternalAppsDialog() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final postUrl = 'https://snapspot.app/p/${widget.post.id}';
    final shareTitle = 'Check-in tại ${widget.post.locationName} - SnapSpot';

    final externalApps = [
      {'key': 'zalo', 'name': 'Zalo', 'icon': Icons.chat_bubble_rounded, 'color': const Color(0xFF0068FF)},
      {'key': 'messenger', 'name': 'Messenger', 'icon': Icons.bolt_rounded, 'color': const Color(0xFF0084FF)},
      {'key': 'facebook', 'name': 'Facebook', 'icon': Icons.facebook_rounded, 'color': const Color(0xFF1877F2)},
      {'key': 'other', 'name': 'Khác...', 'icon': Icons.more_horiz_rounded, 'color': Colors.grey[700]!},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Chia sẻ qua ứng dụng ngoài',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: externalApps.map((app) {
                  final appKey = app['key'] as String;
                  final appColor = app['color'] as Color;
                  final appIcon = app['icon'] as IconData;
                  final appName = app['name'] as String;

                  return GestureDetector(
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      _incrementShareCount();
                      Navigator.pop(ctx);

                      if (appKey == 'zalo') {
                        await AppShareService.shareToZalo(postUrl: postUrl, title: shareTitle);
                      } else if (appKey == 'messenger') {
                        await AppShareService.shareToMessenger(postUrl: postUrl);
                      } else if (appKey == 'facebook') {
                        await AppShareService.shareToFacebook(postUrl: postUrl);
                      } else {
                        await AppShareService.shareToSystem(postUrl: postUrl, title: shareTitle);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: appColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(appIcon, color: appColor, size: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// UX Đột phá 2026: Luồng Chia sẻ 3-trong-1 (Direct Chat + Quick Copy/Story + External Apps)
  void _openShareBottomSheet() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Set<String> sentUserIds = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Chia sẻ bài viết',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${NumberFormatter.formatCompact(_localSharesCount)} lượt chia sẻ',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isLight
                              ? AppColors.textLightSecondary
                              : AppColors.textDarkSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 1. Gửi nhanh tin nhắn Direct Message cho bạn bè (SnapSpot Chat)
                  const Text(
                    'Gửi nhanh cho bạn bè',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 105,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: MockData.mockUsers.length,
                      itemBuilder: (ctx, index) {
                        final u = MockData.mockUsers[index];
                        final isSent = sentUserIds.contains(u.id);

                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              AppAvatar(imageUrl: u.avatarUrl, size: AppAvatarSize.medium),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  u.username,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 26,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSent ? Colors.grey[300] : AppColors.primary,
                                    foregroundColor: isSent ? Colors.black87 : Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    setSheetState(() {
                                      if (isSent) {
                                        sentUserIds.remove(u.id);
                                      } else {
                                        sentUserIds.add(u.id);
                                        _incrementShareCount();
                                      }
                                    });
                                  },
                                  child: Text(
                                    isSent ? 'Đã gửi ✓' : 'Gửi',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(height: 20),

                  // 2. Lưới Các Hành Động Chia Sẻ Nhanh (Copy link, Story, App khác)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.link_rounded, color: AppColors.primary),
                    ),
                    title: const Text('Sao chép liên kết bài viết', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('https://snapspot.app/p/${widget.post.id}', style: const TextStyle(fontSize: 11.5)),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Clipboard.setData(ClipboardData(text: 'https://snapspot.app/p/${widget.post.id}'));
                      _incrementShareCount();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã sao chép liên kết vào bộ nhớ tạm!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.purple),
                    ),
                    title: const Text('Chia sẻ lên Tin của bạn (Story)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Tạo Sticker địa điểm check-in độc đáo', style: TextStyle(fontSize: 11.5)),
                    onTap: () {
                      _incrementShareCount();
                      Navigator.pop(ctx);
                      context.push('/camera');
                    },
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share_outlined, color: Colors.blue),
                    ),
                    title: const Text('Chia sẻ qua Ứng dụng khác', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Zalo, Messenger, Facebook, Khác...', style: TextStyle(fontSize: 11.5)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _openExternalAppsDialog();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openSaveCollectionSheet() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final collections = [
      {'name': 'Địa điểm muốn đến', 'icon': Icons.map_outlined, 'color': AppColors.primary},
      {'name': 'Quán cà phê đẹp', 'icon': Icons.local_cafe_outlined, 'color': Colors.amber.shade700},
      {'name': 'Ảnh chụp đẹp', 'icon': Icons.photo_camera_outlined, 'color': Colors.purple},
      {'name': 'Kinh nghiệm du lịch', 'icon': Icons.explore_outlined, 'color': Colors.teal},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.bookmark_add_rounded, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Lưu vào Bộ sưu tập',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...collections.map((colObj) {
                final colName = colObj['name'] as String;
                final colIcon = colObj['icon'] as IconData;
                final colColor = colObj['color'] as Color;
                final isSelected = _isBookmarked && _savedCollectionName == colName;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  leading: Icon(colIcon, color: isSelected ? AppColors.primary : colColor, size: 24),
                  title: Text(
                    colName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : (isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : const Icon(Icons.add_circle_outline_rounded, color: Colors.grey, size: 20),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isBookmarked = true;
                      _savedCollectionName = colName;
                    });
                    try {
                      context.read<FeedCubit>().toggleBookmark(
                        postId: widget.post.id,
                        collectionName: colName,
                        isBookmarked: true,
                      );
                    } catch (_) {}

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã lưu bài viết vào bộ sưu tập "$colName"'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }),
              if (_isBookmarked) ...[
                const Divider(height: 16),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: const Icon(Icons.bookmark_remove_rounded, color: Colors.redAccent),
                  title: const Text(
                    'Bỏ lưu khỏi Bộ sưu tập',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _isBookmarked = false;
                      _savedCollectionName = null;
                    });
                    try {
                      context.read<FeedCubit>().toggleBookmark(
                        postId: widget.post.id,
                        collectionName: '',
                        isBookmarked: false,
                      );
                    } catch (_) {}

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã bỏ lưu bài viết khỏi bộ sưu tập'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // Tính khoảng cách GPS
    String? distanceText;
    if (widget.userLat != null && widget.userLng != null) {
      final distKm = GeoUtils.calculateDistance(
        widget.userLat!,
        widget.userLng!,
        widget.post.latitude,
        widget.post.longitude,
      );
      distanceText = '${context.tr('distance_from_you')} ${distKm.toStringAsFixed(1)} km';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isLight)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Người đăng (Bấm vào avatar/tên mở Chi tiết)
          GestureDetector(
            onTap: () => _navigateToDetail(),
            child: PostHeader(post: widget.post),
          ),

          // 2. Khung Ảnh Carousel bài viết với Double-Tap to Like & Tap to View Fullscreen / Detail
          GestureDetector(
            onTap: _openImageGallery,
            onDoubleTap: _handleDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: widget.post.imageUrls.isNotEmpty
                      ? PageView.builder(
                          itemCount: widget.post.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: widget.post.imageUrls[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: isLight
                                    ? AppColors.borderLight
                                    : AppColors.borderDark,
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
                              errorWidget: (context, url, error) => Container(
                                color: isLight
                                    ? AppColors.borderLight
                                    : AppColors.borderDark,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_not_supported_outlined, size: 40),
                                    SizedBox(height: 6),
                                    Text('Không thể tải ảnh', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: isLight
                              ? AppColors.borderLight
                              : AppColors.borderDark,
                          child: const Icon(Icons.image, size: 50),
                        ),
                ),

                // Hiệu ứng bùng nổ Tim 3D khi Double-Tap
                AnimatedBuilder(
                  animation: _heartScale,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _heartScale.value,
                      child: Opacity(
                        opacity: _heartScale.value.clamp(0.0, 1.0),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 90,
                          shadows: [
                            Shadow(color: Colors.black38, blurRadius: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Badge đếm trang ảnh (1/2) góc trên bên phải
                if (widget.post.imageUrls.length > 1)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/${widget.post.imageUrls.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                // Dots Indicator ở góc dưới ảnh
                if (widget.post.imageUrls.length > 1)
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.post.imageUrls.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          width: _currentImageIndex == index ? 16 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentImageIndex == index
                                ? AppColors.primary
                                : Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 3. Smart Location Badge với Gradient Pill sang trọng
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => context.go('/explore'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isLight
                              ? [
                                  AppColors.primary.withValues(alpha: 0.1),
                                  const Color(0xFF833AB4).withValues(alpha: 0.08),
                                ]
                              : [
                                  AppColors.primary.withValues(alpha: 0.25),
                                  const Color(0xFF833AB4).withValues(alpha: 0.2),
                                ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 17, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.post.locationName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          if (distanceText != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '• $distanceText',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isLight
                                    ? AppColors.textLightSecondary
                                    : AppColors.textDarkSecondary,
                              ),
                            ),
                          ],
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right_rounded, size: 17, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Action Bar Tương tác Tối ưu: Tim, Bình luận, Chia sẻ (Shares count), Bookmark
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Nút Like / Bày tỏ cảm xúc (Tap = Like, Long-Press = Quick Emoji Bar)
                GestureDetector(
                  onLongPress: _openQuickReactionsBar,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onLikePressed?.call(widget.post.id);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          if (_selectedReactionEmoji != null)
                            Text(
                              _selectedReactionEmoji!,
                              style: const TextStyle(fontSize: 20),
                            )
                          else
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                widget.post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                key: ValueKey<bool>(widget.post.isLiked),
                                color: widget.post.isLiked
                                    ? Colors.redAccent
                                    : (isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary),
                                size: 25,
                              ),
                            ),
                          const SizedBox(width: 5),
                          Text(
                            NumberFormatter.formatCompact(widget.post.likesCount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Nút Comment (Bình luận - Chuyển sang Chi tiết + Focus Bàn phím)
                InkWell(
                  onTap: () => _navigateToDetail(focusComment: true),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                          size: 23,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          NumberFormatter.formatCompact(widget.post.commentsCount),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Nút Share (Chia sẻ - Mở Share Sheet 3-trong-1)
                InkWell(
                  onTap: _openShareBottomSheet,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.near_me_outlined,
                          color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                          size: 23,
                        ),
                        if (_localSharesCount > 0) ...[
                          const SizedBox(width: 5),
                          Text(
                            NumberFormatter.formatCompact(_localSharesCount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Nút Bookmark (Lưu bài vào Bộ sưu tập)
                InkWell(
                  onTap: _openSaveCollectionSheet,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: _isBookmarked
                          ? AppColors.primary
                          : (isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 5. Section Caption & Comments Summary
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _navigateToDetail(),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.42,
                        color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: '${widget.post.user.username} ',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: widget.post.caption),
                      ],
                    ),
                  ),
                ),
                if (!widget.isInDetailScreen && widget.post.commentsCount > 0) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _navigateToDetail(focusComment: true),
                    child: Text(
                      '${context.tr('view_all_comments')} (${NumberFormatter.formatCompact(widget.post.commentsCount)})',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
