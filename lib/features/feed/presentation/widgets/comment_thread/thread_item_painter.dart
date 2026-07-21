import 'package:flutter/material.dart';

/// Vẽ đường kết nối luồng hội thoại (thread line) cho từng reply.
class ThreadItemPainter extends CustomPainter {
  final Color lineColor;

  /// isLast: item cuối kết thúc bằng L-shape thay vì đường thẳng xuống.
  final bool isLast;

  /// Kích thước avatar (px). lineX = avatarSize/2.
  final double avatarSize;

  /// Độ dày nét kẻ.
  final double strokeWidth;

  /// Bán kính góc cong L-shape.
  final double cornerRadius;

  /// Khoảng thở (gap) giữa điểm kết thúc của đường kẻ ngang và mép trái avatar reply.
  final double gap;

  const ThreadItemPainter({
    required this.lineColor,
    required this.isLast,
    this.avatarSize = 24.0,
    this.strokeWidth = 2.0,
    this.cornerRadius = 6.0,
    this.gap = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    /// X đường đứng — canh tâm avatar root (12px với avatar 24px).
    final double lineX = avatarSize / 2;

    /// Y tâm avatar — nhánh ngang bắt đầu rẽ tại đây (12px).
    final double avatarCenterY = avatarSize / 2;

    /// Điểm dừng của đường kẻ ngang.
    /// canvas width = connectorWidth (VD: 36px).
    /// connectorEnd = 36 - 6 = 30px → chừa 6px gap trước khi đụng avatar reply (36px).
    final double connectorEnd = (size.width - gap).clamp(lineX, size.width);

    if (!isLast) {
      // Đường đứng suốt chiều cao item.
      canvas.drawLine(
        Offset(lineX, 0),
        Offset(lineX, size.height),
        paint,
      );
      // Nhánh ngang vươn sang phải tới connectorEnd.
      canvas.drawLine(
        Offset(lineX, avatarCenterY),
        Offset(connectorEnd, avatarCenterY),
        paint,
      );
      return;
    }

    // Reply cuối: L-shape (quarter-circle arc).
    final path = Path()
      ..moveTo(lineX, 0)
      ..lineTo(lineX, avatarCenterY - cornerRadius)
      ..arcToPoint(
        Offset(lineX + cornerRadius, avatarCenterY),
        radius: Radius.circular(cornerRadius),
        clockwise: false,
      );

    if (connectorEnd > lineX + cornerRadius) {
      path.lineTo(connectorEnd, avatarCenterY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ThreadItemPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.isLast != isLast ||
        oldDelegate.avatarSize != avatarSize ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.gap != gap;
  }
}
