import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:snapspot/features/auth/data/models/user_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Model dữ liệu của Bình luận (Data Layer).
/// Trách nhiệm duy nhất: ánh xạ JSON ↔ Dart object.
@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    @JsonKey(name: 'post_id') required String postId,
    required UserModel user,
    required String content,
    @JsonKey(name: 'media_url') String? mediaUrl,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'root_id') String? rootId,
    @JsonKey(name: 'reply_to_user') UserModel? replyToUser,
    @Default([]) List<CommentModel> replies,
    @JsonKey(name: 'likes_count') @Default(0) int likesCount,
    @JsonKey(name: 'is_liked') @Default(false) bool isLiked,
    @JsonKey(name: 'replies_count') int? repliesCount,
    @Default(0) int depth,
    @JsonKey(name: 'is_pinned') @Default(false) bool isPinned,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

/// Model dữ liệu của Bài viết (Data Layer).
/// Trách nhiệm duy nhất: ánh xạ JSON ↔ Dart object.
@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String caption,
    @JsonKey(name: 'image_urls') required List<String> imageUrls,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'location_name') required String locationName,
    required UserModel user,
    required List<String> hashtags,
    @JsonKey(name: 'likes_count') required int likesCount,
    @JsonKey(name: 'comments_count') required int commentsCount,
    @JsonKey(name: 'is_liked') required bool isLiked,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required List<CommentModel> comments,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
