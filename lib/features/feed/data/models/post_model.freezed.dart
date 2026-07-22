// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentModel {

 String get id;@JsonKey(name: 'post_id') String get postId; UserModel get user; String get content;@JsonKey(name: 'media_url') String? get mediaUrl;@JsonKey(name: 'parent_id') String? get parentId;@JsonKey(name: 'root_id') String? get rootId;@JsonKey(name: 'reply_to_user') UserModel? get replyToUser; List<CommentModel> get replies;@JsonKey(name: 'likes_count') int get likesCount;@JsonKey(name: 'is_liked') bool get isLiked;@JsonKey(name: 'replies_count') int? get repliesCount; int get depth;@JsonKey(name: 'is_pinned') bool get isPinned;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentModelCopyWith<CommentModel> get copyWith => _$CommentModelCopyWithImpl<CommentModel>(this as CommentModel, _$identity);

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.user, user) || other.user == user)&&(identical(other.content, content) || other.content == content)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.rootId, rootId) || other.rootId == rootId)&&(identical(other.replyToUser, replyToUser) || other.replyToUser == replyToUser)&&const DeepCollectionEquality().equals(other.replies, replies)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,user,content,mediaUrl,parentId,rootId,replyToUser,const DeepCollectionEquality().hash(replies),likesCount,isLiked,repliesCount,depth,isPinned,createdAt);

@override
String toString() {
  return 'CommentModel(id: $id, postId: $postId, user: $user, content: $content, mediaUrl: $mediaUrl, parentId: $parentId, rootId: $rootId, replyToUser: $replyToUser, replies: $replies, likesCount: $likesCount, isLiked: $isLiked, repliesCount: $repliesCount, depth: $depth, isPinned: $isPinned, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CommentModelCopyWith<$Res>  {
  factory $CommentModelCopyWith(CommentModel value, $Res Function(CommentModel) _then) = _$CommentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'post_id') String postId, UserModel user, String content,@JsonKey(name: 'media_url') String? mediaUrl,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'root_id') String? rootId,@JsonKey(name: 'reply_to_user') UserModel? replyToUser, List<CommentModel> replies,@JsonKey(name: 'likes_count') int likesCount,@JsonKey(name: 'is_liked') bool isLiked,@JsonKey(name: 'replies_count') int? repliesCount, int depth,@JsonKey(name: 'is_pinned') bool isPinned,@JsonKey(name: 'created_at') DateTime createdAt
});


$UserModelCopyWith<$Res> get user;$UserModelCopyWith<$Res>? get replyToUser;

}
/// @nodoc
class _$CommentModelCopyWithImpl<$Res>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._self, this._then);

  final CommentModel _self;
  final $Res Function(CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? user = null,Object? content = null,Object? mediaUrl = freezed,Object? parentId = freezed,Object? rootId = freezed,Object? replyToUser = freezed,Object? replies = null,Object? likesCount = null,Object? isLiked = null,Object? repliesCount = freezed,Object? depth = null,Object? isPinned = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,rootId: freezed == rootId ? _self.rootId : rootId // ignore: cast_nullable_to_non_nullable
as String?,replyToUser: freezed == replyToUser ? _self.replyToUser : replyToUser // ignore: cast_nullable_to_non_nullable
as UserModel?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,repliesCount: freezed == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int?,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get replyToUser {
    if (_self.replyToUser == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.replyToUser!, (value) {
    return _then(_self.copyWith(replyToUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentModel].
extension CommentModelPatterns on CommentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentModel value)  $default,){
final _that = this;
switch (_that) {
case _CommentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'post_id')  String postId,  UserModel user,  String content, @JsonKey(name: 'media_url')  String? mediaUrl, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'root_id')  String? rootId, @JsonKey(name: 'reply_to_user')  UserModel? replyToUser,  List<CommentModel> replies, @JsonKey(name: 'likes_count')  int likesCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'replies_count')  int? repliesCount,  int depth, @JsonKey(name: 'is_pinned')  bool isPinned, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.postId,_that.user,_that.content,_that.mediaUrl,_that.parentId,_that.rootId,_that.replyToUser,_that.replies,_that.likesCount,_that.isLiked,_that.repliesCount,_that.depth,_that.isPinned,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'post_id')  String postId,  UserModel user,  String content, @JsonKey(name: 'media_url')  String? mediaUrl, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'root_id')  String? rootId, @JsonKey(name: 'reply_to_user')  UserModel? replyToUser,  List<CommentModel> replies, @JsonKey(name: 'likes_count')  int likesCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'replies_count')  int? repliesCount,  int depth, @JsonKey(name: 'is_pinned')  bool isPinned, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CommentModel():
return $default(_that.id,_that.postId,_that.user,_that.content,_that.mediaUrl,_that.parentId,_that.rootId,_that.replyToUser,_that.replies,_that.likesCount,_that.isLiked,_that.repliesCount,_that.depth,_that.isPinned,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'post_id')  String postId,  UserModel user,  String content, @JsonKey(name: 'media_url')  String? mediaUrl, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'root_id')  String? rootId, @JsonKey(name: 'reply_to_user')  UserModel? replyToUser,  List<CommentModel> replies, @JsonKey(name: 'likes_count')  int likesCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'replies_count')  int? repliesCount,  int depth, @JsonKey(name: 'is_pinned')  bool isPinned, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.postId,_that.user,_that.content,_that.mediaUrl,_that.parentId,_that.rootId,_that.replyToUser,_that.replies,_that.likesCount,_that.isLiked,_that.repliesCount,_that.depth,_that.isPinned,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentModel implements CommentModel {
  const _CommentModel({required this.id, @JsonKey(name: 'post_id') required this.postId, required this.user, required this.content, @JsonKey(name: 'media_url') this.mediaUrl, @JsonKey(name: 'parent_id') this.parentId, @JsonKey(name: 'root_id') this.rootId, @JsonKey(name: 'reply_to_user') this.replyToUser, final  List<CommentModel> replies = const [], @JsonKey(name: 'likes_count') this.likesCount = 0, @JsonKey(name: 'is_liked') this.isLiked = false, @JsonKey(name: 'replies_count') this.repliesCount, this.depth = 0, @JsonKey(name: 'is_pinned') this.isPinned = false, @JsonKey(name: 'created_at') required this.createdAt}): _replies = replies;
  factory _CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'post_id') final  String postId;
@override final  UserModel user;
@override final  String content;
@override@JsonKey(name: 'media_url') final  String? mediaUrl;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override@JsonKey(name: 'root_id') final  String? rootId;
@override@JsonKey(name: 'reply_to_user') final  UserModel? replyToUser;
 final  List<CommentModel> _replies;
@override@JsonKey() List<CommentModel> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}

@override@JsonKey(name: 'likes_count') final  int likesCount;
@override@JsonKey(name: 'is_liked') final  bool isLiked;
@override@JsonKey(name: 'replies_count') final  int? repliesCount;
@override@JsonKey() final  int depth;
@override@JsonKey(name: 'is_pinned') final  bool isPinned;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentModelCopyWith<_CommentModel> get copyWith => __$CommentModelCopyWithImpl<_CommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.user, user) || other.user == user)&&(identical(other.content, content) || other.content == content)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.rootId, rootId) || other.rootId == rootId)&&(identical(other.replyToUser, replyToUser) || other.replyToUser == replyToUser)&&const DeepCollectionEquality().equals(other._replies, _replies)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,user,content,mediaUrl,parentId,rootId,replyToUser,const DeepCollectionEquality().hash(_replies),likesCount,isLiked,repliesCount,depth,isPinned,createdAt);

@override
String toString() {
  return 'CommentModel(id: $id, postId: $postId, user: $user, content: $content, mediaUrl: $mediaUrl, parentId: $parentId, rootId: $rootId, replyToUser: $replyToUser, replies: $replies, likesCount: $likesCount, isLiked: $isLiked, repliesCount: $repliesCount, depth: $depth, isPinned: $isPinned, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CommentModelCopyWith<$Res> implements $CommentModelCopyWith<$Res> {
  factory _$CommentModelCopyWith(_CommentModel value, $Res Function(_CommentModel) _then) = __$CommentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'post_id') String postId, UserModel user, String content,@JsonKey(name: 'media_url') String? mediaUrl,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'root_id') String? rootId,@JsonKey(name: 'reply_to_user') UserModel? replyToUser, List<CommentModel> replies,@JsonKey(name: 'likes_count') int likesCount,@JsonKey(name: 'is_liked') bool isLiked,@JsonKey(name: 'replies_count') int? repliesCount, int depth,@JsonKey(name: 'is_pinned') bool isPinned,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $UserModelCopyWith<$Res> get user;@override $UserModelCopyWith<$Res>? get replyToUser;

}
/// @nodoc
class __$CommentModelCopyWithImpl<$Res>
    implements _$CommentModelCopyWith<$Res> {
  __$CommentModelCopyWithImpl(this._self, this._then);

  final _CommentModel _self;
  final $Res Function(_CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? user = null,Object? content = null,Object? mediaUrl = freezed,Object? parentId = freezed,Object? rootId = freezed,Object? replyToUser = freezed,Object? replies = null,Object? likesCount = null,Object? isLiked = null,Object? repliesCount = freezed,Object? depth = null,Object? isPinned = null,Object? createdAt = null,}) {
  return _then(_CommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,rootId: freezed == rootId ? _self.rootId : rootId // ignore: cast_nullable_to_non_nullable
as String?,replyToUser: freezed == replyToUser ? _self.replyToUser : replyToUser // ignore: cast_nullable_to_non_nullable
as UserModel?,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,repliesCount: freezed == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int?,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get replyToUser {
    if (_self.replyToUser == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.replyToUser!, (value) {
    return _then(_self.copyWith(replyToUser: value));
  });
}
}


/// @nodoc
mixin _$PostModel {

 String get id; String get caption;@JsonKey(name: 'image_urls') List<String> get imageUrls; double get latitude; double get longitude;@JsonKey(name: 'location_name') String get locationName; UserModel get user; List<String> get hashtags;@JsonKey(name: 'likes_count') int get likesCount;@JsonKey(name: 'comments_count') int get commentsCount;@JsonKey(name: 'shares_count') int get sharesCount;@JsonKey(name: 'is_liked') bool get isLiked;@JsonKey(name: 'user_reaction') String? get userReaction;@JsonKey(name: 'is_bookmarked') bool get isBookmarked;@JsonKey(name: 'saved_collection_name') String? get savedCollectionName;@JsonKey(name: 'created_at') DateTime get createdAt; List<CommentModel> get comments;
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostModelCopyWith<PostModel> get copyWith => _$PostModelCopyWithImpl<PostModel>(this as PostModel, _$identity);

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.caption, caption) || other.caption == caption)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.hashtags, hashtags)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.sharesCount, sharesCount) || other.sharesCount == sharesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.userReaction, userReaction) || other.userReaction == userReaction)&&(identical(other.isBookmarked, isBookmarked) || other.isBookmarked == isBookmarked)&&(identical(other.savedCollectionName, savedCollectionName) || other.savedCollectionName == savedCollectionName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.comments, comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,caption,const DeepCollectionEquality().hash(imageUrls),latitude,longitude,locationName,user,const DeepCollectionEquality().hash(hashtags),likesCount,commentsCount,sharesCount,isLiked,userReaction,isBookmarked,savedCollectionName,createdAt,const DeepCollectionEquality().hash(comments));

@override
String toString() {
  return 'PostModel(id: $id, caption: $caption, imageUrls: $imageUrls, latitude: $latitude, longitude: $longitude, locationName: $locationName, user: $user, hashtags: $hashtags, likesCount: $likesCount, commentsCount: $commentsCount, sharesCount: $sharesCount, isLiked: $isLiked, userReaction: $userReaction, isBookmarked: $isBookmarked, savedCollectionName: $savedCollectionName, createdAt: $createdAt, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $PostModelCopyWith<$Res>  {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) _then) = _$PostModelCopyWithImpl;
@useResult
$Res call({
 String id, String caption,@JsonKey(name: 'image_urls') List<String> imageUrls, double latitude, double longitude,@JsonKey(name: 'location_name') String locationName, UserModel user, List<String> hashtags,@JsonKey(name: 'likes_count') int likesCount,@JsonKey(name: 'comments_count') int commentsCount,@JsonKey(name: 'shares_count') int sharesCount,@JsonKey(name: 'is_liked') bool isLiked,@JsonKey(name: 'user_reaction') String? userReaction,@JsonKey(name: 'is_bookmarked') bool isBookmarked,@JsonKey(name: 'saved_collection_name') String? savedCollectionName,@JsonKey(name: 'created_at') DateTime createdAt, List<CommentModel> comments
});


$UserModelCopyWith<$Res> get user;

}
/// @nodoc
class _$PostModelCopyWithImpl<$Res>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._self, this._then);

  final PostModel _self;
  final $Res Function(PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? caption = null,Object? imageUrls = null,Object? latitude = null,Object? longitude = null,Object? locationName = null,Object? user = null,Object? hashtags = null,Object? likesCount = null,Object? commentsCount = null,Object? sharesCount = null,Object? isLiked = null,Object? userReaction = freezed,Object? isBookmarked = null,Object? savedCollectionName = freezed,Object? createdAt = null,Object? comments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,hashtags: null == hashtags ? _self.hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,sharesCount: null == sharesCount ? _self.sharesCount : sharesCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,userReaction: freezed == userReaction ? _self.userReaction : userReaction // ignore: cast_nullable_to_non_nullable
as String?,isBookmarked: null == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool,savedCollectionName: freezed == savedCollectionName ? _self.savedCollectionName : savedCollectionName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,
  ));
}
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostModel].
extension PostModelPatterns on PostModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostModel value)  $default,){
final _that = this;
switch (_that) {
case _PostModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String caption, @JsonKey(name: 'image_urls')  List<String> imageUrls,  double latitude,  double longitude, @JsonKey(name: 'location_name')  String locationName,  UserModel user,  List<String> hashtags, @JsonKey(name: 'likes_count')  int likesCount, @JsonKey(name: 'comments_count')  int commentsCount, @JsonKey(name: 'shares_count')  int sharesCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'user_reaction')  String? userReaction, @JsonKey(name: 'is_bookmarked')  bool isBookmarked, @JsonKey(name: 'saved_collection_name')  String? savedCollectionName, @JsonKey(name: 'created_at')  DateTime createdAt,  List<CommentModel> comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.caption,_that.imageUrls,_that.latitude,_that.longitude,_that.locationName,_that.user,_that.hashtags,_that.likesCount,_that.commentsCount,_that.sharesCount,_that.isLiked,_that.userReaction,_that.isBookmarked,_that.savedCollectionName,_that.createdAt,_that.comments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String caption, @JsonKey(name: 'image_urls')  List<String> imageUrls,  double latitude,  double longitude, @JsonKey(name: 'location_name')  String locationName,  UserModel user,  List<String> hashtags, @JsonKey(name: 'likes_count')  int likesCount, @JsonKey(name: 'comments_count')  int commentsCount, @JsonKey(name: 'shares_count')  int sharesCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'user_reaction')  String? userReaction, @JsonKey(name: 'is_bookmarked')  bool isBookmarked, @JsonKey(name: 'saved_collection_name')  String? savedCollectionName, @JsonKey(name: 'created_at')  DateTime createdAt,  List<CommentModel> comments)  $default,) {final _that = this;
switch (_that) {
case _PostModel():
return $default(_that.id,_that.caption,_that.imageUrls,_that.latitude,_that.longitude,_that.locationName,_that.user,_that.hashtags,_that.likesCount,_that.commentsCount,_that.sharesCount,_that.isLiked,_that.userReaction,_that.isBookmarked,_that.savedCollectionName,_that.createdAt,_that.comments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String caption, @JsonKey(name: 'image_urls')  List<String> imageUrls,  double latitude,  double longitude, @JsonKey(name: 'location_name')  String locationName,  UserModel user,  List<String> hashtags, @JsonKey(name: 'likes_count')  int likesCount, @JsonKey(name: 'comments_count')  int commentsCount, @JsonKey(name: 'shares_count')  int sharesCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'user_reaction')  String? userReaction, @JsonKey(name: 'is_bookmarked')  bool isBookmarked, @JsonKey(name: 'saved_collection_name')  String? savedCollectionName, @JsonKey(name: 'created_at')  DateTime createdAt,  List<CommentModel> comments)?  $default,) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.caption,_that.imageUrls,_that.latitude,_that.longitude,_that.locationName,_that.user,_that.hashtags,_that.likesCount,_that.commentsCount,_that.sharesCount,_that.isLiked,_that.userReaction,_that.isBookmarked,_that.savedCollectionName,_that.createdAt,_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostModel implements PostModel {
  const _PostModel({required this.id, required this.caption, @JsonKey(name: 'image_urls') required final  List<String> imageUrls, required this.latitude, required this.longitude, @JsonKey(name: 'location_name') required this.locationName, required this.user, required final  List<String> hashtags, @JsonKey(name: 'likes_count') required this.likesCount, @JsonKey(name: 'comments_count') required this.commentsCount, @JsonKey(name: 'shares_count') this.sharesCount = 0, @JsonKey(name: 'is_liked') required this.isLiked, @JsonKey(name: 'user_reaction') this.userReaction, @JsonKey(name: 'is_bookmarked') this.isBookmarked = false, @JsonKey(name: 'saved_collection_name') this.savedCollectionName, @JsonKey(name: 'created_at') required this.createdAt, required final  List<CommentModel> comments}): _imageUrls = imageUrls,_hashtags = hashtags,_comments = comments;
  factory _PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

@override final  String id;
@override final  String caption;
 final  List<String> _imageUrls;
@override@JsonKey(name: 'image_urls') List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  double latitude;
@override final  double longitude;
@override@JsonKey(name: 'location_name') final  String locationName;
@override final  UserModel user;
 final  List<String> _hashtags;
@override List<String> get hashtags {
  if (_hashtags is EqualUnmodifiableListView) return _hashtags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hashtags);
}

@override@JsonKey(name: 'likes_count') final  int likesCount;
@override@JsonKey(name: 'comments_count') final  int commentsCount;
@override@JsonKey(name: 'shares_count') final  int sharesCount;
@override@JsonKey(name: 'is_liked') final  bool isLiked;
@override@JsonKey(name: 'user_reaction') final  String? userReaction;
@override@JsonKey(name: 'is_bookmarked') final  bool isBookmarked;
@override@JsonKey(name: 'saved_collection_name') final  String? savedCollectionName;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
 final  List<CommentModel> _comments;
@override List<CommentModel> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}


/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostModelCopyWith<_PostModel> get copyWith => __$PostModelCopyWithImpl<_PostModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.caption, caption) || other.caption == caption)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._hashtags, _hashtags)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.sharesCount, sharesCount) || other.sharesCount == sharesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.userReaction, userReaction) || other.userReaction == userReaction)&&(identical(other.isBookmarked, isBookmarked) || other.isBookmarked == isBookmarked)&&(identical(other.savedCollectionName, savedCollectionName) || other.savedCollectionName == savedCollectionName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._comments, _comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,caption,const DeepCollectionEquality().hash(_imageUrls),latitude,longitude,locationName,user,const DeepCollectionEquality().hash(_hashtags),likesCount,commentsCount,sharesCount,isLiked,userReaction,isBookmarked,savedCollectionName,createdAt,const DeepCollectionEquality().hash(_comments));

@override
String toString() {
  return 'PostModel(id: $id, caption: $caption, imageUrls: $imageUrls, latitude: $latitude, longitude: $longitude, locationName: $locationName, user: $user, hashtags: $hashtags, likesCount: $likesCount, commentsCount: $commentsCount, sharesCount: $sharesCount, isLiked: $isLiked, userReaction: $userReaction, isBookmarked: $isBookmarked, savedCollectionName: $savedCollectionName, createdAt: $createdAt, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$PostModelCopyWith<$Res> implements $PostModelCopyWith<$Res> {
  factory _$PostModelCopyWith(_PostModel value, $Res Function(_PostModel) _then) = __$PostModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String caption,@JsonKey(name: 'image_urls') List<String> imageUrls, double latitude, double longitude,@JsonKey(name: 'location_name') String locationName, UserModel user, List<String> hashtags,@JsonKey(name: 'likes_count') int likesCount,@JsonKey(name: 'comments_count') int commentsCount,@JsonKey(name: 'shares_count') int sharesCount,@JsonKey(name: 'is_liked') bool isLiked,@JsonKey(name: 'user_reaction') String? userReaction,@JsonKey(name: 'is_bookmarked') bool isBookmarked,@JsonKey(name: 'saved_collection_name') String? savedCollectionName,@JsonKey(name: 'created_at') DateTime createdAt, List<CommentModel> comments
});


@override $UserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$PostModelCopyWithImpl<$Res>
    implements _$PostModelCopyWith<$Res> {
  __$PostModelCopyWithImpl(this._self, this._then);

  final _PostModel _self;
  final $Res Function(_PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? caption = null,Object? imageUrls = null,Object? latitude = null,Object? longitude = null,Object? locationName = null,Object? user = null,Object? hashtags = null,Object? likesCount = null,Object? commentsCount = null,Object? sharesCount = null,Object? isLiked = null,Object? userReaction = freezed,Object? isBookmarked = null,Object? savedCollectionName = freezed,Object? createdAt = null,Object? comments = null,}) {
  return _then(_PostModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,hashtags: null == hashtags ? _self._hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,sharesCount: null == sharesCount ? _self.sharesCount : sharesCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,userReaction: freezed == userReaction ? _self.userReaction : userReaction // ignore: cast_nullable_to_non_nullable
as String?,isBookmarked: null == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool,savedCollectionName: freezed == savedCollectionName ? _self.savedCollectionName : savedCollectionName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,
  ));
}

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
