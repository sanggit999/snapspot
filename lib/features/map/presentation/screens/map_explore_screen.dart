import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/map/presentation/blocs/map_cubit.dart';
import 'package:snapspot/features/map/presentation/widgets/spot_map_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Màn hình Bản đồ Khám phá (Map Explore Screen).
/// Chứa thanh tìm kiếm ở trên đầu, SpotMapWidget ở trung tâm, và Spot Preview Card trượt ở cạnh dưới.
class MapExploreScreen extends StatefulWidget {
  const MapExploreScreen({super.key});

  @override
  State<MapExploreScreen> createState() => _MapExploreScreenState();
}

class _MapExploreScreenState extends State<MapExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load lại toàn bộ địa điểm
    context.read<MapCubit>().loadSpots(
      newRadius: 2000.0,
    ); // Bán kính lớn 2000km để quét toàn quốc
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) {
      context.read<MapCubit>().loadSpots(newRadius: 2000.0);
      return;
    }

    // Lọc các spots theo từ khóa trong caption, tên địa điểm, hoặc tag
    final mapCubit = context.read<MapCubit>();
    mapCubit.loadSpots(newRadius: 2000.0).then((_) {
      final currentState = mapCubit.state;
      final filtered = currentState.visibleSpots.where((spot) {
        final q = query.toLowerCase();
        return spot.locationName.toLowerCase().contains(q) ||
            spot.caption.toLowerCase().contains(q) ||
            spot.hashtags.any((tag) => tag.toLowerCase().contains(q));
      }).toList();

      // Cập nhật trạng thái thông qua Cubit
      mapCubit.updateFilteredSpots(filtered);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Bản đồ giả lập tương tác
          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              return SpotMapWidget(
                spots: state.visibleSpots,
                selectedSpot: state.selectedSpot,
                onSpotSelected: (spot) {
                  context.read<MapCubit>().selectSpot(spot);
                },
              );
            },
          ),

          // 2. Thanh Tìm kiếm trên đầu (Glassmorphic)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _onSearchSubmitted,
                  decoration: InputDecoration(
                    hintText: context.tr('search_places_or_tags'),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchSubmitted('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),

          // 3. Spot Preview Card trượt ở cạnh dưới
          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              if (state.selectedSpot == null) return const SizedBox.shrink();

              final spot = state.selectedSpot!;

              return Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _buildSpotPreviewCard(spot, theme),
              );
            },
          ),

          // Chỉ báo loading mờ
          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              if (!state.isLoading) return const SizedBox.shrink();
              return const Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Quét toạ độ...',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpotPreviewCard(PostEntity spot, ThemeData theme) {
    return Dismissible(
      key: Key('preview_${spot.id}'),
      direction: DismissDirection.down,
      onDismissed: (_) {
        context.read<MapCubit>().deselectSpot();
      },
      child: GestureDetector(
        onTap: () {
          // Đi thẳng vào trang chi tiết bài viết
          context.push('/post/${spot.id}');
        },
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Ảnh thu nhỏ của spot
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: spot.imageUrls[0],
                  width: 86,
                  height: 86,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Thông tin mô tả
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      spot.locationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spot.caption,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundImage: NetworkImage(spot.user.avatarUrl),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '@${spot.user.username}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Nút Xem chi tiết
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      context.read<MapCubit>().deselectSpot();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primary,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
