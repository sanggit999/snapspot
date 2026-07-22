// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_hashtag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrendingHashtagModel _$TrendingHashtagModelFromJson(
  Map<String, dynamic> json,
) => _TrendingHashtagModel(
  tagKey: json['tag_key'] as String,
  postCount: (json['post_count'] as num).toInt(),
  displayLabel: json['display_label'] as String,
  isRecommended: json['is_recommended'] as bool? ?? false,
);

Map<String, dynamic> _$TrendingHashtagModelToJson(
  _TrendingHashtagModel instance,
) => <String, dynamic>{
  'tag_key': instance.tagKey,
  'post_count': instance.postCount,
  'display_label': instance.displayLabel,
  'is_recommended': instance.isRecommended,
};
