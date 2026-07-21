// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      mediaUrl: json['media_url'] as String?,
      parentId: json['parent_id'] as String?,
      rootId: json['root_id'] as String?,
      replyToUser: json['reply_to_user'] == null
          ? null
          : UserModel.fromJson(json['reply_to_user'] as Map<String, dynamic>),
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      repliesCount: (json['replies_count'] as num?)?.toInt(),
      depth: (json['depth'] as num?)?.toInt() ?? 0,
      isPinned: json['is_pinned'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'user': instance.user,
      'content': instance.content,
      'media_url': instance.mediaUrl,
      'parent_id': instance.parentId,
      'root_id': instance.rootId,
      'reply_to_user': instance.replyToUser,
      'replies': instance.replies,
      'likes_count': instance.likesCount,
      'is_liked': instance.isLiked,
      'replies_count': instance.repliesCount,
      'depth': instance.depth,
      'is_pinned': instance.isPinned,
      'created_at': instance.createdAt.toIso8601String(),
    };

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: json['id'] as String,
  caption: json['caption'] as String,
  imageUrls: (json['image_urls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  locationName: json['location_name'] as String,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  hashtags: (json['hashtags'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  likesCount: (json['likes_count'] as num).toInt(),
  commentsCount: (json['comments_count'] as num).toInt(),
  sharesCount: (json['shares_count'] as num?)?.toInt() ?? 0,
  isLiked: json['is_liked'] as bool,
  userReaction: json['user_reaction'] as String?,
  isBookmarked: json['is_bookmarked'] as bool? ?? false,
  savedCollectionName: json['saved_collection_name'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  comments: (json['comments'] as List<dynamic>)
      .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caption': instance.caption,
      'image_urls': instance.imageUrls,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location_name': instance.locationName,
      'user': instance.user,
      'hashtags': instance.hashtags,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'shares_count': instance.sharesCount,
      'is_liked': instance.isLiked,
      'user_reaction': instance.userReaction,
      'is_bookmarked': instance.isBookmarked,
      'saved_collection_name': instance.savedCollectionName,
      'created_at': instance.createdAt.toIso8601String(),
      'comments': instance.comments,
    };
