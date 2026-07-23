// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: _idFromJson(json['id']),
  email: json['email'] as String,
  username: json['username'] as String,
  fullName: json['full_name'] as String? ?? '',
  avatarUrl: json['avatar_url'] as String? ?? '',
  bio: json['bio'] as String? ?? '',
  authProvider: json['auth_provider'] as String? ?? 'LOCAL',
  status: json['status'] as String? ?? 'ACTIVE',
  emailVerified: json['email_verified'] as bool? ?? false,
  phoneVerified: json['phone_verified'] as bool? ?? false,
  is2faEnabled: json['is_2fa_enabled'] as bool? ?? false,
  isPrivate: json['is_private'] as bool? ?? false,
  hideExactLocation: json['hide_exact_location'] as bool? ?? false,
  postsCount: (json['posts_count'] as num?)?.toInt() ?? 0,
  followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
  followingCount: (json['following_count'] as num?)?.toInt() ?? 0,
  lastActiveAt: json['last_active_at'] as String?,
  language: json['language'] as String? ?? 'vi',
  themeMode: json['theme_mode'] as String? ?? 'system',
  createdAt: json['created_at'] as String?,
  coverUrl: json['cover_url'] as String? ?? '',
  websiteUrl: json['website_url'] as String? ?? '',
  locationName: json['location_name'] as String? ?? '',
  isVerified: json['is_verified'] as bool? ?? false,
  isFollowing: json['is_following'] as bool? ?? false,
  checkInsCount: (json['check_ins_count'] as num?)?.toInt() ?? 0,
  phoneNumber: json['phone_number'] as String? ?? '',
  isOnline: json['is_online'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'auth_provider': instance.authProvider,
      'status': instance.status,
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
      'is_2fa_enabled': instance.is2faEnabled,
      'is_private': instance.isPrivate,
      'hide_exact_location': instance.hideExactLocation,
      'posts_count': instance.postsCount,
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'last_active_at': instance.lastActiveAt,
      'language': instance.language,
      'theme_mode': instance.themeMode,
      'created_at': instance.createdAt,
      'cover_url': instance.coverUrl,
      'website_url': instance.websiteUrl,
      'location_name': instance.locationName,
      'is_verified': instance.isVerified,
      'is_following': instance.isFollowing,
      'check_ins_count': instance.checkInsCount,
      'phone_number': instance.phoneNumber,
      'is_online': instance.isOnline,
    };
