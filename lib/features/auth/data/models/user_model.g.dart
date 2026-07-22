// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  fullName: json['fullName'] as String,
  avatarUrl: json['avatar_url'] as String? ?? '',
  bio: json['bio'] as String? ?? '',
  isPrivate: json['is_private'] as bool? ?? false,
  postsCount: (json['posts_count'] as num?)?.toInt() ?? 0,
  followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
  followingCount: (json['following_count'] as num?)?.toInt() ?? 0,
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
      'fullName': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'is_private': instance.isPrivate,
      'posts_count': instance.postsCount,
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'cover_url': instance.coverUrl,
      'website_url': instance.websiteUrl,
      'location_name': instance.locationName,
      'is_verified': instance.isVerified,
      'is_following': instance.isFollowing,
      'check_ins_count': instance.checkInsCount,
      'phone_number': instance.phoneNumber,
      'is_online': instance.isOnline,
    };
