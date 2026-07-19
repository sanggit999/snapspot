/// Thực thể nghiệp vụ đại diện cho một người dùng (User) trong hệ thống SnapSpot.
class UserEntity {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String avatarUrl;
  final String bio;
  final bool isPrivate;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.avatarUrl,
    required this.bio,
    required this.isPrivate,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  /// Tạo bản sao với một số thuộc tính được cập nhật (Immutable pattern)
  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? avatarUrl,
    String? bio,
    bool? isPrivate,
    int? postsCount,
    int? followersCount,
    int? followingCount,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      isPrivate: isPrivate ?? this.isPrivate,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
    );
  }
}
