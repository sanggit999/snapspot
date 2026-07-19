import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

class FeedShimmerLoader extends StatelessWidget {
  const FeedShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final baseColor = isLight ? AppColors.shimmerBase : AppColors.shimmerBaseDark;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          height: 380,
          decoration: BoxDecoration(
            color: isLight ? Colors.white : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Shimmer
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(radius: 20, backgroundColor: baseColor),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 120, height: 12, color: baseColor),
                        const SizedBox(height: 6),
                        Container(width: 80, height: 8, color: baseColor),
                      ],
                    ),
                  ],
                ),
              ),
              // Image Shimmer
              Expanded(
                child: Container(width: double.infinity, color: baseColor),
              ),
              // Footer Shimmer
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150, height: 10, color: baseColor),
                    const SizedBox(height: 6),
                    Container(width: 250, height: 8, color: baseColor),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
