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
/// Chuẩn hóa Type Scale & Glassmorphic Search Bar cho cả Light & Dark Mode.
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
    context.read<MapCubit>().loadSpots(newRadius: 2000.0);
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

    final mapCubit = context.read<MapCubit>();
    mapCubit.loadSpots(newRadius: 2000.0).then((_) {
      final currentState = mapCubit.state;
      final filtered = currentState.visibleSpots.where((spot) {
        final q = query.toLowerCase();
        return spot.locationName.toLowerCase().contains(q) ||
            spot.caption.toLowerCase().contains(q) ||
            spot.hashtags.any((tag) => tag.toLowerCase().contains(q));
      }).toList();

      mapCubit.updateFilteredSpots(filtered);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

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
                color: isLight
                    ? Colors.white.withValues(alpha: 0.92)
                    : AppColors.surfaceDark.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isLight ? AppColors.borderLight : AppColors.borderDark,
                  width: 1,
                ),
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
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isLight
                        ? AppColors.textLightPrimary
                        : AppColors.textDarkPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: context.tr('search_places_or_tags'),
                    hintStyle: TextStyle(
                      fontSize: 13.5,
                      color: isLight
                          ? AppColors.textLightSecondary
                          : AppColors.textDarkSecondary,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
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

          // 3. Spot Preview Card trượt ở cạnh dưới - Tối ưu bằng BlocSelector
          BlocSelector<MapCubit, MapState, PostEntity?>(
            selector: (state) => state.selectedSpot,
            builder: (context, selectedSpot) {
              if (selectedSpot == null) return const SizedBox.shrink();

              return Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _buildSpotPreviewCard(selectedSpot, isLight),
              );
            },
          ),

          // 4. Chỉ báo loading mờ
          BlocSelector<MapCubit, MapState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, isLoading) {
              if (!isLoading) return const SizedBox.shrink();

              return Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Card(
                    elevation: 4,
                    color: isLight ? Colors.white : AppColors.surfaceDark,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Quét toạ độ...',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isLight
                                  ? AppColors.textLightPrimary
                                  : AppColors.textDarkPrimary,
                            ),
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

  Widget _buildSpotPreviewCard(PostEntity spot, bool isLight) {
    return Dismissible(
      key: Key('preview_${spot.id}'),
      direction: DismissDirection.down,
      onDismissed: (_) {
        context.read<MapCubit>().deselectSpot();
      },
      child: GestureDetector(
        onTap: () {
          context.push('/post/${spot.id}');
        },
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLight ? AppColors.borderLight : AppColors.borderDark,
              width: 1,
            ),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      spot.locationName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        color: isLight
                            ? AppColors.textLightPrimary
                            : AppColors.textDarkPrimary,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spot.caption,
                      style: TextStyle(
                        fontSize: 13.0,
                        height: 1.35,
                        color: isLight
                            ? AppColors.textLightSecondary
                            : AppColors.textDarkSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  context.push('/post/${spot.id}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
