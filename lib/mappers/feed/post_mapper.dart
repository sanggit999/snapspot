import 'package:snapspot/features/feed/data/models/post_model.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/mappers/auth/user_mapper.dart';

/// Mapper duy nhất chuyển đổi giữa [CommentModel] (Data Layer)
/// và [CommentEntity] (Domain Layer).
class CommentMapper {
  const CommentMapper._();

  /// [CommentModel] (Data) → [CommentEntity] (Domain)
  static CommentEntity toEntity(CommentModel model) {
    return CommentEntity(
      id: model.id,
      postId: model.postId,
      user: UserMapper.toEntity(model.user),
      content: model.content,
      mediaUrl: model.mediaUrl,
      parentId: model.parentId,
      rootId: model.rootId,
      replyToUser: model.replyToUser != null
          ? UserMapper.toEntity(model.replyToUser!)
          : null,
      replies: model.replies.map(toEntity).toList(),
      likesCount: model.likesCount,
      isLiked: model.isLiked,
      repliesCount: model.repliesCount,
      depth: model.depth,
      isPinned: model.isPinned,
      createdAt: model.createdAt,
    );
  }

  /// [CommentEntity] (Domain) → [CommentModel] (Data)
  static CommentModel fromEntity(CommentEntity entity) {
    return CommentModel(
      id: entity.id,
      postId: entity.postId,
      user: UserMapper.fromEntity(entity.user),
      content: entity.content,
      mediaUrl: entity.mediaUrl,
      parentId: entity.parentId,
      rootId: entity.rootId,
      replyToUser: entity.replyToUser != null
          ? UserMapper.fromEntity(entity.replyToUser!)
          : null,
      replies: entity.replies.map(fromEntity).toList(),
      likesCount: entity.likesCount,
      isLiked: entity.isLiked,
      repliesCount: entity.repliesCount,
      depth: entity.depth,
      isPinned: entity.isPinned,
      createdAt: entity.createdAt,
    );
  }

  /// Chuyển đổi danh sách [CommentModel] thành danh sách [CommentEntity]
  static List<CommentEntity> toEntityList(List<CommentModel> models) {
    return models.map(toEntity).toList();
  }

  /// Tự động gom mảng phẳng [flatList] với `parentId` thành cấu trúc Cây (Tree structure).
  /// Giúp Frontend tương thích dễ dàng dù Backend trả về mảng phẳng hay mảng cây.
  static List<CommentEntity> toTreeList(List<CommentEntity> flatList) {
    final Map<String, CommentEntity> itemMap = {
      for (var item in flatList) item.id: item.copyWith(replies: [])
    };

    final List<CommentEntity> rootList = [];

    for (var item in flatList) {
      if (item.parentId == null || !itemMap.containsKey(item.parentId)) {
        rootList.add(itemMap[item.id]!);
      } else {
        final parent = itemMap[item.parentId]!;
        final updatedReplies = List<CommentEntity>.from(parent.replies)
          ..add(itemMap[item.id]!);
        itemMap[item.parentId!] = parent.copyWith(replies: updatedReplies);
      }
    }

    return rootList;
  }
}

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
