import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Lớp thực thể đại diện cho một bình luận dưới bài đăng.
class CommentEntity {
  final String id;
  final String postId;
  final UserEntity user;
  final String content;
  final String? mediaUrl;
  final String? parentId;
  final List<CommentEntity> replies;
  final int likesCount;
  final bool isLiked;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.user,
    required this.content,
    this.mediaUrl,
    this.parentId,
    this.replies = const [],
    this.likesCount = 0,
    this.isLiked = false,
    required this.createdAt,
  });

  CommentEntity copyWith({
    String? id,
    String? postId,
    UserEntity? user,
    String? content,
    String? mediaUrl,
    String? parentId,
    List<CommentEntity>? replies,
    int? likesCount,
    bool? isLiked,
    DateTime? createdAt,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      user: user ?? this.user,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      parentId: parentId ?? this.parentId,
      replies: replies ?? this.replies,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Lớp thực thể đại diện cho một bài viết (Post) địa điểm check-in.
class PostEntity {
  final String id;
  final String caption;
  final List<String> imageUrls;
  final double latitude;
  final double longitude;
  final String locationName;
  final UserEntity user;
  final List<String> hashtags;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final DateTime createdAt;
  final List<CommentEntity> comments;

  const PostEntity({
    required this.id,
    required this.caption,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.user,
    required this.hashtags,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.createdAt,
    required this.comments,
  });

  /// Tạo bản sao với một số thuộc tính được thay đổi.
  PostEntity copyWith({
    String? id,
    String? caption,
    List<String>? imageUrls,
    double? latitude,
    double? longitude,
    String? locationName,
    UserEntity? user,
    List<String>? hashtags,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    DateTime? createdAt,
    List<CommentEntity>? comments,
  }) {
    return PostEntity(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      imageUrls: imageUrls ?? this.imageUrls,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      user: user ?? this.user,
      hashtags: hashtags ?? this.hashtags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }
}
