import 'package:snapspot/features/feed/data/models/post_model.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/mappers/auth/user_mapper.dart';
import 'package:snapspot/mappers/feed/comment_mapper.dart';

export 'package:snapspot/mappers/feed/comment_mapper.dart';

/// Mapper duy nhất chuyển đổi giữa [PostModel] (Data Layer)
/// và [PostEntity] (Domain Layer).
class PostMapper {
  const PostMapper._();

  /// [PostModel] (Data) → [PostEntity] (Domain)
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
      comments: model.comments.map(CommentMapper.toEntity).toList(),
    );
  }

  /// [PostEntity] (Domain) → [PostModel] (Data)
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

  /// Chuyển đổi danh sách [PostModel] thành danh sách [PostEntity]
  static List<PostEntity> toEntityList(List<PostModel> models) {
    return models.map(toEntity).toList();
  }
}
