import 'package:snapspot/features/auth/data/models/user_model.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Extension Mapper chuyên biệt chuyển đổi giữa [UserModel] (Data Layer)
/// và [UserEntity] (Domain Layer) tuân thủ Clean Architecture & Flutter Code Quality Skill.
extension UserModelMapper on UserModel {
  /// [UserModel] (Data Layer) → [UserEntity] (Domain Layer)
  UserEntity toEntity() {
    return UserEntity(
      id: id.toString(),
      email: email,
      username: username,
      fullName: fullName,
      avatarUrl: avatarUrl,
      bio: bio,
      isPrivate: isPrivate,
      postsCount: postsCount,
      followersCount: followersCount,
      followingCount: followingCount,
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
      isPrivate: isPrivate,
      postsCount: postsCount,
      followersCount: followersCount,
      followingCount: followingCount,
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
