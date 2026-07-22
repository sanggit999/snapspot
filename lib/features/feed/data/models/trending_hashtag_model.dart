import 'package:freezed_annotation/freezed_annotation.dart';

part 'trending_hashtag_model.freezed.dart';
part 'trending_hashtag_model.g.dart';

/// Model dữ liệu của Hashtag Xu Hướng (Data Layer).
/// Trách nhiệm duy nhất: ánh xạ JSON ↔ Dart object khi kết nối Backend REST API.
@freezed
abstract class TrendingHashtagModel with _$TrendingHashtagModel {
  const factory TrendingHashtagModel({
    @JsonKey(name: 'tag_key') required String tagKey,
    @JsonKey(name: 'post_count') required int postCount,
    @JsonKey(name: 'display_label') required String displayLabel,
    @JsonKey(name: 'is_recommended') @Default(false) bool isRecommended,
  }) = _TrendingHashtagModel;

  factory TrendingHashtagModel.fromJson(Map<String, dynamic> json) =>
      _$TrendingHashtagModelFromJson(json);
}
