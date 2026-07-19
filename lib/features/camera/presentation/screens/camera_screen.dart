import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/localization/app_localizations.dart';

/// Màn hình máy ảnh giả lập (Camera Screen).
/// Gồm khung kính ngắm, bật tắt flash, chọn ảnh từ thư viện, và nút chụp hình.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  bool _showGrid = true;

  // Danh sách các ảnh chụp phong cảnh đẹp Việt Nam có sẵn trong Mock để gửi sang editor
  final List<Map<String, dynamic>> _mockGalleryPhotos = [
    {
      'url':
          'https://images.unsplash.com/photo-1528127269322-539801943592?w=800',
      'location': 'Phố cổ Hội An, Quảng Nam',
      'lat': 15.8801,
      'lng': 108.3380,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1509060464153-4466739f78d0?w=800',
      'location': 'Hồ Hoàn Kiếm, Hà Nội',
      'lat': 21.0285,
      'lng': 105.8542,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1583244964261-7dbd01180aee?w=800',
      'location': 'Đồi chè Cầu Đất, Đà Lạt',
      'lat': 11.9404,
      'lng': 108.4583,
    },
    {
      'url': 'https://images.unsplash.com/photo-1549488344-1f9b8d2bd1f3?w=800',
      'location': 'Nhà thờ Đức Bà, Quận 1, TP. HCM',
      'lat': 10.7769,
      'lng': 106.7009,
    },
  ];

  void _onCapturePressed() {
    // Chụp ảnh giả lập -> chọn ngẫu nhiên một bức ảnh từ gallery để mô phỏng camera chụp thật
    final randomPhoto = (_mockGalleryPhotos..shuffle()).first;
    _navigateToEditor(randomPhoto);
  }

  void _onGalleryPressed() {
    // Mở một bottom sheet để người dùng chọn ảnh từ thư viện giả lập
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('gallery'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _mockGalleryPhotos.length,
                  itemBuilder: (context, index) {
                    final photo = _mockGalleryPhotos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToEditor(photo);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(photo['url'], fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToEditor(Map<String, dynamic> photo) {
    // Truyền dữ liệu ảnh và GPS qua query parameters
    final encodedUrl = Uri.encodeComponent(photo['url']);
    final encodedLocation = Uri.encodeComponent(photo['location']);
    context.push(
      '/camera/editor?imagePath=$encodedUrl&location=$encodedLocation&lat=${photo['lat']}&lng=${photo['lng']}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Khung ngắm máy ảnh (Kính ngắm)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1C1C1E),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white24,
                    size: 80,
                  ),
                  // Vẽ các đường lưới căn lề (Rule of Thirds Grid)
                  if (_showGrid)
                    Positioned.fill(
                      child: CustomPaint(painter: CameraGridPainter()),
                    ),
                ],
              ),
            ),
          ),

          // 2. Thanh điều khiển trên đầu (Flash, Căn lề, Close)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFlashOn = !_isFlashOn;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    _showGrid ? Icons.grid_on : Icons.grid_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _showGrid = !_showGrid;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => context.go('/'),
                ),
              ],
            ),
          ),

          // 3. Bảng điều khiển nút chụp ở dưới cùng
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Chọn từ Gallery
                IconButton(
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _onGalleryPressed,
                ),

                // Nút Chụp hình (Double circle design)
                GestureDetector(
                  onTap: _onCapturePressed,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                // Xoay Camera trước/sau
                IconButton(
                  icon: Icon(
                    _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFrontCamera = !_isFrontCamera;
                    });
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

class CameraGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    // Đường thẳng đứng
    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 2 / 3, 0),
      Offset(size.width * 2 / 3, size.height),
      paint,
    );

    // Đường ngang
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
