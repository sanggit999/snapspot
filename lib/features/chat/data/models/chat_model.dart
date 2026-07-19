import 'package:snapspot/features/auth/data/models/user_model.dart';
import 'package:snapspot/features/chat/domain/entities/chat_entity.dart';

/// Lớp Model đóng gói dữ liệu của Tin nhắn.
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.content,
    required super.createdAt,
    super.imageUrl,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId:
          json['sender_id'] as String? ?? json['senderId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(
        json['created_at'] as String? ??
            json['createdAt'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }
}

/// Lớp Model đóng gói dữ liệu của Phòng Chat.
class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.partner,
    required super.lastMessage,
    required super.unreadCount,
    required super.messages,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final messagesList = (json['messages'] as List? ?? [])
        .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
        .toList();

    return ChatRoomModel(
      id: json['id'] as String,
      partner: UserModel.fromJson(json['partner'] as Map<String, dynamic>),
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(json['last_message'] as Map<String, dynamic>)
          : (messagesList.isNotEmpty ? messagesList.last : null),
      unreadCount:
          json['unread_count'] as int? ?? json['unreadCount'] as int? ?? 0,
      messages: messagesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner': (partner as UserModel).toJson(),
      'last_message': lastMessage != null
          ? (lastMessage as MessageModel).toJson()
          : null,
      'unread_count': unreadCount,
      'messages': messages.map((m) => (m as MessageModel).toJson()).toList(),
    };
  }
}
