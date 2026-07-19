import 'package:flutter/material.dart';
import 'package:snapspot/core/constants/colors.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light
              ? Colors.white
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
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
            _buildStatItem(postsCount.toString(), postsLabel),
            _buildStatItem(followersCount.toString(), followersLabel),
            _buildStatItem(followingCount.toString(), followingLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
