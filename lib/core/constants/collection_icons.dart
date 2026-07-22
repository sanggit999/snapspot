import 'package:flutter/material.dart';

/// Lớp quản lý Kho biểu tượng (Icon Library Catalog) phong phú cho Hệ thống Bộ sưu tập SnapSpot.
class AppCollectionIcons {
  static final List<Map<String, dynamic>> iconCategories = [
    {
      'categoryKey': 'cat_popular',
      'categoryName': 'Phổ biến',
      'icons': [
        {'name': 'bookmark', 'icon': Icons.bookmark_rounded, 'label': 'Đánh dấu'},
        {'name': 'heart', 'icon': Icons.favorite_rounded, 'label': 'Yêu thích'},
        {'name': 'star', 'icon': Icons.star_rounded, 'label': 'Ngôi sao'},
        {'name': 'thumb_up', 'icon': Icons.thumb_up_rounded, 'label': 'Thích'},
        {'name': 'flag', 'icon': Icons.flag_rounded, 'label': 'Cờ'},
        {'name': 'diamond', 'icon': Icons.diamond_rounded, 'label': 'Kim cương'},
      ]
    },
    {
      'categoryKey': 'cat_travel',
      'categoryName': 'Du lịch',
      'icons': [
        {'name': 'map', 'icon': Icons.map_rounded, 'label': 'Bản đồ'},
        {'name': 'explore', 'icon': Icons.explore_rounded, 'label': 'Khám phá'},
        {'name': 'flight', 'icon': Icons.flight_takeoff_rounded, 'label': 'Chuyến bay'},
        {'name': 'car', 'icon': Icons.directions_car_rounded, 'label': 'Xe cộ'},
        {'name': 'hiking', 'icon': Icons.hiking_rounded, 'label': 'Phượt & Trekking'},
        {'name': 'beach', 'icon': Icons.beach_access_rounded, 'label': 'Biển & Resort'},
        {'name': 'hotel', 'icon': Icons.hotel_rounded, 'label': 'Khách sạn'},
        {'name': 'mountain', 'icon': Icons.landscape_rounded, 'label': 'Núi rừng'},
      ]
    },
    {
      'categoryKey': 'cat_food',
      'categoryName': 'Ẩm thực',
      'icons': [
        {'name': 'cafe', 'icon': Icons.local_cafe_rounded, 'label': 'Cà phê'},
        {'name': 'restaurant', 'icon': Icons.restaurant_rounded, 'label': 'Nhà hàng'},
        {'name': 'bar', 'icon': Icons.local_bar_rounded, 'label': 'Quán Bar'},
        {'name': 'fastfood', 'icon': Icons.fastfood_rounded, 'label': 'Đồ ăn nhanh'},
        {'name': 'cake', 'icon': Icons.cake_rounded, 'label': 'Bánh ngọt'},
        {'name': 'icecream', 'icon': Icons.icecream_rounded, 'label': 'Kem'},
      ]
    },
    {
      'categoryKey': 'cat_lifestyle',
      'categoryName': 'Lối sống',
      'icons': [
        {'name': 'camera', 'icon': Icons.photo_camera_rounded, 'label': 'Nhiếp ảnh'},
        {'name': 'palette', 'icon': Icons.palette_rounded, 'label': 'Hội họa'},
        {'name': 'music', 'icon': Icons.music_note_rounded, 'label': 'Âm nhạc'},
        {'name': 'movie', 'icon': Icons.movie_rounded, 'label': 'Phim ảnh'},
        {'name': 'shopping', 'icon': Icons.shopping_bag_rounded, 'label': 'Mua sắm'},
        {'name': 'fitness', 'icon': Icons.fitness_center_rounded, 'label': 'Thể thao'},
        {'name': 'pets', 'icon': Icons.pets_rounded, 'label': 'Thú cưng'},
      ]
    },
  ];

  /// Tra cứu IconData theo tên mã hóa iconName
  static IconData getIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) return Icons.collections_bookmark_rounded;

    for (final cat in iconCategories) {
      final icons = cat['icons'] as List<Map<String, dynamic>>;
      for (final item in icons) {
        if (item['name'] == iconName) {
          return item['icon'] as IconData;
        }
      }
    }

    // Default fallbacks
    switch (iconName) {
      case 'heart':
        return Icons.favorite_rounded;
      case 'map':
        return Icons.map_rounded;
      case 'cafe':
        return Icons.local_cafe_rounded;
      case 'camera':
        return Icons.photo_camera_rounded;
      case 'explore':
        return Icons.explore_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'bookmark':
      default:
        return Icons.collections_bookmark_rounded;
    }
  }
}
