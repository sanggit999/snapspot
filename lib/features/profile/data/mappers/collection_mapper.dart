import 'package:snapspot/features/profile/data/models/collection_model.dart';
import 'package:snapspot/features/profile/domain/entities/collection_entity.dart';

/// Mapper tập trung ánh xạ giữa [CollectionModel] và [CollectionEntity].
class CollectionMapper {
  /// Chuyển từ Model (Data Layer) sang Entity (Domain Layer)
  static CollectionEntity toEntity(CollectionModel model) {
    return CollectionEntity(
      id: model.id,
      name: model.name,
      iconName: model.iconName,
      colorHex: model.colorHex,
      postCount: model.postCount,
      isDefault: model.isDefault,
      isPrivate: model.isPrivate,
      createdAt: DateTime.tryParse(model.createdAt) ?? DateTime.now(),
    );
  }

  /// Chuyển từ Entity (Domain Layer) sang Model (Data Layer)
  static CollectionModel toModel(CollectionEntity entity) {
    return CollectionModel(
      id: entity.id,
      name: entity.name,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      postCount: entity.postCount,
      isDefault: entity.isDefault,
      isPrivate: entity.isPrivate,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
