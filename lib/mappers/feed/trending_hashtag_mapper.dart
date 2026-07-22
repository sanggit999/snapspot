import 'package:snapspot/features/feed/data/models/trending_hashtag_model.dart';
import 'package:snapspot/features/feed/domain/entities/trending_hashtag_entity.dart';

/// Mapper chuyên biệt chuyển đổi 2 chiều giữa [TrendingHashtagModel] (Data Layer)
/// và [TrendingHashtagEntity] (Domain Layer).
class TrendingHashtagMapper {
  const TrendingHashtagMapper._();

  /// [TrendingHashtagModel] (Data) → [TrendingHashtagEntity] (Domain)
  static TrendingHashtagEntity toEntity(TrendingHashtagModel model) {
    return TrendingHashtagEntity(
      tagKey: model.tagKey,
      postCount: model.postCount,
      displayLabel: model.displayLabel,
      isRecommended: model.isRecommended,
    );
  }

  /// [TrendingHashtagEntity] (Domain) → [TrendingHashtagModel] (Data)
  static TrendingHashtagModel fromEntity(TrendingHashtagEntity entity) {
    return TrendingHashtagModel(
      tagKey: entity.tagKey,
      postCount: entity.postCount,
      displayLabel: entity.displayLabel,
      isRecommended: entity.isRecommended,
    );
  }

  /// Chuyển đổi danh sách [TrendingHashtagModel] thành danh sách [TrendingHashtagEntity]
  static List<TrendingHashtagEntity> toEntityList(
    List<TrendingHashtagModel> models,
  ) {
    return models.map(toEntity).toList();
  }
}
