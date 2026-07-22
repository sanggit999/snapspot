import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/core/mock/mock_data.dart';
import 'package:snapspot/core/utils/geo_utils.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/domain/entities/trending_hashtag_entity.dart';
import 'package:snapspot/features/feed/domain/repositories/feed_repository.dart';

// --- STATES ---
abstract class FeedState {
  const FeedState();
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final List<PostEntity> posts;
  final List<TrendingHashtagEntity> trendingHashtags;

  const FeedLoaded({
    required this.posts,
    required this.trendingHashtags,
  });
}

class FeedError extends FeedState {
  final String message;
  const FeedError(this.message);
}

// --- CUBIT ---
class FeedCubit extends Cubit<FeedState> {
  final FeedRepository _feedRepository;

  FeedCubit(this._feedRepository) : super(const FeedInitial());

  // Lưu trữ danh sách bài viết hiện tại trong memory
  List<PostEntity> _currentPosts = [];

  /// Tải danh sách bài viết.
  /// Nếu [isNearby] = true, tiến hành lọc các bài đăng nằm trong bán kính 10km so với vị trí hiện tại.
  Future<void> fetchFeed({
    bool isNearby = false,
    double? userLat,
    double? userLng,
  }) async {
    emit(const FeedLoading());

    final result = await _feedRepository.getPosts();
    result.fold(
      (failure) => emit(FeedError(failure.message)),
      (postsList) {
        List<PostEntity> posts = List.from(postsList);

        if (isNearby && userLat != null && userLng != null) {
          // Lọc các bài đăng trong bán kính 10km
          posts = posts.where((post) {
            final distance = GeoUtils.calculateDistance(
              userLat,
              userLng,
              post.latitude,
              post.longitude,
            );
            return distance <= 10.0;
          }).toList();
        }

        // Sắp xếp bài đăng mới nhất lên đầu
        posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        _currentPosts = posts;
        _emitLoaded();
      },
    );
  }

  /// THUẬT TOÁN SENIOR ARCHITECT: Phân tích Lịch sử Tương tác (Likes, Bookmarks, Reactions) của User
  /// để tự động tính toán cờ `isRecommended = true` cho các Hashtag phù hợp nhất với sở thích!
  List<TrendingHashtagEntity> _extractTrendingHashtags(List<PostEntity> posts) {
    final Map<String, int> tagCounts = {};
    final Set<String> userPreferredTags = {};

    // 1. Thống kê mảng hashtags và trích xuất các hashtag mà User từng tương tác (Liked, Bookmarked, Reacted)
    for (final post in posts) {
      final isInteracted = post.isLiked || post.isBookmarked || post.userReaction != null;

      for (final rawTag in post.hashtags) {
        final cleanTag = rawTag.replaceAll('#', '').trim().toLowerCase();
        if (cleanTag.isNotEmpty) {
          tagCounts[cleanTag] = (tagCounts[cleanTag] ?? 0) + 1;
          if (isInteracted) {
            userPreferredTags.add(cleanTag);
          }
        }
      }
    }

    // 2. Sắp xếp mảng Hashtags: Ưu tiên các hashtag thuộc sở thích người dùng (isRecommended), sau đó theo số bài
    final sortedEntries = tagCounts.entries.toList()
      ..sort((a, b) {
        final aRecommended = userPreferredTags.contains(a.key);
        final bRecommended = userPreferredTags.contains(b.key);

        if (aRecommended && !bRecommended) return -1;
        if (!aRecommended && bRecommended) return 1;
        return b.value.compareTo(a.value);
      });

    // 3. Khởi tạo mảng kết quả với Thẻ 'Tất cả' ở vị trí số 1
    final List<TrendingHashtagEntity> items = [
      TrendingHashtagEntity(
        tagKey: 'ALL',
        postCount: posts.length,
        displayLabel: '✨ Tất cả (${posts.length})',
        isRecommended: false,
      ),
    ];

    // 4. Định dạng nhãn hiển thị kèm icon ⭐ Gợi ý: cho các tag thuộc sở thích
    for (int i = 0; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      final tag = entry.key;
      final count = entry.value;

      final isRecommended = userPreferredTags.contains(tag);
      final prefixIcon = isRecommended ? '⭐ Gợi ý:' : (i < 3 ? '🔥' : '📍');

      items.add(
        TrendingHashtagEntity(
          tagKey: tag,
          postCount: count,
          displayLabel: '$prefixIcon #$tag ($count)',
          isRecommended: isRecommended,
        ),
      );
    }

    return items;
  }

  void _emitLoaded() {
    emit(
      FeedLoaded(
        posts: List.from(_currentPosts),
        trendingHashtags: _extractTrendingHashtags(_currentPosts),
      ),
    );
  }

  /// Thao tác Thích / Bỏ thích bài viết
  Future<void> toggleLike(String postId) async {
    if (state is! FeedLoaded) return;

    final result = await _feedRepository.toggleLike(postId);
    result.fold(
      (failure) => null,
      (updatedPost) {
        _currentPosts = _currentPosts.map((post) {
          return post.id == postId ? updatedPost : post;
        }).toList();

        _emitLoaded();
      },
    );
  }

  /// Thao tác Lưu / Bỏ lưu bài viết vào Bộ sưu tập (Bookmarks & Collections)
  void toggleBookmark({
    required String postId,
    required String collectionName,
    required bool isBookmarked,
  }) {
    final index = MockData.mockPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      MockData.mockPosts[index] = MockData.mockPosts[index].copyWith(
        isBookmarked: isBookmarked,
        savedCollectionName: isBookmarked ? collectionName : null,
      );
    }

    _currentPosts = _currentPosts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          isBookmarked: isBookmarked,
          savedCollectionName: isBookmarked ? collectionName : null,
        );
      }
      return post;
    }).toList();

    _emitLoaded();
  }

  /// Bày tỏ cảm xúc nhanh bằng Emoji (❤️, 🔥, 😍, 👏, 📍)
  void reactToPost(String postId, String emoji) {
    final index = MockData.mockPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = MockData.mockPosts[index];
      final isAlreadyLiked = post.isLiked;
      MockData.mockPosts[index] = post.copyWith(
        userReaction: emoji,
        isLiked: true,
        likesCount: isAlreadyLiked ? post.likesCount : post.likesCount + 1,
      );
    }

    _currentPosts = _currentPosts.map((post) {
      if (post.id == postId) {
        final isAlreadyLiked = post.isLiked;
        return post.copyWith(
          userReaction: emoji,
          isLiked: true,
          likesCount: isAlreadyLiked ? post.likesCount : post.likesCount + 1,
        );
      }
      return post;
    }).toList();

    _emitLoaded();
  }

  /// Tăng số lượt chia sẻ khi người dùng gửi tin nhắn / copy link / chia sẻ ra ngoài
  void incrementShareCount(String postId) {
    final index = MockData.mockPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      MockData.mockPosts[index] = MockData.mockPosts[index].copyWith(
        sharesCount: MockData.mockPosts[index].sharesCount + 1,
      );
    }

    _currentPosts = _currentPosts.map((post) {
      if (post.id == postId) {
        return post.copyWith(sharesCount: post.sharesCount + 1);
      }
      return post;
    }).toList();

    _emitLoaded();
  }

  /// Thêm bình luận mới vào bài viết
  Future<void> addComment(
    String postId,
    String content,
    UserEntity currentUser,
  ) async {
    if (content.trim().isEmpty) return;

    final newComment = CommentEntity(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      user: currentUser,
      content: content.trim(),
      createdAt: DateTime.now(),
    );

    final result = await _feedRepository.addComment(postId, newComment);
    result.fold(
      (failure) => null,
      (updatedPost) {
        _currentPosts = _currentPosts.map((post) {
          return post.id == postId ? updatedPost : post;
        }).toList();

        _emitLoaded();
      },
    );
  }

  /// Thêm bài đăng mới được tạo từ Post Editor
  void addNewPost(PostEntity newPost) {
    MockData.mockPosts.insert(0, newPost);
    _currentPosts.insert(0, newPost);
    _emitLoaded();
  }
}
