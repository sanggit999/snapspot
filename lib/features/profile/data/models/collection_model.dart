import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_model.freezed.dart';
part 'collection_model.g.dart';

/// Model dữ liệu Bộ sưu tập thuần túy (Data Layer).
/// Trách nhiệm duy nhất: Ánh xạ JSON ↔ Dart object với Freezed.
@freezed
abstract class CollectionModel with _$CollectionModel {
  const factory CollectionModel({
    required String id,
    required String name,
    @JsonKey(name: 'icon_name', defaultValue: 'bookmark') required String iconName,
    @JsonKey(name: 'color_hex', defaultValue: '#FF6F61') required String colorHex,
    @JsonKey(name: 'post_count', defaultValue: 0) required int postCount,
    @JsonKey(name: 'is_default', defaultValue: false) required bool isDefault,
    @JsonKey(name: 'is_private', defaultValue: false) required bool isPrivate,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _CollectionModel;

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionModelFromJson(json);
}
