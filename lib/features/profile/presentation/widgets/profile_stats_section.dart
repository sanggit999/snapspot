import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

/// Section Thống kê Trang cá nhân (Số bài đăng, Người theo dõi, Đang theo dõi) chuẩn Type Scale.
class ProfileStatsSection extends StatelessWidget {
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final String postsLabel;
  final String followersLabel;
  final String followingLabel;

  const ProfileStatsSection({
    super.key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.postsLabel,
    required this.followersLabel,
    required this.followingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
            width: 1,
          ),
          boxShadow: [
            if (isLight)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(postsCount.toString(), postsLabel, isLight),
            Container(
              height: 24,
              width: 1,
              color: isLight ? AppColors.borderLight : AppColors.borderDark,
            ),
            _buildStatItem(followersCount.toString(), followersLabel, isLight),
            Container(
              height: 24,
              width: 1,
              color: isLight ? AppColors.borderLight : AppColors.borderDark,
            ),
            _buildStatItem(followingCount.toString(), followingLabel, isLight),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, bool isLight) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
          ),
        ),
      ],
    );
  }
}
