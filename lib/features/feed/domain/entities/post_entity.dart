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
  final int sharesCount; // Số lượt chia sẻ bài viết
  final bool isLiked;
  final String? userReaction; // Emoji cảm xúc người dùng đã thả (❤️, 🔥, 😍, 👏, 📍)
  final bool isBookmarked; // Đã lưu vào bộ sưu tập hay chưa
  final String? savedCollectionName; // Tên bộ sưu tập đã lưu bài viết
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
    this.sharesCount = 0,
    required this.isLiked,
    this.userReaction,
    this.isBookmarked = false,
    this.savedCollectionName,
    required this.createdAt,
    required this.comments,
  });

  /// Getter tiện ích lấy biểu tượng cảm xúc hiển thị của bài viết
  String get displayReaction => userReaction ?? (isLiked ? '❤️' : '');

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
    int? sharesCount,
    bool? isLiked,
    String? userReaction,
    bool? isBookmarked,
    String? savedCollectionName,
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
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      userReaction: userReaction ?? this.userReaction,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      savedCollectionName: savedCollectionName ?? this.savedCollectionName,
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
        sharesCount,
        isLiked,
        userReaction,
        isBookmarked,
        savedCollectionName,
        createdAt,
        comments,
      ];
}
