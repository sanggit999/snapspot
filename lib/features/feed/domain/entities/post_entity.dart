import 'package:equatable/equatable.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/feed/domain/entities/comment_entity.dart';

export 'package:snapspot/features/feed/domain/entities/comment_entity.dart';

/// Lớp thực thể đại diện cho một bài viết (Post) địa điểm check-in (Domain Layer).
/// Kết hợp [Equatable] cho Value Equality và [copyWith] cho State Updates.
class PostEntity extends Equatable {
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

  /// Tạo bản sao với một số thuộc tính được thay đổi (Immutable pattern)
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

  @override
  List<Object?> get props => [
        id,
        caption,
        imageUrls,
        latitude,
        longitude,
        locationName,
        user,
        hashtags,
        likesCount,
        commentsCount,
        isLiked,
        createdAt,
        comments,
      ];
}
