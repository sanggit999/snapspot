import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Full-screen interactive Image Viewer Dialog với Pinch-to-Zoom và Horizontal Swipe chuẩn Type Scale.
class ImageGalleryViewerDialog extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageGalleryViewerDialog({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  static void show(
    BuildContext context, {
    required List<String> imageUrls,
    int initialIndex = 0,
  }) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (ctx) => ImageGalleryViewerDialog(
        imageUrls: imageUrls,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  State<ImageGalleryViewerDialog> createState() =>
      _ImageGalleryViewerDialogState();
}

class _ImageGalleryViewerDialogState extends State<ImageGalleryViewerDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. PageView cuộn ngang ảnh hỗ trợ Pinch-to-Zoom
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.white, size: 40),
                        SizedBox(height: 8),
                        Text(
                          'Không thể tải hình ảnh',
                          style: TextStyle(color: Colors.white70, fontSize: 13.0),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // 2. Header Bar: Nút Đóng & Chỉ báo vị trí trang (1/3)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút đóng (X)
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                // Chỉ báo số trang (Ví dụ: 1 / 3)
                if (widget.imageUrls.length > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
