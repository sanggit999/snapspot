import 'package:snapspot/features/auth/data/models/user_model.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';

/// Lớp Model đóng gói dữ liệu của Bình luận.
class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.user,
    required super.content,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String? ?? json['postId'] as String? ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      createdAt: DateTime.parse(
        json['created_at'] as String? ??
            json['createdAt'] as String? ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user': (user as UserModel).toJson(),
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Lớp Model đóng gói dữ liệu của Bài viết, kế thừa từ [PostEntity].
class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.caption,
    required super.imageUrls,
    required super.latitude,
    required super.longitude,
    required super.locationName,
    required super.user,
    required super.hashtags,
    required super.likesCount,
    required super.commentsCount,
    required super.isLiked,
    required super.createdAt,
    required super.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      caption: json['caption'] as String? ?? '',
      imageUrls: List<String>.from(
        json['image_urls'] as List? ?? json['imageUrls'] as List? ?? [],
      ),
      latitude: (json['latitude'] as num? ?? 0.0).toDouble(),
      longitude: (json['longitude'] as num? ?? 0.0).toDouble(),
      locationName:
          json['location_name'] as String? ??
          json['locationName'] as String? ??
          '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      hashtags: List<String>.from(json['hashtags'] as List? ?? []),
      likesCount:
          json['likes_count'] as int? ?? json['likesCount'] as int? ?? 0,
      commentsCount:
          json['comments_count'] as int? ?? json['commentsCount'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? json['isLiked'] as bool? ?? false,
      createdAt: DateTime.parse(
        json['created_at'] as String? ??
            json['createdAt'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      comments: (json['comments'] as List? ?? [])
          .map((c) => CommentModel.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caption': caption,
      'image_urls': imageUrls,
      'latitude': latitude,
      'longitude': longitude,
      'location_name': locationName,
      'user': (user as UserModel).toJson(),
      'hashtags': hashtags,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'is_liked': isLiked,
      'created_at': createdAt.toIso8601String(),
      'comments': comments.map((c) => (c as CommentModel).toJson()).toList(),
    };
  }
}
