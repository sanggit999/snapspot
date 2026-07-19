import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/error/failures.dart';
import 'package:snapspot/core/network/mock_data.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/feed/domain/repositories/feed_repository.dart';

/// Triển khai FeedRepositoryImpl sử dụng fpdart Either.
class FeedRepositoryImpl implements FeedRepository {
  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return Right(List.from(MockData.mockPosts));
    } catch (e) {
      return Left(ServerFailure('Lỗi tải bài viết: $e'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> toggleLike(String postId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final idx = MockData.mockPosts.indexWhere((p) => p.id == postId);
      if (idx != -1) {
        final post = MockData.mockPosts[idx];
        final newIsLiked = !post.isLiked;
        final newLikesCount =
            newIsLiked ? post.likesCount + 1 : post.likesCount - 1;
        final updatedPost = post.copyWith(
          isLiked: newIsLiked,
          likesCount: newLikesCount,
        );
        MockData.mockPosts[idx] = updatedPost;
        return Right(updatedPost);
      }
      throw Exception('Bài viết không tồn tại');
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> addComment(
    String postId,
    CommentEntity comment,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final idx = MockData.mockPosts.indexWhere((p) => p.id == postId);
      if (idx != -1) {
        final post = MockData.mockPosts[idx];
        final updatedComments = List<CommentEntity>.from(post.comments)
          ..add(comment);
        final updatedPost = post.copyWith(
          comments: updatedComments,
          commentsCount: updatedComments.length,
        );
        MockData.mockPosts[idx] = updatedPost;
        return Right(updatedPost);
      }
      throw Exception('Bài viết không tồn tại');
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> addNewPost(PostEntity post) async {
    try {
      MockData.mockPosts.insert(0, post);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Lỗi thêm bài đăng mới: $e'));
    }
  }
}
