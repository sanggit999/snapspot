// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollectionModel {

 String get id; String get name;@JsonKey(name: 'icon_name', defaultValue: 'bookmark') String get iconName;@JsonKey(name: 'color_hex', defaultValue: '#FF6F61') String get colorHex;@JsonKey(name: 'post_count', defaultValue: 0) int get postCount;@JsonKey(name: 'is_default', defaultValue: false) bool get isDefault;@JsonKey(name: 'is_private', defaultValue: false) bool get isPrivate;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of CollectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionModelCopyWith<CollectionModel> get copyWith => _$CollectionModelCopyWithImpl<CollectionModel>(this as CollectionModel, _$identity);

  /// Serializes this CollectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,iconName,colorHex,postCount,isDefault,isPrivate,createdAt);

@override
String toString() {
  return 'CollectionModel(id: $id, name: $name, iconName: $iconName, colorHex: $colorHex, postCount: $postCount, isDefault: $isDefault, isPrivate: $isPrivate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CollectionModelCopyWith<$Res>  {
  factory $CollectionModelCopyWith(CollectionModel value, $Res Function(CollectionModel) _then) = _$CollectionModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'icon_name', defaultValue: 'bookmark') String iconName,@JsonKey(name: 'color_hex', defaultValue: '#FF6F61') String colorHex,@JsonKey(name: 'post_count', defaultValue: 0) int postCount,@JsonKey(name: 'is_default', defaultValue: false) bool isDefault,@JsonKey(name: 'is_private', defaultValue: false) bool isPrivate,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$CollectionModelCopyWithImpl<$Res>
    implements $CollectionModelCopyWith<$Res> {
  _$CollectionModelCopyWithImpl(this._self, this._then);

  final CollectionModel _self;
  final $Res Function(CollectionModel) _then;

/// Create a copy of CollectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? iconName = null,Object? colorHex = null,Object? postCount = null,Object? isDefault = null,Object? isPrivate = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionModel].
extension CollectionModelPatterns on CollectionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionModel value)  $default,){
final _that = this;
switch (_that) {
case _CollectionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'icon_name', defaultValue: 'bookmark')  String iconName, @JsonKey(name: 'color_hex', defaultValue: '#FF6F61')  String colorHex, @JsonKey(name: 'post_count', defaultValue: 0)  int postCount, @JsonKey(name: 'is_default', defaultValue: false)  bool isDefault, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionModel() when $default != null:
return $default(_that.id,_that.name,_that.iconName,_that.colorHex,_that.postCount,_that.isDefault,_that.isPrivate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'icon_name', defaultValue: 'bookmark')  String iconName, @JsonKey(name: 'color_hex', defaultValue: '#FF6F61')  String colorHex, @JsonKey(name: 'post_count', defaultValue: 0)  int postCount, @JsonKey(name: 'is_default', defaultValue: false)  bool isDefault, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _CollectionModel():
return $default(_that.id,_that.name,_that.iconName,_that.colorHex,_that.postCount,_that.isDefault,_that.isPrivate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'icon_name', defaultValue: 'bookmark')  String iconName, @JsonKey(name: 'color_hex', defaultValue: '#FF6F61')  String colorHex, @JsonKey(name: 'post_count', defaultValue: 0)  int postCount, @JsonKey(name: 'is_default', defaultValue: false)  bool isDefault, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CollectionModel() when $default != null:
return $default(_that.id,_that.name,_that.iconName,_that.colorHex,_that.postCount,_that.isDefault,_that.isPrivate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectionModel implements CollectionModel {
  const _CollectionModel({required this.id, required this.name, @JsonKey(name: 'icon_name', defaultValue: 'bookmark') required this.iconName, @JsonKey(name: 'color_hex', defaultValue: '#FF6F61') required this.colorHex, @JsonKey(name: 'post_count', defaultValue: 0) required this.postCount, @JsonKey(name: 'is_default', defaultValue: false) required this.isDefault, @JsonKey(name: 'is_private', defaultValue: false) required this.isPrivate, @JsonKey(name: 'created_at') required this.createdAt});
  factory _CollectionModel.fromJson(Map<String, dynamic> json) => _$CollectionModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'icon_name', defaultValue: 'bookmark') final  String iconName;
@override@JsonKey(name: 'color_hex', defaultValue: '#FF6F61') final  String colorHex;
@override@JsonKey(name: 'post_count', defaultValue: 0) final  int postCount;
@override@JsonKey(name: 'is_default', defaultValue: false) final  bool isDefault;
@override@JsonKey(name: 'is_private', defaultValue: false) final  bool isPrivate;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of CollectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionModelCopyWith<_CollectionModel> get copyWith => __$CollectionModelCopyWithImpl<_CollectionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,iconName,colorHex,postCount,isDefault,isPrivate,createdAt);

@override
String toString() {
  return 'CollectionModel(id: $id, name: $name, iconName: $iconName, colorHex: $colorHex, postCount: $postCount, isDefault: $isDefault, isPrivate: $isPrivate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CollectionModelCopyWith<$Res> implements $CollectionModelCopyWith<$Res> {
  factory _$CollectionModelCopyWith(_CollectionModel value, $Res Function(_CollectionModel) _then) = __$CollectionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'icon_name', defaultValue: 'bookmark') String iconName,@JsonKey(name: 'color_hex', defaultValue: '#FF6F61') String colorHex,@JsonKey(name: 'post_count', defaultValue: 0) int postCount,@JsonKey(name: 'is_default', defaultValue: false) bool isDefault,@JsonKey(name: 'is_private', defaultValue: false) bool isPrivate,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$CollectionModelCopyWithImpl<$Res>
    implements _$CollectionModelCopyWith<$Res> {
  __$CollectionModelCopyWithImpl(this._self, this._then);

  final _CollectionModel _self;
  final $Res Function(_CollectionModel) _then;

/// Create a copy of CollectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? iconName = null,Object? colorHex = null,Object? postCount = null,Object? isDefault = null,Object? isPrivate = null,Object? createdAt = null,}) {
  return _then(_CollectionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
