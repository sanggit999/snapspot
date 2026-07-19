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
    };
