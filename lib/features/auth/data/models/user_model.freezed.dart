// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get email; String get username; String get fullName;@JsonKey(name: 'avatar_url', defaultValue: '') String get avatarUrl;@JsonKey(name: 'bio', defaultValue: '') String get bio;@JsonKey(name: 'is_private', defaultValue: false) bool get isPrivate;@JsonKey(name: 'posts_count', defaultValue: 0) int get postsCount;@JsonKey(name: 'followers_count', defaultValue: 0) int get followersCount;@JsonKey(name: 'following_count', defaultValue: 0) int get followingCount;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,fullName,avatarUrl,bio,isPrivate,postsCount,followersCount,followingCount);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, bio: $bio, isPrivate: $isPrivate, postsCount: $postsCount, followersCount: $followersCount, followingCount: $followingCount)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String username, String fullName,@JsonKey(name: 'avatar_url', defaultValue: '') String avatarUrl,@JsonKey(name: 'bio', defaultValue: '') String bio,@JsonKey(name: 'is_private', defaultValue: false) bool isPrivate,@JsonKey(name: 'posts_count', defaultValue: 0) int postsCount,@JsonKey(name: 'followers_count', defaultValue: 0) int followersCount,@JsonKey(name: 'following_count', defaultValue: 0) int followingCount
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = null,Object? fullName = null,Object? avatarUrl = null,Object? bio = null,Object? isPrivate = null,Object? postsCount = null,Object? followersCount = null,Object? followingCount = null,}) {
  return _then(UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String username,  String fullName, @JsonKey(name: 'avatar_url', defaultValue: '')  String avatarUrl, @JsonKey(name: 'bio', defaultValue: '')  String bio, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'posts_count', defaultValue: 0)  int postsCount, @JsonKey(name: 'followers_count', defaultValue: 0)  int followersCount, @JsonKey(name: 'following_count', defaultValue: 0)  int followingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.avatarUrl,_that.bio,_that.isPrivate,_that.postsCount,_that.followersCount,_that.followingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String username,  String fullName, @JsonKey(name: 'avatar_url', defaultValue: '')  String avatarUrl, @JsonKey(name: 'bio', defaultValue: '')  String bio, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'posts_count', defaultValue: 0)  int postsCount, @JsonKey(name: 'followers_count', defaultValue: 0)  int followersCount, @JsonKey(name: 'following_count', defaultValue: 0)  int followingCount)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.avatarUrl,_that.bio,_that.isPrivate,_that.postsCount,_that.followersCount,_that.followingCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String username,  String fullName, @JsonKey(name: 'avatar_url', defaultValue: '')  String avatarUrl, @JsonKey(name: 'bio', defaultValue: '')  String bio, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'posts_count', defaultValue: 0)  int postsCount, @JsonKey(name: 'followers_count', defaultValue: 0)  int followersCount, @JsonKey(name: 'following_count', defaultValue: 0)  int followingCount)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.avatarUrl,_that.bio,_that.isPrivate,_that.postsCount,_that.followersCount,_that.followingCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.email, required this.username, required this.fullName, @JsonKey(name: 'avatar_url', defaultValue: '') required this.avatarUrl, @JsonKey(name: 'bio', defaultValue: '') required this.bio, @JsonKey(name: 'is_private', defaultValue: false) required this.isPrivate, @JsonKey(name: 'posts_count', defaultValue: 0) required this.postsCount, @JsonKey(name: 'followers_count', defaultValue: 0) required this.followersCount, @JsonKey(name: 'following_count', defaultValue: 0) required this.followingCount});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String username;
@override final  String fullName;
@override@JsonKey(name: 'avatar_url', defaultValue: '') final  String avatarUrl;
@override@JsonKey(name: 'bio', defaultValue: '') final  String bio;
@override@JsonKey(name: 'is_private', defaultValue: false) final  bool isPrivate;
@override@JsonKey(name: 'posts_count', defaultValue: 0) final  int postsCount;
@override@JsonKey(name: 'followers_count', defaultValue: 0) final  int followersCount;
@override@JsonKey(name: 'following_count', defaultValue: 0) final  int followingCount;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,fullName,avatarUrl,bio,isPrivate,postsCount,followersCount,followingCount);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, bio: $bio, isPrivate: $isPrivate, postsCount: $postsCount, followersCount: $followersCount, followingCount: $followingCount)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String username, String fullName,@JsonKey(name: 'avatar_url', defaultValue: '') String avatarUrl,@JsonKey(name: 'bio', defaultValue: '') String bio,@JsonKey(name: 'is_private', defaultValue: false) bool isPrivate,@JsonKey(name: 'posts_count', defaultValue: 0) int postsCount,@JsonKey(name: 'followers_count', defaultValue: 0) int followersCount,@JsonKey(name: 'following_count', defaultValue: 0) int followingCount
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = null,Object? fullName = null,Object? avatarUrl = null,Object? bio = null,Object? isPrivate = null,Object? postsCount = null,Object? followersCount = null,Object? followingCount = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
