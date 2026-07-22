// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trending_hashtag_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendingHashtagModel {

@JsonKey(name: 'tag_key') String get tagKey;@JsonKey(name: 'post_count') int get postCount;@JsonKey(name: 'display_label') String get displayLabel;@JsonKey(name: 'is_recommended') bool get isRecommended;
/// Create a copy of TrendingHashtagModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingHashtagModelCopyWith<TrendingHashtagModel> get copyWith => _$TrendingHashtagModelCopyWithImpl<TrendingHashtagModel>(this as TrendingHashtagModel, _$identity);

  /// Serializes this TrendingHashtagModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingHashtagModel&&(identical(other.tagKey, tagKey) || other.tagKey == tagKey)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel)&&(identical(other.isRecommended, isRecommended) || other.isRecommended == isRecommended));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tagKey,postCount,displayLabel,isRecommended);

@override
String toString() {
  return 'TrendingHashtagModel(tagKey: $tagKey, postCount: $postCount, displayLabel: $displayLabel, isRecommended: $isRecommended)';
}


}

/// @nodoc
abstract mixin class $TrendingHashtagModelCopyWith<$Res>  {
  factory $TrendingHashtagModelCopyWith(TrendingHashtagModel value, $Res Function(TrendingHashtagModel) _then) = _$TrendingHashtagModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tag_key') String tagKey,@JsonKey(name: 'post_count') int postCount,@JsonKey(name: 'display_label') String displayLabel,@JsonKey(name: 'is_recommended') bool isRecommended
});




}
/// @nodoc
class _$TrendingHashtagModelCopyWithImpl<$Res>
    implements $TrendingHashtagModelCopyWith<$Res> {
  _$TrendingHashtagModelCopyWithImpl(this._self, this._then);

  final TrendingHashtagModel _self;
  final $Res Function(TrendingHashtagModel) _then;

/// Create a copy of TrendingHashtagModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagKey = null,Object? postCount = null,Object? displayLabel = null,Object? isRecommended = null,}) {
  return _then(_self.copyWith(
tagKey: null == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,isRecommended: null == isRecommended ? _self.isRecommended : isRecommended // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendingHashtagModel].
extension TrendingHashtagModelPatterns on TrendingHashtagModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendingHashtagModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendingHashtagModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendingHashtagModel value)  $default,){
final _that = this;
switch (_that) {
case _TrendingHashtagModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendingHashtagModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrendingHashtagModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tag_key')  String tagKey, @JsonKey(name: 'post_count')  int postCount, @JsonKey(name: 'display_label')  String displayLabel, @JsonKey(name: 'is_recommended')  bool isRecommended)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendingHashtagModel() when $default != null:
return $default(_that.tagKey,_that.postCount,_that.displayLabel,_that.isRecommended);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tag_key')  String tagKey, @JsonKey(name: 'post_count')  int postCount, @JsonKey(name: 'display_label')  String displayLabel, @JsonKey(name: 'is_recommended')  bool isRecommended)  $default,) {final _that = this;
switch (_that) {
case _TrendingHashtagModel():
return $default(_that.tagKey,_that.postCount,_that.displayLabel,_that.isRecommended);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tag_key')  String tagKey, @JsonKey(name: 'post_count')  int postCount, @JsonKey(name: 'display_label')  String displayLabel, @JsonKey(name: 'is_recommended')  bool isRecommended)?  $default,) {final _that = this;
switch (_that) {
case _TrendingHashtagModel() when $default != null:
return $default(_that.tagKey,_that.postCount,_that.displayLabel,_that.isRecommended);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrendingHashtagModel implements TrendingHashtagModel {
  const _TrendingHashtagModel({@JsonKey(name: 'tag_key') required this.tagKey, @JsonKey(name: 'post_count') required this.postCount, @JsonKey(name: 'display_label') required this.displayLabel, @JsonKey(name: 'is_recommended') this.isRecommended = false});
  factory _TrendingHashtagModel.fromJson(Map<String, dynamic> json) => _$TrendingHashtagModelFromJson(json);

@override@JsonKey(name: 'tag_key') final  String tagKey;
@override@JsonKey(name: 'post_count') final  int postCount;
@override@JsonKey(name: 'display_label') final  String displayLabel;
@override@JsonKey(name: 'is_recommended') final  bool isRecommended;

/// Create a copy of TrendingHashtagModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingHashtagModelCopyWith<_TrendingHashtagModel> get copyWith => __$TrendingHashtagModelCopyWithImpl<_TrendingHashtagModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendingHashtagModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingHashtagModel&&(identical(other.tagKey, tagKey) || other.tagKey == tagKey)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel)&&(identical(other.isRecommended, isRecommended) || other.isRecommended == isRecommended));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tagKey,postCount,displayLabel,isRecommended);

@override
String toString() {
  return 'TrendingHashtagModel(tagKey: $tagKey, postCount: $postCount, displayLabel: $displayLabel, isRecommended: $isRecommended)';
}


}

/// @nodoc
abstract mixin class _$TrendingHashtagModelCopyWith<$Res> implements $TrendingHashtagModelCopyWith<$Res> {
  factory _$TrendingHashtagModelCopyWith(_TrendingHashtagModel value, $Res Function(_TrendingHashtagModel) _then) = __$TrendingHashtagModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tag_key') String tagKey,@JsonKey(name: 'post_count') int postCount,@JsonKey(name: 'display_label') String displayLabel,@JsonKey(name: 'is_recommended') bool isRecommended
});




}
/// @nodoc
class __$TrendingHashtagModelCopyWithImpl<$Res>
    implements _$TrendingHashtagModelCopyWith<$Res> {
  __$TrendingHashtagModelCopyWithImpl(this._self, this._then);

  final _TrendingHashtagModel _self;
  final $Res Function(_TrendingHashtagModel) _then;

/// Create a copy of TrendingHashtagModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagKey = null,Object? postCount = null,Object? displayLabel = null,Object? isRecommended = null,}) {
  return _then(_TrendingHashtagModel(
tagKey: null == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,isRecommended: null == isRecommended ? _self.isRecommended : isRecommended // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
