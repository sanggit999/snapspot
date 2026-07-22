import 'package:flutter/material.dart';

/// Danh sách hằng số màu sắc của hệ thống SnapSpot.
/// Đạt chuẩn UI/UX 2026: Ưu tiên các tone màu trẻ trung, sắc nét ở Light Mode và chống mỏi mắt ở Dark Mode.
class AppColors {
  // Màu thương hiệu chính
  static const Color primary = Color(0xFFFF6F61); // Cam San Hô
  static const Color secondary = Color(0xFF4EA8DE); // Xanh Teal/Blue

  // Hệ màu Sáng (Light Mode - Sắc nét ban ngày, Contrast >= 4.5:1)
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textLightPrimary = Color(0xFF111111); // Đen sẫm sắc nét 98%
  static const Color textLightSecondary = Color(0xFF606060); // Xám trung tính sắc nét ban ngày

  // Hệ màu Tối (Dark Mode Anti-Glare & Soft Contrast)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textDarkPrimary = Color(0xFFF0F0F0); // Trắng ngọc dịu mắt (90% opacity white)
  static const Color textDarkSecondary = Color(0xFF8E8E93); // Xám dịu mắt (Muted Grey)

  // Trạng thái phản hồi hệ thống
  static const Color success = Color(0xFF2ECC71); // Thành công
  static const Color warning = Color(0xFFF1C40F); // Cảnh báo
  static const Color error = Color(0xFFE74C3C); // Lỗi

  // Các màu bổ trợ
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF2C2C2C);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF3A3A3A);
  static const Color shimmerHighlightDark = Color(0xFF4A4A4A);
}
