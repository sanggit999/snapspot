import 'package:snapspot/features/auth/data/models/user_model.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Extension Mapper chuyên biệt chuyển đổi giữa [UserModel] (Data Layer)
/// và [UserEntity] (Domain Layer) tuân thủ Clean Architecture & Flutter Code Quality Skill.
extension UserModelMapper on UserModel {
  /// [UserModel] (Data Layer) → [UserEntity] (Domain Layer)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      fullName: fullName,
      avatarUrl: avatarUrl,
      bio: bio,
      authProvider: authProvider,
      status: status,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      is2faEnabled: is2faEnabled,
      isPrivate: isPrivate,
      hideExactLocation: hideExactLocation,
      postsCount: postsCount,
      followersCount: followersCount,
      followingCount: followingCount,
      lastActiveAt: lastActiveAt,
      language: language,
      themeMode: themeMode,
      createdAt: createdAt,
      coverUrl: coverUrl,
      websiteUrl: websiteUrl,
      locationName: locationName,
      isVerified: isVerified,
      isFollowing: isFollowing,
      checkInsCount: checkInsCount,
      phoneNumber: phoneNumber,
      isOnline: isOnline,
    );
  }
}

extension UserEntityMapper on UserEntity {
  /// [UserEntity] (Domain Layer) → [UserModel] (Data Layer)
  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      username: username,
      fullName: fullName,
      avatarUrl: avatarUrl,
      bio: bio,
      authProvider: authProvider,
      status: status,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      is2faEnabled: is2faEnabled,
      isPrivate: isPrivate,
      hideExactLocation: hideExactLocation,
      postsCount: postsCount,
      followersCount: followersCount,
      followingCount: followingCount,
      lastActiveAt: lastActiveAt,
      language: language,
      themeMode: themeMode,
      createdAt: createdAt,
      coverUrl: coverUrl,
      websiteUrl: websiteUrl,
      locationName: locationName,
      isVerified: isVerified,
      isFollowing: isFollowing,
      checkInsCount: checkInsCount,
      phoneNumber: phoneNumber,
      isOnline: isOnline,
    );
  }
}
