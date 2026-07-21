import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';
import 'package:snapspot/features/feed/presentation/widgets/feed_nearby_empty_state.dart';
import 'package:snapspot/features/feed/presentation/widgets/feed_shimmer_loader.dart';
import 'package:snapspot/features/feed/presentation/widgets/spot_card.dart';
import 'package:snapspot/features/feed/presentation/widgets/story_bar_section.dart';

/// Màn hình Trang chủ (Feed Screen).
/// Gồm hai Tab chính: Theo dõi (Follow) và Lân cận (Nearby).
/// Nâng cấp giao diện với Story Bar Tray, Top Bar và Thanh Lọc Chủ Đề Nhanh 2026.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _followScrollController = ScrollController();
  final ScrollController _nearbyScrollController = ScrollController();

  String _selectedCategory = '✨ Tất cả';
  final List<String> _categories = [
    '✨ Tất cả',
    '☕ Cafe đẹp',
    '🏖️ Du lịch',
    '🍜 Ăn uống',
    '📸 Sống ảo',
    '🏞️ Khám phá',
  ];

  // Vị trí GPS giả lập của người dùng hiện tại (Nhà thờ Đức Bà Sài Gòn làm gốc tọa độ)
  final double _userLat = 10.7769;
  final double _userLng = 106.7009;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadCurrentTabFeed();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentTabFeed();
    });

    _followScrollController.addListener(() {
      if (_followScrollController.position.pixels ==
          _followScrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
    _nearbyScrollController.addListener(() {
      if (_nearbyScrollController.position.pixels ==
          _nearbyScrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _followScrollController.dispose();
    _nearbyScrollController.dispose();
    super.dispose();
  }

  void _loadCurrentTabFeed() {
    final isNearby = _tabController.index == 1;
    context.read<FeedCubit>().fetchFeed(
          isNearby: isNearby,
          userLat: isNearby ? _userLat : null,
          userLng: isNearby ? _userLng : null,
        );
  }

  Future<void> _loadMorePosts() async {
    // Giả lập Infinite Scroll khi cuộn tới đáy trang
  }

  Widget _buildTopicFilterBar(bool isLight) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: isLight ? Colors.white : AppColors.surfaceDark,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedCategory = cat;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isLight ? Colors.grey[100] : Colors.grey[850]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isLight ? Colors.grey[300]! : Colors.grey[700]!),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isLight
                              ? AppColors.textLightPrimary
                              : AppColors.textDarkPrimary),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF833AB4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.camera_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'SnapSpot',
              style: TextStyle(
                color: isLight
                    ? AppColors.textLightPrimary
                    : AppColors.textDarkPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: isLight
                  ? AppColors.textLightPrimary
                  : AppColors.textDarkPrimary,
            ),
            onPressed: () => context.go('/explore'),
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: isLight
                      ? AppColors.textLightPrimary
                      : AppColors.textDarkPrimary,
                ),
                onPressed: () => context.go('/chat'),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isLight ? AppColors.borderLight : AppColors.borderDark,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: isLight
                  ? AppColors.textLightSecondary
                  : AppColors.textDarkSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
              tabs: [
                Tab(text: context.tr('tab_follow')),
                Tab(text: context.tr('tab_nearby')),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedList(_followScrollController, isNearby: false),
          _buildFeedList(_nearbyScrollController, isNearby: true),
        ],
      ),
    );
  }

  Widget _buildFeedList(
    ScrollController scrollController, {
    required bool isNearby,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return RefreshIndicator(
      onRefresh: () async {
        _loadCurrentTabFeed();
      },
      color: AppColors.primary,
      child: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return const FeedShimmerLoader();
          }

          if (state is FeedError) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const StoryBarSection(),
                _buildTopicFilterBar(isLight),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(child: Text(state.message)),
              ],
            );
          }

          if (state is FeedLoaded) {
            final posts = state.posts;

            if (posts.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const StoryBarSection(),
                  _buildTopicFilterBar(isLight),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  if (isNearby)
                    FeedNearbyEmptyState(
                      userLat: _userLat,
                      userLng: _userLng,
                      onRefreshPressed: _loadCurrentTabFeed,
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          context.tr('no_posts_found'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            return ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: posts.length + 2, // +1 StoryBarSection, +1 TopicFilterBar
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const StoryBarSection();
                }

                if (index == 1) {
                  return _buildTopicFilterBar(isLight);
                }

                final post = posts[index - 2];
                return SpotCard(
                  post: post,
                  userLat: _userLat,
                  userLng: _userLng,
                  onLikePressed: (postId) {
                    context.read<FeedCubit>().toggleLike(postId);
                  },
                  onSharePressed: (postId) {
                    context.read<FeedCubit>().incrementShareCount(postId);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
