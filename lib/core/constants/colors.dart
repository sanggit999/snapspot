import 'package:flutter/material.dart';

/// Danh sách hằng số màu sắc của hệ thống SnapSpot.
/// Ưu tiên các tone màu trẻ trung, hiện đại và hỗ trợ Dark Mode.
class AppColors {
  // Màu thương hiệu chính
  static const Color primary = Color(0xFFFF6F61); // Cam San Hô
  static const Color secondary = Color(0xFF4EA8DE); // Xanh Teal/Blue

  // Hệ màu Sáng (Light Mode)
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textLightPrimary = Color(0xFF1A1A1A);
  static const Color textLightSecondary = Color(0xFF757575);

  // Hệ màu Tối (Dark Mode)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textDarkPrimary = Color(0xFFF8F9FA);
  static const Color textDarkSecondary = Color(0xFFB0B0B0);

  // Trạng thái phản hồi hệ thống
  static const Color success = Color(0xFF2ECC71); // Thành công
  static const Color warning = Color(0xFFF1C40F); // Cảnh báo
  static const Color error = Color(0xFFE74C3C); // Lỗi

  // Các màu bổ trợ
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF2C2C2C);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF3A3A3A);
  static const Color shimmerHighlightDark = Color(0xFF4A4A4A);
}
