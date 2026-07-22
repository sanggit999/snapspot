import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Model dữ liệu thuần túy (Data Layer).
/// Trách nhiệm duy nhất: ánh xạ JSON ↔ Dart object.
/// Không chứa business logic hay mapper logic.
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    required String fullName,
    @JsonKey(name: 'avatar_url', defaultValue: '') required String avatarUrl,
    @JsonKey(name: 'bio', defaultValue: '') required String bio,
    @JsonKey(name: 'is_private', defaultValue: false) required bool isPrivate,
    @JsonKey(name: 'posts_count', defaultValue: 0) required int postsCount,
    @JsonKey(name: 'followers_count', defaultValue: 0)
    required int followersCount,
    @JsonKey(name: 'following_count', defaultValue: 0)
    required int followingCount,
    @JsonKey(name: 'cover_url', defaultValue: '') @Default('') String coverUrl,
    @JsonKey(name: 'website_url', defaultValue: '') @Default('') String websiteUrl,
    @JsonKey(name: 'location_name', defaultValue: '') @Default('') String locationName,
    @JsonKey(name: 'is_verified', defaultValue: false) @Default(false) bool isVerified,
    @JsonKey(name: 'is_following', defaultValue: false) @Default(false) bool isFollowing,
    @JsonKey(name: 'check_ins_count', defaultValue: 0) @Default(0) int checkInsCount,
    @JsonKey(name: 'phone_number', defaultValue: '') @Default('') String phoneNumber,
    @JsonKey(name: 'is_online', defaultValue: false) @Default(false) bool isOnline,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
