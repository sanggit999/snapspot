import 'package:flutter/material.dart';
import 'package:snapspot/features/feed/presentation/widgets/comment_thread/thread_item_painter.dart';

/// Widget vẽ đường kết nối thread line cho một reply item.
///
/// [connectorWidth]: Chiều rộng của vùng connector (mặc định 36.0px).
/// - Đường đứng ở lineX = 12px (thẳng hàng tâm avatar root tại X=28px).
/// - Đường ngang kéo dài từ 12px đến 30px (độ dài 18px).
/// - Chừa gap 6px từ 30px đến 36px.
/// - Reply avatar bắt đầu tại 36px → giúp reply lùi vào trong đẹp mắt!
class ThreadConnector extends StatelessWidget {
  final Color lineColor;
  final bool isLast;

  /// Phải đồng bộ với kích thước avatar thực tế = AppAvatarSize.small = 24.0
  final double avatarSize;

  /// Chiều rộng vùng connector. Quyết định độ lùi vào trong của reply avatar.
  final double connectorWidth;

  /// Khoảng hở (gap) giữa điểm kết thúc của đường kẻ ngang và mép trái avatar reply.
  final double gap;

  const ThreadConnector({
    super.key,
    required this.lineColor,
    required this.isLast,
    required this.avatarSize,
    this.connectorWidth = 36.0,
    this.gap = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: connectorWidth,
      child: CustomPaint(
        painter: ThreadItemPainter(
          lineColor: lineColor,
          isLast: isLast,
          avatarSize: avatarSize,
          gap: gap,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
