import 'package:snapspot/features/auth/data/models/user_model.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Mapper duy nhất chuyển đổi giữa [UserModel] (Data Layer)
/// và [UserEntity] (Domain Layer).
///
/// Nguyên tắc: Mapper phải là các hàm thuần tuý (pure functions) —
/// không chứa side-effects, không phụ thuộc context bên ngoài.
class UserMapper {
  const UserMapper._();

  /// [UserModel] (JSON/API) → [UserEntity] (Domain)
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      username: model.username,
      fullName: model.fullName,
      avatarUrl: model.avatarUrl,
      bio: model.bio,
      isPrivate: model.isPrivate,
      postsCount: model.postsCount,
      followersCount: model.followersCount,
      followingCount: model.followingCount,
    );
  }

  /// [UserEntity] (Domain) → [UserModel] (JSON/API)
  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      isPrivate: entity.isPrivate,
      postsCount: entity.postsCount,
      followersCount: entity.followersCount,
      followingCount: entity.followingCount,
    );
  }

  /// Chuyển đổi một danh sách [UserModel] thành danh sách [UserEntity]
  static List<UserEntity> toEntityList(List<UserModel> models) {
    return models.map(toEntity).toList();
  }
}
