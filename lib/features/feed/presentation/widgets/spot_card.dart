import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/utils/geo_utils.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/core/widgets/images/image_gallery_viewer_dialog.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_header.dart';
import 'package:snapspot/features/feed/presentation/widgets/post_comment_section.dart';

/// Thẻ hiển thị bài đăng check-in với trải nghiệm tương tác (UX) đỉnh cao 2026.
/// Hỗ trợ Xem ảnh Fullscreen, Quick Emoji Reactions, Share Sheet, Bookmark Collections và chuyển đến Bản đồ vị trí.
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
  bool _isBookmarked = false;
  String? _savedCollectionName;
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (!widget.post.isLiked) {
      widget.onLikePressed?.call(widget.post.id);
    }
    _heartController.forward(from: 0.0);
  }

  void _openImageGallery() {
    if (widget.post.imageUrls.isNotEmpty) {
      ImageGalleryViewerDialog.show(
        context,
        imageUrls: widget.post.imageUrls,
        initialIndex: _currentImageIndex,
      );
    }
  }

  void _openCommentsBottomSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: PostCommentSection(
                comments: widget.post.comments,
                onCommentSubmitted: (content) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openShareBottomSheet() {
    final isLight = Theme.of(context).brightness == Brightness.light;

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
              const Text(
                'Chia sẻ bài viết',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Danh sách bạn bè để gửi nhanh qua Chat
              SizedBox(
                height: 85,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.mockUsers.length,
                  itemBuilder: (ctx, index) {
                    final u = MockData.mockUsers[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã gửi bài viết cho ${u.fullName}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            AppAvatar(imageUrl: u.avatarUrl, size: AppAvatarSize.medium),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 55,
                              child: Text(
                                u.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 24),

              // Các hành động chia sẻ khác
              ListTile(
                leading: const Icon(Icons.link_rounded, color: AppColors.primary),
                title: const Text('Sao chép liên kết bài viết'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã sao chép liên kết vào bộ nhớ tạm'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.send_rounded, color: Colors.blueAccent),
                title: const Text('Chia sẻ lên Tin của bạn (Story)'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/camera');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSaveCollectionSheet() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final collections = ['Địa điểm muốn đến', 'Quán cà phê đẹp', 'Ảnh chụp đẹp', 'Kinh nghiệm du lịch'];

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
              const Text(
                'Lưu vào Bộ sưu tập',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...collections.map(
                (col) => ListTile(
                  leading: const Icon(Icons.bookmark_add_outlined, color: AppColors.primary),
                  title: Text(col),
                  trailing: _savedCollectionName == col
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _isBookmarked = true;
                      _savedCollectionName = col;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã lưu bài viết vào "$col"')),
                    );
                  },
                ),
              ),
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
          // 1. Header Người đăng
          PostHeader(post: widget.post),

          // 2. Khung Ảnh Carousel bài viết với Double-Tap to Like & Tap to View Fullscreen
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

          // 3. Location & Distance Pill (Bấm vào để mở Bản đồ khám phá / Chỉ đường)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => context.go('/explore'),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primary),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.post.locationName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
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
                                fontWeight: FontWeight.w500,
                                color: isLight
                                    ? AppColors.textLightSecondary
                                    : AppColors.textDarkSecondary,
                              ),
                            ),
                          ],
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Action Bar Tương tác Tối ưu Thumb-Friendly UX
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Nút Like (Tim)
                InkWell(
                  onTap: () => widget.onLikePressed?.call(widget.post.id),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
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
                          '${widget.post.likesCount}',
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

                // Nút Comment (Bình luận)
                InkWell(
                  onTap: _openCommentsBottomSheet,
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
                          '${widget.post.commentsCount}',
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

                // Nút Share (Chia sẻ - Mở Share Sheet)
                InkWell(
                  onTap: _openShareBottomSheet,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.near_me_outlined,
                      color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                      size: 23,
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
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.35,
                      color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
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
                if (widget.post.commentsCount > 0) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _openCommentsBottomSheet,
                    child: Text(
                      '${context.tr('view_all_comments')} (${widget.post.commentsCount})',
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
