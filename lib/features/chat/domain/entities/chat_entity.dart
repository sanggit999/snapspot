import 'package:equatable/equatable.dart';
import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

/// Lớp thực thể đại diện cho một Tin nhắn (Message) (Domain Layer).
/// Kết hợp [Equatable] cho Value Equality.
class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final String? imageUrl;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        content,
        createdAt,
        imageUrl,
      ];
}

/// Lớp thực thể đại diện cho một Phòng Chat (ChatRoom) (Domain Layer).
/// Kết hợp [Equatable] cho Value Equality và [copyWith] cho State Updates.
class ChatRoomEntity extends Equatable {
  final String id;
  final UserEntity partner;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final List<MessageEntity> messages;

  const ChatRoomEntity({
    required this.id,
    required this.partner,
    required this.lastMessage,
    required this.unreadCount,
    required this.messages,
  });

  /// Tạo bản sao phòng chat với thuộc tính mới (Immutable pattern)
  ChatRoomEntity copyWith({
    String? id,
    UserEntity? partner,
    MessageEntity? lastMessage,
    int? unreadCount,
    List<MessageEntity>? messages,
  }) {
    return ChatRoomEntity(
      id: id ?? this.id,
      partner: partner ?? this.partner,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        id,
        partner,
        lastMessage,
        unreadCount,
        messages,
      ];
}
