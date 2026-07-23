// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

@JsonKey(fromJson: _idFromJson) String get id; String get email; String get username;@JsonKey(name: 'full_name', defaultValue: '') String get fullName;@JsonKey(name: 'avatar_url', defaultValue: '') String get avatarUrl;@JsonKey(name: 'bio', defaultValue: '') String get bio;@JsonKey(name: 'auth_provider', defaultValue: 'LOCAL') String get authProvider;@JsonKey(name: 'status', defaultValue: 'ACTIVE') String get status;@JsonKey(name: 'email_verified', defaultValue: false) bool get emailVerified;@JsonKey(name: 'phone_verified', defaultValue: false) bool get phoneVerified;@JsonKey(name: 'is_2fa_enabled', defaultValue: false) bool get is2faEnabled;@JsonKey(name: 'is_private', defaultValue: false) bool get isPrivate;@JsonKey(name: 'hide_exact_location', defaultValue: false) bool get hideExactLocation;@JsonKey(name: 'posts_count', defaultValue: 0) int get postsCount;@JsonKey(name: 'followers_count', defaultValue: 0) int get followersCount;@JsonKey(name: 'following_count', defaultValue: 0) int get followingCount;@JsonKey(name: 'last_active_at') String? get lastActiveAt;@JsonKey(name: 'language', defaultValue: 'vi') String get language;@JsonKey(name: 'theme_mode', defaultValue: 'system') String get themeMode;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'cover_url', defaultValue: '') String get coverUrl;@JsonKey(name: 'website_url', defaultValue: '') String get websiteUrl;@JsonKey(name: 'location_name', defaultValue: '') String get locationName;@JsonKey(name: 'is_verified', defaultValue: false) bool get isVerified;@JsonKey(name: 'is_following', defaultValue: false) bool get isFollowing;@JsonKey(name: 'check_ins_count', defaultValue: 0) int get checkInsCount;@JsonKey(name: 'phone_number', defaultValue: '') String get phoneNumber;@JsonKey(name: 'is_online', defaultValue: false) bool get isOnline;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.authProvider, authProvider) || other.authProvider == authProvider)&&(identical(other.status, status) || other.status == status)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.phoneVerified, phoneVerified) || other.phoneVerified == phoneVerified)&&(identical(other.is2faEnabled, is2faEnabled) || other.is2faEnabled == is2faEnabled)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.hideExactLocation, hideExactLocation) || other.hideExactLocation == hideExactLocation)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.language, language) || other.language == language)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.checkInsCount, checkInsCount) || other.checkInsCount == checkInsCount)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,username,fullName,avatarUrl,bio,authProvider,status,emailVerified,phoneVerified,is2faEnabled,isPrivate,hideExactLocation,postsCount,followersCount,followingCount,lastActiveAt,language,themeMode,createdAt,coverUrl,websiteUrl,locationName,isVerified,isFollowing,checkInsCount,phoneNumber,isOnline]);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, bio: $bio, authProvider: $authProvider, status: $status, emailVerified: $emailVerified, phoneVerified: $phoneVerified, is2faEnabled: $is2faEnabled, isPrivate: $isPrivate, hideExactLocation: $hideExactLocation, postsCount: $postsCount, followersCount: $followersCount, followingCount: $followingCount, lastActiveAt: $lastActiveAt, language: $language, themeMode: $themeMode, createdAt: $createdAt, coverUrl: $coverUrl, websiteUrl: $websiteUrl, locationName: $locationName, isVerified: $isVerified, isFollowing: $isFollowing, checkInsCount: $checkInsCount, phoneNumber: $phoneNumber, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, String email, String username,@JsonKey(name: 'full_name', defaultValue: '') String fullName,@JsonKey(name: 'avatar_url', defaultValue: '') String avatarUrl,@JsonKey(name: 'bio', defaultValue: '') String bio,@JsonKey(name: 'auth_provider', defaultValue: 'LOCAL') String authProvider,@JsonKey(name: 'status', defaultValue: 'ACTIVE') String status,@JsonKey(name: 'email_verified', defaultValue: false) bool emailVerified,@JsonKey(name: 'phone_verified', defaultValue: false) bool phoneVerified,@JsonKey(name: 'is_2fa_enabled', defaultValue: false) bool is2faEnabled,@JsonKey(name: 'is_private', defaultValue: false) bool isPrivate,@JsonKey(name: 'hide_exact_location', defaultValue: false) bool hideExactLocation,@JsonKey(name: 'posts_count', defaultValue: 0) int postsCount,@JsonKey(name: 'followers_count', defaultValue: 0) int followersCount,@JsonKey(name: 'following_count', defaultValue: 0) int followingCount,@JsonKey(name: 'last_active_at') String? lastActiveAt,@JsonKey(name: 'language', defaultValue: 'vi') String language,@JsonKey(name: 'theme_mode', defaultValue: 'system') String themeMode,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'cover_url', defaultValue: '') String coverUrl,@JsonKey(name: 'website_url', defaultValue: '') String websiteUrl,@JsonKey(name: 'location_name', defaultValue: '') String locationName,@JsonKey(name: 'is_verified', defaultValue: false) bool isVerified,@JsonKey(name: 'is_following', defaultValue: false) bool isFollowing,@JsonKey(name: 'check_ins_count', defaultValue: 0) int checkInsCount,@JsonKey(name: 'phone_number', defaultValue: '') String phoneNumber,@JsonKey(name: 'is_online', defaultValue: false) bool isOnline
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = null,Object? fullName = null,Object? avatarUrl = null,Object? bio = null,Object? authProvider = null,Object? status = null,Object? emailVerified = null,Object? phoneVerified = null,Object? is2faEnabled = null,Object? isPrivate = null,Object? hideExactLocation = null,Object? postsCount = null,Object? followersCount = null,Object? followingCount = null,Object? lastActiveAt = freezed,Object? language = null,Object? themeMode = null,Object? createdAt = freezed,Object? coverUrl = null,Object? websiteUrl = null,Object? locationName = null,Object? isVerified = null,Object? isFollowing = null,Object? checkInsCount = null,Object? phoneNumber = null,Object? isOnline = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,authProvider: null == authProvider ? _self.authProvider : authProvider // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,phoneVerified: null == phoneVerified ? _self.phoneVerified : phoneVerified // ignore: cast_nullable_to_non_nullable
as bool,is2faEnabled: null == is2faEnabled ? _self.is2faEnabled : is2faEnabled // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,hideExactLocation: null == hideExactLocation ? _self.hideExactLocation : hideExactLocation // ignore: cast_nullable_to_non_nullable
as bool,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: null == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,checkInsCount: null == checkInsCount ? _self.checkInsCount : checkInsCount // ignore: cast_nullable_to_non_nullable
as int,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  String email,  String username, @JsonKey(name: 'full_name', defaultValue: '')  String fullName, @JsonKey(name: 'avatar_url', defaultValue: '')  String avatarUrl, @JsonKey(name: 'bio', defaultValue: '')  String bio, @JsonKey(name: 'auth_provider', defaultValue: 'LOCAL')  String authProvider, @JsonKey(name: 'status', defaultValue: 'ACTIVE')  String status, @JsonKey(name: 'email_verified', defaultValue: false)  bool emailVerified, @JsonKey(name: 'phone_verified', defaultValue: false)  bool phoneVerified, @JsonKey(name: 'is_2fa_enabled', defaultValue: false)  bool is2faEnabled, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'hide_exact_location', defaultValue: false)  bool hideExactLocation, @JsonKey(name: 'posts_count', defaultValue: 0)  int postsCount, @JsonKey(name: 'followers_count', defaultValue: 0)  int followersCount, @JsonKey(name: 'following_count', defaultValue: 0)  int followingCount, @JsonKey(name: 'last_active_at')  String? lastActiveAt, @JsonKey(name: 'language', defaultValue: 'vi')  String language, @JsonKey(name: 'theme_mode', defaultValue: 'system')  String themeMode, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'cover_url', defaultValue: '')  String coverUrl, @JsonKey(name: 'website_url', defaultValue: '')  String websiteUrl, @JsonKey(name: 'location_name', defaultValue: '')  String locationName, @JsonKey(name: 'is_verified', defaultValue: false)  bool isVerified, @JsonKey(name: 'is_following', defaultValue: false)  bool isFollowing, @JsonKey(name: 'check_ins_count', defaultValue: 0)  int checkInsCount, @JsonKey(name: 'phone_number', defaultValue: '')  String phoneNumber, @JsonKey(name: 'is_online', defaultValue: false)  bool isOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.avatarUrl,_that.bio,_that.authProvider,_that.status,_that.emailVerified,_that.phoneVerified,_that.is2faEnabled,_that.isPrivate,_that.hideExactLocation,_that.postsCount,_that.followersCount,_that.followingCount,_that.lastActiveAt,_that.language,_that.themeMode,_that.createdAt,_that.coverUrl,_that.websiteUrl,_that.locationName,_that.isVerified,_that.isFollowing,_that.checkInsCount,_that.phoneNumber,_that.isOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  String email,  String username, @JsonKey(name: 'full_name', defaultValue: '')  String fullName, @JsonKey(name: 'avatar_url', defaultValue: '')  String avatarUrl, @JsonKey(name: 'bio', defaultValue: '')  String bio, @JsonKey(name: 'auth_provider', defaultValue: 'LOCAL')  String authProvider, @JsonKey(name: 'status', defaultValue: 'ACTIVE')  String status, @JsonKey(name: 'email_verified', defaultValue: false)  bool emailVerified, @JsonKey(name: 'phone_verified', defaultValue: false)  bool phoneVerified, @JsonKey(name: 'is_2fa_enabled', defaultValue: false)  bool is2faEnabled, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'hide_exact_location', defaultValue: false)  bool hideExactLocation, @JsonKey(name: 'posts_count', defaultValue: 0)  int postsCount, @JsonKey(name: 'followers_count', defaultValue: 0)  int followersCount, @JsonKey(name: 'following_count', defaultValue: 0)  int followingCount, @JsonKey(name: 'last_active_at')  String? lastActiveAt, @JsonKey(name: 'language', defaultValue: 'vi')  String language, @JsonKey(name: 'theme_mode', defaultValue: 'system')  String themeMode, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'cover_url', defaultValue: '')  String coverUrl, @JsonKey(name: 'website_url', defaultValue: '')  String websiteUrl, @JsonKey(name: 'location_name', defaultValue: '')  String locationName, @JsonKey(name: 'is_verified', defaultValue: false)  bool isVerified, @JsonKey(name: 'is_following', defaultValue: false)  bool isFollowing, @JsonKey(name: 'check_ins_count', defaultValue: 0)  int checkInsCount, @JsonKey(name: 'phone_number', defaultValue: '')  String phoneNumber, @JsonKey(name: 'is_online', defaultValue: false)  bool isOnline)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.avatarUrl,_that.bio,_that.authProvider,_that.status,_that.emailVerified,_that.phoneVerified,_that.is2faEnabled,_that.isPrivate,_that.hideExactLocation,_that.postsCount,_that.followersCount,_that.followingCount,_that.lastActiveAt,_that.language,_that.themeMode,_that.createdAt,_that.coverUrl,_that.websiteUrl,_that.locationName,_that.isVerified,_that.isFollowing,_that.checkInsCount,_that.phoneNumber,_that.isOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id,  String email,  String username, @JsonKey(name: 'full_name', defaultValue: '')  String fullName, @JsonKey(name: 'avatar_url', defaultValue: '')  String avatarUrl, @JsonKey(name: 'bio', defaultValue: '')  String bio, @JsonKey(name: 'auth_provider', defaultValue: 'LOCAL')  String authProvider, @JsonKey(name: 'status', defaultValue: 'ACTIVE')  String status, @JsonKey(name: 'email_verified', defaultValue: false)  bool emailVerified, @JsonKey(name: 'phone_verified', defaultValue: false)  bool phoneVerified, @JsonKey(name: 'is_2fa_enabled', defaultValue: false)  bool is2faEnabled, @JsonKey(name: 'is_private', defaultValue: false)  bool isPrivate, @JsonKey(name: 'hide_exact_location', defaultValue: false)  bool hideExactLocation, @JsonKey(name: 'posts_count', defaultValue: 0)  int postsCount, @JsonKey(name: 'followers_count', defaultValue: 0)  int followersCount, @JsonKey(name: 'following_count', defaultValue: 0)  int followingCount, @JsonKey(name: 'last_active_at')  String? lastActiveAt, @JsonKey(name: 'language', defaultValue: 'vi')  String language, @JsonKey(name: 'theme_mode', defaultValue: 'system')  String themeMode, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'cover_url', defaultValue: '')  String coverUrl, @JsonKey(name: 'website_url', defaultValue: '')  String websiteUrl, @JsonKey(name: 'location_name', defaultValue: '')  String locationName, @JsonKey(name: 'is_verified', defaultValue: false)  bool isVerified, @JsonKey(name: 'is_following', defaultValue: false)  bool isFollowing, @JsonKey(name: 'check_ins_count', defaultValue: 0)  int checkInsCount, @JsonKey(name: 'phone_number', defaultValue: '')  String phoneNumber, @JsonKey(name: 'is_online', defaultValue: false)  bool isOnline)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.fullName,_that.avatarUrl,_that.bio,_that.authProvider,_that.status,_that.emailVerified,_that.phoneVerified,_that.is2faEnabled,_that.isPrivate,_that.hideExactLocation,_that.postsCount,_that.followersCount,_that.followingCount,_that.lastActiveAt,_that.language,_that.themeMode,_that.createdAt,_that.coverUrl,_that.websiteUrl,_that.locationName,_that.isVerified,_that.isFollowing,_that.checkInsCount,_that.phoneNumber,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({@JsonKey(fromJson: _idFromJson) required this.id, required this.email, required this.username, @JsonKey(name: 'full_name', defaultValue: '') this.fullName = '', @JsonKey(name: 'avatar_url', defaultValue: '') this.avatarUrl = '', @JsonKey(name: 'bio', defaultValue: '') this.bio = '', @JsonKey(name: 'auth_provider', defaultValue: 'LOCAL') this.authProvider = 'LOCAL', @JsonKey(name: 'status', defaultValue: 'ACTIVE') this.status = 'ACTIVE', @JsonKey(name: 'email_verified', defaultValue: false) this.emailVerified = false, @JsonKey(name: 'phone_verified', defaultValue: false) this.phoneVerified = false, @JsonKey(name: 'is_2fa_enabled', defaultValue: false) this.is2faEnabled = false, @JsonKey(name: 'is_private', defaultValue: false) this.isPrivate = false, @JsonKey(name: 'hide_exact_location', defaultValue: false) this.hideExactLocation = false, @JsonKey(name: 'posts_count', defaultValue: 0) this.postsCount = 0, @JsonKey(name: 'followers_count', defaultValue: 0) this.followersCount = 0, @JsonKey(name: 'following_count', defaultValue: 0) this.followingCount = 0, @JsonKey(name: 'last_active_at') this.lastActiveAt, @JsonKey(name: 'language', defaultValue: 'vi') this.language = 'vi', @JsonKey(name: 'theme_mode', defaultValue: 'system') this.themeMode = 'system', @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'cover_url', defaultValue: '') this.coverUrl = '', @JsonKey(name: 'website_url', defaultValue: '') this.websiteUrl = '', @JsonKey(name: 'location_name', defaultValue: '') this.locationName = '', @JsonKey(name: 'is_verified', defaultValue: false) this.isVerified = false, @JsonKey(name: 'is_following', defaultValue: false) this.isFollowing = false, @JsonKey(name: 'check_ins_count', defaultValue: 0) this.checkInsCount = 0, @JsonKey(name: 'phone_number', defaultValue: '') this.phoneNumber = '', @JsonKey(name: 'is_online', defaultValue: false) this.isOnline = false});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override final  String email;
@override final  String username;
@override@JsonKey(name: 'full_name', defaultValue: '') final  String fullName;
@override@JsonKey(name: 'avatar_url', defaultValue: '') final  String avatarUrl;
@override@JsonKey(name: 'bio', defaultValue: '') final  String bio;
@override@JsonKey(name: 'auth_provider', defaultValue: 'LOCAL') final  String authProvider;
@override@JsonKey(name: 'status', defaultValue: 'ACTIVE') final  String status;
@override@JsonKey(name: 'email_verified', defaultValue: false) final  bool emailVerified;
@override@JsonKey(name: 'phone_verified', defaultValue: false) final  bool phoneVerified;
@override@JsonKey(name: 'is_2fa_enabled', defaultValue: false) final  bool is2faEnabled;
@override@JsonKey(name: 'is_private', defaultValue: false) final  bool isPrivate;
@override@JsonKey(name: 'hide_exact_location', defaultValue: false) final  bool hideExactLocation;
@override@JsonKey(name: 'posts_count', defaultValue: 0) final  int postsCount;
@override@JsonKey(name: 'followers_count', defaultValue: 0) final  int followersCount;
@override@JsonKey(name: 'following_count', defaultValue: 0) final  int followingCount;
@override@JsonKey(name: 'last_active_at') final  String? lastActiveAt;
@override@JsonKey(name: 'language', defaultValue: 'vi') final  String language;
@override@JsonKey(name: 'theme_mode', defaultValue: 'system') final  String themeMode;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'cover_url', defaultValue: '') final  String coverUrl;
@override@JsonKey(name: 'website_url', defaultValue: '') final  String websiteUrl;
@override@JsonKey(name: 'location_name', defaultValue: '') final  String locationName;
@override@JsonKey(name: 'is_verified', defaultValue: false) final  bool isVerified;
@override@JsonKey(name: 'is_following', defaultValue: false) final  bool isFollowing;
@override@JsonKey(name: 'check_ins_count', defaultValue: 0) final  int checkInsCount;
@override@JsonKey(name: 'phone_number', defaultValue: '') final  String phoneNumber;
@override@JsonKey(name: 'is_online', defaultValue: false) final  bool isOnline;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.authProvider, authProvider) || other.authProvider == authProvider)&&(identical(other.status, status) || other.status == status)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.phoneVerified, phoneVerified) || other.phoneVerified == phoneVerified)&&(identical(other.is2faEnabled, is2faEnabled) || other.is2faEnabled == is2faEnabled)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.hideExactLocation, hideExactLocation) || other.hideExactLocation == hideExactLocation)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.language, language) || other.language == language)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.checkInsCount, checkInsCount) || other.checkInsCount == checkInsCount)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,username,fullName,avatarUrl,bio,authProvider,status,emailVerified,phoneVerified,is2faEnabled,isPrivate,hideExactLocation,postsCount,followersCount,followingCount,lastActiveAt,language,themeMode,createdAt,coverUrl,websiteUrl,locationName,isVerified,isFollowing,checkInsCount,phoneNumber,isOnline]);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, bio: $bio, authProvider: $authProvider, status: $status, emailVerified: $emailVerified, phoneVerified: $phoneVerified, is2faEnabled: $is2faEnabled, isPrivate: $isPrivate, hideExactLocation: $hideExactLocation, postsCount: $postsCount, followersCount: $followersCount, followingCount: $followingCount, lastActiveAt: $lastActiveAt, language: $language, themeMode: $themeMode, createdAt: $createdAt, coverUrl: $coverUrl, websiteUrl: $websiteUrl, locationName: $locationName, isVerified: $isVerified, isFollowing: $isFollowing, checkInsCount: $checkInsCount, phoneNumber: $phoneNumber, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, String email, String username,@JsonKey(name: 'full_name', defaultValue: '') String fullName,@JsonKey(name: 'avatar_url', defaultValue: '') String avatarUrl,@JsonKey(name: 'bio', defaultValue: '') String bio,@JsonKey(name: 'auth_provider', defaultValue: 'LOCAL') String authProvider,@JsonKey(name: 'status', defaultValue: 'ACTIVE') String status,@JsonKey(name: 'email_verified', defaultValue: false) bool emailVerified,@JsonKey(name: 'phone_verified', defaultValue: false) bool phoneVerified,@JsonKey(name: 'is_2fa_enabled', defaultValue: false) bool is2faEnabled,@JsonKey(name: 'is_private', defaultValue: false) bool isPrivate,@JsonKey(name: 'hide_exact_location', defaultValue: false) bool hideExactLocation,@JsonKey(name: 'posts_count', defaultValue: 0) int postsCount,@JsonKey(name: 'followers_count', defaultValue: 0) int followersCount,@JsonKey(name: 'following_count', defaultValue: 0) int followingCount,@JsonKey(name: 'last_active_at') String? lastActiveAt,@JsonKey(name: 'language', defaultValue: 'vi') String language,@JsonKey(name: 'theme_mode', defaultValue: 'system') String themeMode,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'cover_url', defaultValue: '') String coverUrl,@JsonKey(name: 'website_url', defaultValue: '') String websiteUrl,@JsonKey(name: 'location_name', defaultValue: '') String locationName,@JsonKey(name: 'is_verified', defaultValue: false) bool isVerified,@JsonKey(name: 'is_following', defaultValue: false) bool isFollowing,@JsonKey(name: 'check_ins_count', defaultValue: 0) int checkInsCount,@JsonKey(name: 'phone_number', defaultValue: '') String phoneNumber,@JsonKey(name: 'is_online', defaultValue: false) bool isOnline
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = null,Object? fullName = null,Object? avatarUrl = null,Object? bio = null,Object? authProvider = null,Object? status = null,Object? emailVerified = null,Object? phoneVerified = null,Object? is2faEnabled = null,Object? isPrivate = null,Object? hideExactLocation = null,Object? postsCount = null,Object? followersCount = null,Object? followingCount = null,Object? lastActiveAt = freezed,Object? language = null,Object? themeMode = null,Object? createdAt = freezed,Object? coverUrl = null,Object? websiteUrl = null,Object? locationName = null,Object? isVerified = null,Object? isFollowing = null,Object? checkInsCount = null,Object? phoneNumber = null,Object? isOnline = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,authProvider: null == authProvider ? _self.authProvider : authProvider // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,phoneVerified: null == phoneVerified ? _self.phoneVerified : phoneVerified // ignore: cast_nullable_to_non_nullable
as bool,is2faEnabled: null == is2faEnabled ? _self.is2faEnabled : is2faEnabled // ignore: cast_nullable_to_non_nullable
as bool,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,hideExactLocation: null == hideExactLocation ? _self.hideExactLocation : hideExactLocation // ignore: cast_nullable_to_non_nullable
as bool,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: null == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,checkInsCount: null == checkInsCount ? _self.checkInsCount : checkInsCount // ignore: cast_nullable_to_non_nullable
as int,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
