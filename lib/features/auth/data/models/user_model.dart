import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Lớp Model đóng gói dữ liệu của người dùng, kế thừa từ [UserEntity].
/// Cung cấp các phương thức serialization và deserialization JSON.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.fullName,
    required super.avatarUrl,
    required super.bio,
    required super.isPrivate,
    required super.postsCount,
    required super.followersCount,
    required super.followingCount,
  });

  /// Chuyển đổi dữ liệu JSON từ API thành đối tượng [UserModel]
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String? ?? json['username'] as String,
      avatarUrl:
          json['avatar_url'] as String? ?? json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      isPrivate:
          json['is_private'] as bool? ?? json['isPrivate'] as bool? ?? false,
      postsCount:
          json['posts_count'] as int? ?? json['postsCount'] as int? ?? 0,
      followersCount:
          json['followers_count'] as int? ??
          json['followersCount'] as int? ??
          0,
      followingCount:
          json['following_count'] as int? ??
          json['followingCount'] as int? ??
          0,
    );
  }

  /// Chuyển đối tượng [UserModel] thành dữ liệu JSON gửi lên API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'fullName': fullName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'is_private': isPrivate,
      'posts_count': postsCount,
      'followers_count': followersCount,
      'following_count': followingCount,
    };
  }
}
