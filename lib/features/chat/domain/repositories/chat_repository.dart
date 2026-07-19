import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/error/failures.dart';
import 'package:snapspot/features/chat/domain/entities/chat_entity.dart';

/// Giao diện ChatRepository sử dụng lập trình hàm Either.
abstract class ChatRepository {
  /// Lấy danh sách phòng chat hiện tại
  Future<Either<Failure, List<ChatRoomEntity>>> getChatRooms();

  /// Lấy chi tiết cuộc hội thoại trong phòng chat
  Future<Either<Failure, ChatRoomEntity>> getChatRoomDetail(String roomId);

  /// Gửi tin nhắn mới vào phòng chat
  Future<Either<Failure, MessageEntity>> sendMessage(
    String roomId,
    String senderId,
    String content,
  );
}
