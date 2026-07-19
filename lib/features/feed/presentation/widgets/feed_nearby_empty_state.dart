import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

class FeedNearbyEmptyState extends StatelessWidget {
  final double userLat;
  final double userLng;
  final VoidCallback onRefreshPressed;

  const FeedNearbyEmptyState({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.onRefreshPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.gps_fixed_rounded,
              size: 64,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quét GPS không có bài viết lân cận',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Chúng tôi không tìm thấy bài đăng nào trong bán kính 10km quanh tọa độ của bạn (${userLat.toStringAsFixed(4)}, ${userLng.toStringAsFixed(4)}).',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.brightness == Brightness.light
                  ? AppColors.textLightSecondary
                  : AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRefreshPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Thử quét lại'),
          ),
        ],
      ),
    );
  }
}
