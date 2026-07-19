import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';
import 'package:snapspot/features/feed/presentation/widgets/feed_nearby_empty_state.dart';
import 'package:snapspot/features/feed/presentation/widgets/feed_shimmer_loader.dart';
import 'package:snapspot/features/feed/presentation/widgets/spot_card.dart';

/// Màn hình Trang chủ (Feed Screen).
/// Gồm hai Tab chính: Theo dõi (Follow) và Lân cận (Nearby).
/// Áp dụng mẫu thiết kế Widget Composition Pattern ghép nối từ các widget con chuyên biệt.
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SnapSpot',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_camera_back_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/explore'),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.go('/chat'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.brightness == Brightness.light
                      ? AppColors.borderLight
                      : AppColors.borderDark,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: theme.brightness == Brightness.light
                  ? AppColors.textLightSecondary
                  : AppColors.textDarkSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
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
              padding: const EdgeInsets.only(top: 12),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return SpotCard(
                  post: post,
                  userLat: _userLat,
                  userLng: _userLng,
                  onLikePressed: (postId) {
                    context.read<FeedCubit>().toggleLike(postId);
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
