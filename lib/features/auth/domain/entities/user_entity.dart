import 'package:equatable/equatable.dart';

/// Thực thể nghiệp vụ đại diện cho một người dùng (User) trong hệ thống SnapSpot.
/// Kết hợp [Equatable] cho Value Equality (tránh rebuild UI lãng phí)
/// và phương thức [copyWith] cho Immutability State Updates.
class UserEntity extends Equatable {
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
  final String coverUrl;
  final String websiteUrl;
  final String locationName;
  final bool isVerified;
  final bool isFollowing;
  final int checkInsCount;
  final String phoneNumber;
  final bool isOnline;

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
    this.coverUrl = '',
    this.websiteUrl = '',
    this.locationName = '',
    this.isVerified = false,
    this.isFollowing = false,
    this.checkInsCount = 0,
    this.phoneNumber = '',
    this.isOnline = false,
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
    String? coverUrl,
    String? websiteUrl,
    String? locationName,
    bool? isVerified,
    bool? isFollowing,
    int? checkInsCount,
    String? phoneNumber,
    bool? isOnline,
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
      coverUrl: coverUrl ?? this.coverUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      locationName: locationName ?? this.locationName,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      checkInsCount: checkInsCount ?? this.checkInsCount,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        fullName,
        avatarUrl,
        bio,
        isPrivate,
        postsCount,
        followersCount,
        followingCount,
        coverUrl,
        websiteUrl,
        locationName,
        isVerified,
        isFollowing,
        checkInsCount,
        phoneNumber,
        isOnline,
      ];
}
