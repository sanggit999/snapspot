import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';
import 'package:snapspot/features/feed/presentation/widgets/spot_card.dart';

/// Màn hình Trang chủ (Feed Screen).
/// Gồm hai Tab chính: Theo dõi (Follow) và Lân cận (Nearby).
/// Hỗ trợ Pull-to-refresh, tải vô tận và tính toán vị trí GPS giả lập để quét bán kính.
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

    // Đăng ký listener chuyển tab để load lại feed tương ứng
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadCurrentTabFeed();
      }
    });

    // Gọi load lần đầu khi khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentTabFeed();
    });

    // Lắng nghe sự kiện cuộn để tạo hiệu ứng Infinite Scroll giả lập
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
    // Giả lập load thêm trang tiếp theo (Infinite Scroll)
    // Để giữ bài viết đơn giản, ta chỉ in log hoặc append
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
          // Tab 1: Theo dõi (Following Feed)
          _buildFeedList(_followScrollController, isNearby: false),

          // Tab 2: Lân cận (Nearby Feed)
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
            return _buildShimmerLoading();
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
                    _buildNearbyEmptyState()
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

  Widget _buildShimmerLoading() {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final baseColor = isLight
        ? AppColors.shimmerBase
        : AppColors.shimmerBaseDark;

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

  Widget _buildNearbyEmptyState() {
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
            'Chúng tôi không tìm thấy bài đăng nào trong bán kính 10km quanh tọa độ của bạn (${_userLat.toStringAsFixed(4)}, ${_userLng.toStringAsFixed(4)}).',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.brightness == Brightness.light
                  ? AppColors.textLightSecondary
                  : AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _loadCurrentTabFeed,
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
