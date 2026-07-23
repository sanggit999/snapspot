import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

String _idFromJson(dynamic json) => json?.toString() ?? '';

/// Model dữ liệu thuần túy (Data Layer).
/// Trách nhiệm duy nhất: ánh xạ JSON ↔ Dart object.
/// Bao gồm đầy đủ các trường từ Django REST Backend User Model.
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String email,
    required String username,
    @JsonKey(name: 'full_name', defaultValue: '') @Default('') String fullName,
    @JsonKey(name: 'avatar_url', defaultValue: '') @Default('') String avatarUrl,
    @JsonKey(name: 'bio', defaultValue: '') @Default('') String bio,
    @JsonKey(name: 'auth_provider', defaultValue: 'LOCAL') @Default('LOCAL') String authProvider,
    @JsonKey(name: 'status', defaultValue: 'ACTIVE') @Default('ACTIVE') String status,
    @JsonKey(name: 'email_verified', defaultValue: false) @Default(false) bool emailVerified,
    @JsonKey(name: 'phone_verified', defaultValue: false) @Default(false) bool phoneVerified,
    @JsonKey(name: 'is_2fa_enabled', defaultValue: false) @Default(false) bool is2faEnabled,
    @JsonKey(name: 'is_private', defaultValue: false) @Default(false) bool isPrivate,
    @JsonKey(name: 'hide_exact_location', defaultValue: false) @Default(false) bool hideExactLocation,
    @JsonKey(name: 'posts_count', defaultValue: 0) @Default(0) int postsCount,
    @JsonKey(name: 'followers_count', defaultValue: 0) @Default(0) int followersCount,
    @JsonKey(name: 'following_count', defaultValue: 0) @Default(0) int followingCount,
    @JsonKey(name: 'last_active_at') String? lastActiveAt,
    @JsonKey(name: 'language', defaultValue: 'vi') @Default('vi') String language,
    @JsonKey(name: 'theme_mode', defaultValue: 'system') @Default('system') String themeMode,
    @JsonKey(name: 'created_at') String? createdAt,
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
