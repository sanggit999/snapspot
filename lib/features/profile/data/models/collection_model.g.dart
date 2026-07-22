// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectionModel _$CollectionModelFromJson(Map<String, dynamic> json) =>
    _CollectionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String? ?? 'bookmark',
      colorHex: json['color_hex'] as String? ?? '#FF6F61',
      postCount: (json['post_count'] as num?)?.toInt() ?? 0,
      isDefault: json['is_default'] as bool? ?? false,
      isPrivate: json['is_private'] as bool? ?? false,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$CollectionModelToJson(_CollectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon_name': instance.iconName,
      'color_hex': instance.colorHex,
      'post_count': instance.postCount,
      'is_default': instance.isDefault,
      'is_private': instance.isPrivate,
      'created_at': instance.createdAt,
    };
