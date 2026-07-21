import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/core/utils/geo_utils.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
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
  const FeedLoaded(this.posts);
}

class FeedError extends FeedState {
  final String message;
  const FeedError(this.message);
}

// --- CUBIT ---
class FeedCubit extends Cubit<FeedState> {
  final FeedRepository _feedRepository;

  FeedCubit(this._feedRepository) : super(const FeedInitial());

  // Lưu trữ danh sách bài viết hiện tại trong memory để dễ dàng thao tác Like/Comment/Share
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
          // Lọc các bài đăng trong bán kính 10km (NFR / Functional spec)
          posts = posts.where((post) {
            final distance = GeoUtils.calculateDistance(
              userLat,
              userLng,
              post.latitude,
              post.longitude,
            );
            return distance <= 10.0; // Bán kính 10km
          }).toList();
        }

        // Sắp xếp bài đăng mới nhất lên đầu
        posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        _currentPosts = posts;
        emit(FeedLoaded(_currentPosts));
      },
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

        emit(FeedLoaded(List.from(_currentPosts)));
      },
    );
  }

  /// Bày tỏ cảm xúc nhanh bằng Emoji (❤️, 🔥, 😍, 👏, 📍)
  void reactToPost(String postId, String emoji) {
    if (state is! FeedLoaded) return;

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

    emit(FeedLoaded(List.from(_currentPosts)));
  }

  /// Tăng số lượt chia sẻ khi người dùng gửi tin nhắn / copy link / chia sẻ ra ngoài
  void incrementShareCount(String postId) {
    if (state is! FeedLoaded) return;

    _currentPosts = _currentPosts.map((post) {
      if (post.id == postId) {
        return post.copyWith(sharesCount: post.sharesCount + 1);
      }
      return post;
    }).toList();

    emit(FeedLoaded(List.from(_currentPosts)));
  }

  /// Thêm bình luận mới vào bài viết
  Future<void> addComment(
    String postId,
    String content,
    UserEntity currentUser,
  ) async {
    if (state is! FeedLoaded || content.trim().isEmpty) return;

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

        emit(FeedLoaded(List.from(_currentPosts)));
      },
    );
  }

  /// Thêm bài đăng mới được tạo từ Post Editor
  void addNewPost(PostEntity newPost) {
    _currentPosts.insert(0, newPost);
    emit(FeedLoaded(List.from(_currentPosts)));
  }
}
