import 'package:snapspot/features/auth/data/mappers/user_mapper.dart';
import 'package:snapspot/features/feed/data/models/post_model.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Mapper chuyển đổi giữa [CommentModel]/[PostModel] (Data Layer)
/// và [CommentEntity]/[PostEntity] (Domain Layer).
///
/// Nguyên tắc: Mapper phải là các hàm thuần tuý (pure functions) —
/// không chứa side-effects, không phụ thuộc context bên ngoài.
class CommentMapper {
  const CommentMapper._();

  /// [CommentModel] → [CommentEntity]
  static CommentEntity toEntity(CommentModel model) {
    return CommentEntity(
      id: model.id,
      postId: model.postId,
      user: UserMapper.toEntity(model.user),
      content: model.content,
      createdAt: model.createdAt,
    );
  }

  /// [CommentEntity] → [CommentModel]
  static CommentModel fromEntity(CommentEntity entity) {
    return CommentModel(
      id: entity.id,
      postId: entity.postId,
      user: UserMapper.fromEntity(entity.user),
      content: entity.content,
      createdAt: entity.createdAt,
    );
  }

  /// Chuyển đổi danh sách [CommentModel] → danh sách [CommentEntity]
  static List<CommentEntity> toEntityList(List<CommentModel> models) {
    return models.map(toEntity).toList();
  }
}

/// Mapper chuyển đổi giữa [PostModel] (Data Layer)
/// và [PostEntity] (Domain Layer).
class PostMapper {
  const PostMapper._();

  /// [PostModel] → [PostEntity]
  static PostEntity toEntity(PostModel model) {
    return PostEntity(
      id: model.id,
      caption: model.caption,
      imageUrls: model.imageUrls,
      latitude: model.latitude,
      longitude: model.longitude,
      locationName: model.locationName,
      user: UserMapper.toEntity(model.user),
      hashtags: model.hashtags,
      likesCount: model.likesCount,
      commentsCount: model.commentsCount,
      isLiked: model.isLiked,
      createdAt: model.createdAt,
      comments: CommentMapper.toEntityList(model.comments),
    );
  }

  /// [PostEntity] → [PostModel]
  static PostModel fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      caption: entity.caption,
      imageUrls: entity.imageUrls,
      latitude: entity.latitude,
      longitude: entity.longitude,
      locationName: entity.locationName,
      user: UserMapper.fromEntity(entity.user),
      hashtags: entity.hashtags,
      likesCount: entity.likesCount,
      commentsCount: entity.commentsCount,
      isLiked: entity.isLiked,
      createdAt: entity.createdAt,
      comments: entity.comments.map(CommentMapper.fromEntity).toList(),
    );
  }

  /// Chuyển đổi danh sách [PostModel] → danh sách [PostEntity]
  static List<PostEntity> toEntityList(List<PostModel> models) {
    return models.map(toEntity).toList();
  }
}
