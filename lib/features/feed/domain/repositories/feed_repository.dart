import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/error/failures.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Giao diện FeedRepository sử dụng lập trình hàm với fpdart Either.
abstract class FeedRepository {
  /// Lấy danh sách toàn bộ bài viết trong hệ thống
  Future<Either<Failure, List<PostEntity>>> getPosts();

  /// Thả tim / Bỏ thả tim bài viết
  Future<Either<Failure, PostEntity>> toggleLike(String postId);

  /// Thêm bình luận vào bài viết
  Future<Either<Failure, PostEntity>> addComment(
    String postId,
    CommentEntity comment,
  );

  /// Thêm bài viết mới vào bộ lưu trữ nguồn
  Future<Either<Failure, void>> addNewPost(PostEntity post);
}
