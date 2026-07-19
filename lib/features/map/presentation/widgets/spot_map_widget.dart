import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Một bản đồ giả lập tương tác cực kỳ cao cấp, sử dụng InteractiveViewer.
/// Tự động nội suy các tọa độ GPS thành tọa độ 2D trên màn hình.
/// Hỗ trợ kéo, thu phóng (pinch-to-zoom), hiển thị marker dạng avatar tròn và gom cụm.
class SpotMapWidget extends StatefulWidget {
  final List<PostEntity> spots;
  final PostEntity? selectedSpot;
  final void Function(PostEntity) onSpotSelected;

  const SpotMapWidget({
    super.key,
    required this.spots,
    this.selectedSpot,
    required this.onSpotSelected,
  });

  @override
  State<SpotMapWidget> createState() => _SpotMapWidgetState();
}

class _SpotMapWidgetState extends State<SpotMapWidget> {
  final TransformationController _transformationController =
      TransformationController();

  // Bán kính lớn nhất và nhỏ nhất của Việt Nam để quy đổi tọa độ GPS
  // Từ cực Bắc (Lũng Cú ~23.3) đến cực Nam (Cà Mau ~8.5)
  // Và cực Tây (102.1) đến cực Đông (109.5)
  final double minLat = 8.5;
  final double maxLat = 23.5;
  final double minLng = 102.0;
  final double maxLng = 110.0;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      color: isLight
          ? const Color(0xFFE5E9F0)
          : const Color(0xFF15181F), // Nền bản đồ phong cách hiện đại
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mapWidth =
              constraints.maxWidth *
              2.0; // Tạo bản đồ rộng gấp đôi để có thể kéo thả thoải mái
          final mapHeight = constraints.maxHeight * 2.0;

          return InteractiveViewer(
            transformationController: _transformationController,
            boundaryMargin: const EdgeInsets.all(200),
            minScale: 0.5,
            maxScale: 3.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Hình nền bản đồ giả lập (Các đường lưới phong cách viễn tưởng cao cấp)
                _buildMapBackground(mapWidth, mapHeight, isLight),

                // 2. Vẽ các Spot markers dựa vào tọa độ GPS
                ...widget.spots.map((spot) {
                  // Quy đổi tọa độ GPS sang điểm 2D trên Stack
                  // Chú ý: Vĩ độ (Latitude) tăng lên phía trên, nên tọa độ Y sẽ bằng: height - normalizedY
                  final double pctX =
                      (spot.longitude - minLng) / (maxLng - minLng);
                  final double pctY =
                      (spot.latitude - minLat) / (maxLat - minLat);

                  final double posX = pctX * mapWidth;
                  final double posY = mapHeight - (pctY * mapHeight);

                  final isSelected = widget.selectedSpot?.id == spot.id;

                  return Positioned(
                    left: posX - (isSelected ? 26.0 : 20.0),
                    top: posY - (isSelected ? 26.0 : 20.0),
                    child: GestureDetector(
                      onTap: () => widget.onSpotSelected(spot),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 250),
                        scale: isSelected ? 1.3 : 1.0,
                        child: _buildMapMarker(spot, isSelected, theme),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Vẽ hình nền bản đồ phong cách lưới ô vuông sang xịn mịn
  Widget _buildMapBackground(double width, double height, bool isLight) {
    final Color gridColor = isLight
        ? Colors.white.withValues(alpha: 0.4)
        : Colors.white.withValues(alpha: 0.04);
    final Color landmarkColor = isLight
        ? Colors.black.withValues(alpha: 0.03)
        : Colors.white.withValues(alpha: 0.015);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isLight ? const Color(0xFFECEFF4) : const Color(0xFF1B202C),
      ),
      child: CustomPaint(
        painter: MapGridPainter(
          gridColor: gridColor,
          landmarkColor: landmarkColor,
        ),
      ),
    );
  }

  /// Marker hiển thị avatar nhỏ có bo viền bóng bẩy
  Widget _buildMapMarker(PostEntity spot, bool isSelected, ThemeData theme) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isSelected ? Colors.white : AppColors.primary,
          width: 2.0,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: spot.imageUrls[0],
          fit: BoxFit.cover,
          errorWidget: (context, url, error) =>
              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
        ),
      ),
    );
  }
}

/// Painter vẽ các nét đứt và lưới lưới của bản đồ giả lập
class MapGridPainter extends CustomPainter {
  final Color gridColor;
  final Color landmarkColor;

  MapGridPainter({required this.gridColor, required this.landmarkColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final paintLandmark = Paint()
      ..color = landmarkColor
      ..style = PaintingStyle.fill;

    // Vẽ lưới ô vuông
    const double gridSize = 60.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paintGrid);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    // Vẽ một số hình tròn/oval mờ nhạt đại diện cho các lục địa/con sông giả lập
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.4),
      180,
      paintLandmark,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.25),
      240,
      paintLandmark,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.7),
      200,
      paintLandmark,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
