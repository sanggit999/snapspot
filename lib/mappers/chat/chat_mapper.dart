import 'package:snapspot/features/chat/data/models/chat_model.dart';
import 'package:snapspot/features/chat/domain/entities/chat_entity.dart';
import 'package:snapspot/mappers/auth/user_mapper.dart';

/// Mapper chuyển đổi giữa [MessageModel]/[ChatRoomModel] (Data Layer)
/// và [MessageEntity]/[ChatRoomEntity] (Domain Layer).
class MessageMapper {
  const MessageMapper._();

  /// [MessageModel] → [MessageEntity]
  static MessageEntity toEntity(MessageModel model) {
    return MessageEntity(
      id: model.id,
      senderId: model.senderId,
      content: model.content,
      createdAt: model.createdAt,
      imageUrl: model.imageUrl,
    );
  }

  /// [MessageEntity] → [MessageModel]
  static MessageModel fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      senderId: entity.senderId,
      content: entity.content,
      createdAt: entity.createdAt,
      imageUrl: entity.imageUrl,
    );
  }

  /// Chuyển đổi danh sách [MessageModel] → danh sách [MessageEntity]
  static List<MessageEntity> toEntityList(List<MessageModel> models) {
    return models.map(toEntity).toList();
  }
}

/// Mapper chuyển đổi giữa [ChatRoomModel] (Data Layer)
/// và [ChatRoomEntity] (Domain Layer).
class ChatRoomMapper {
  const ChatRoomMapper._();

  /// [ChatRoomModel] → [ChatRoomEntity]
  static ChatRoomEntity toEntity(ChatRoomModel model) {
    final lastMsg = model.lastMessage != null
        ? MessageMapper.toEntity(model.lastMessage!)
        : (model.messages.isNotEmpty
            ? MessageMapper.toEntity(model.messages.last)
            : null);

    return ChatRoomEntity(
      id: model.id,
      partner: UserMapper.toEntity(model.partner),
      lastMessage: lastMsg,
      unreadCount: model.unreadCount,
      messages: MessageMapper.toEntityList(model.messages),
    );
  }

  /// [ChatRoomEntity] → [ChatRoomModel]
  static ChatRoomModel fromEntity(ChatRoomEntity entity) {
    return ChatRoomModel(
      id: entity.id,
      partner: UserMapper.fromEntity(entity.partner),
      lastMessage: entity.lastMessage != null
          ? MessageMapper.fromEntity(entity.lastMessage!)
          : null,
      unreadCount: entity.unreadCount,
      messages: entity.messages.map(MessageMapper.fromEntity).toList(),
    );
  }

  /// Chuyển đổi danh sách [ChatRoomModel] → danh sách [ChatRoomEntity]
  static List<ChatRoomEntity> toEntityList(List<ChatRoomModel> models) {
    return models.map(toEntity).toList();
  }
}
