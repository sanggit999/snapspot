import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:snapspot/features/auth/data/models/user_model.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

/// Model dữ liệu của Tin nhắn (Data Layer).
/// Trách nhiệm duy nhất: ánh xạ JSON ↔ Dart object.
@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    @JsonKey(name: 'sender_id') required String senderId,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

/// Model dữ liệu của Phòng chat (Data Layer).
/// Trách nhiệm duy nhất: ánh xạ JSON ↔ Dart object.
@freezed
abstract class ChatRoomModel with _$ChatRoomModel {
  const factory ChatRoomModel({
    required String id,
    required UserModel partner,
    @JsonKey(name: 'last_message') MessageModel? lastMessage,
    @JsonKey(name: 'unread_count') required int unreadCount,
    required List<MessageModel> messages,
  }) = _ChatRoomModel;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);
}
