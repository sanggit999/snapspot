import 'package:equatable/equatable.dart';

/// Thực thể nghiệp vụ đại diện cho một người dùng (User) trong hệ thống SnapSpot.
/// Đã được đồng bộ 100% các trường với Backend Django User Model.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String avatarUrl;
  final String bio;
  final String authProvider;
  final String status;
  final bool emailVerified;
  final bool phoneVerified;
  final bool is2faEnabled;
  final bool isPrivate;
  final bool hideExactLocation;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final String? lastActiveAt;
  final String language;
  final String themeMode;
  final String? createdAt;
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
    this.authProvider = 'LOCAL',
    this.status = 'ACTIVE',
    this.emailVerified = false,
    this.phoneVerified = false,
    this.is2faEnabled = false,
    required this.isPrivate,
    this.hideExactLocation = false,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    this.lastActiveAt,
    this.language = 'vi',
    this.themeMode = 'system',
    this.createdAt,
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
    String? authProvider,
    String? status,
    bool? emailVerified,
    bool? phoneVerified,
    bool? is2faEnabled,
    bool? isPrivate,
    bool? hideExactLocation,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    String? lastActiveAt,
    String? language,
    String? themeMode,
    String? createdAt,
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
      authProvider: authProvider ?? this.authProvider,
      status: status ?? this.status,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      is2faEnabled: is2faEnabled ?? this.is2faEnabled,
      isPrivate: isPrivate ?? this.isPrivate,
      hideExactLocation: hideExactLocation ?? this.hideExactLocation,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      createdAt: createdAt ?? this.createdAt,
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
        authProvider,
        status,
        emailVerified,
        phoneVerified,
        is2faEnabled,
        isPrivate,
        hideExactLocation,
        postsCount,
        followersCount,
        followingCount,
        lastActiveAt,
        language,
        themeMode,
        createdAt,
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
