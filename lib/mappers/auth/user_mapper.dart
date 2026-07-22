import 'package:snapspot/features/auth/data/mappers/user_mapper.dart';
import 'package:snapspot/features/auth/data/models/user_model.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

export 'package:snapspot/features/auth/data/mappers/user_mapper.dart';

/// Class Mapper duy nhất hỗ trợ tương thích mã nguồn cũ
class UserMapper {
  const UserMapper._();

  static UserEntity toEntity(UserModel model) => model.toEntity();
  static UserModel fromEntity(UserEntity entity) => entity.toModel();
  static List<UserEntity> toEntityList(List<UserModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
