import 'package:fpdart/fpdart.dart';
import 'package:snapspot/core/error/failures.dart';
import 'package:snapspot/core/network/mock_data.dart';
import 'package:snapspot/features/chat/domain/entities/chat_entity.dart';
import 'package:snapspot/features/chat/domain/repositories/chat_repository.dart';

/// Triển khai ChatRepositoryImpl sử dụng fpdart Either.
/// MockData.mockChatRooms đã là [List<ChatRoomEntity>] nên thao tác trực tiếp.
class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<Either<Failure, List<ChatRoomEntity>>> getChatRooms() async {
    try {
      await Future.delayed(const Duration(milliseconds: 350));
      return Right(List<ChatRoomEntity>.from(MockData.mockChatRooms));
    } catch (e) {
      return Left(ServerFailure('Lỗi tải danh sách phòng chat: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatRoomEntity>> getChatRoomDetail(
    String roomId,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final idx = MockData.mockChatRooms.indexWhere((r) => r.id == roomId);
      if (idx != -1) {
        // Đánh dấu đã đọc -> unreadCount = 0
        final updatedRoom = MockData.mockChatRooms[idx].copyWith(unreadCount: 0);
        MockData.mockChatRooms[idx] = updatedRoom;
        return Right(updatedRoom);
      }
      throw Exception('Phòng chat không tồn tại');
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(
    String roomId,
    String senderId,
    String content,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final newMessage = MessageEntity(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: senderId,
        content: content.trim(),
        createdAt: DateTime.now(),
      );

      final idx = MockData.mockChatRooms.indexWhere((r) => r.id == roomId);
      if (idx != -1) {
        final room = MockData.mockChatRooms[idx];
        final updatedMessages = List<MessageEntity>.from(room.messages)
          ..add(newMessage);
        final updatedRoom = room.copyWith(
          messages: updatedMessages,
          lastMessage: newMessage,
        );
        MockData.mockChatRooms[idx] = updatedRoom;
        return Right(newMessage);
      }
      throw Exception('Phòng chat không tồn tại');
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
