import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/features/chat/domain/entities/chat_entity.dart';
import 'package:snapspot/features/chat/domain/repositories/chat_repository.dart';

// --- STATES ---
class ChatState {
  final List<ChatRoomEntity> rooms;
  final ChatRoomEntity? activeRoom;
  final bool isLoading;
  final bool isTyping;

  const ChatState({
    required this.rooms,
    this.activeRoom,
    required this.isLoading,
    this.isTyping = false,
  });

  ChatState copyWith({
    List<ChatRoomEntity>? rooms,
    ChatRoomEntity? activeRoom,
    bool? isLoading,
    bool? isTyping,
  }) {
    return ChatState(
      rooms: rooms ?? this.rooms,
      activeRoom: activeRoom ?? this.activeRoom,
      isLoading: isLoading ?? this.isLoading,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

// --- CUBIT ---
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  ChatCubit(this._chatRepository)
      : super(const ChatState(rooms: [], isLoading: false));

  /// Tải danh sách phòng chat
  Future<void> fetchRooms() async {
    emit(state.copyWith(isLoading: true));
    final result = await _chatRepository.getChatRooms();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (rooms) => emit(ChatState(rooms: rooms, isLoading: false)),
    );
  }

  /// Đi vào chi tiết một phòng chat và đánh dấu đã đọc
  Future<void> enterRoom(String roomId) async {
    emit(state.copyWith(isLoading: true));
    final detailResult = await _chatRepository.getChatRoomDetail(roomId);
    detailResult.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (updatedRoom) async {
        final roomsResult = await _chatRepository.getChatRooms();
        roomsResult.fold(
          (failure) => emit(state.copyWith(isLoading: false)),
          (rooms) => emit(
            ChatState(
              rooms: rooms,
              activeRoom: updatedRoom,
              isLoading: false,
            ),
          ),
        );
      },
    );
  }

  /// Thoát khỏi phòng chat
  void leaveRoom() {
    emit(state.copyWith(activeRoom: null));
  }

  /// Gửi tin nhắn mới trong phòng chat.
  /// Hỗ trợ giả lập kết nối WebSocket và sinh tin nhắn phản hồi tự động sau 2 giây.
  Future<void> sendMessage(String roomId, String text, String senderId) async {
    if (text.trim().isEmpty || state.activeRoom == null) return;

    final result = await _chatRepository.sendMessage(roomId, senderId, text);
    result.fold(
      (failure) => null,
      (sentMessage) async {
        final currentRoom = state.activeRoom!;
        final updatedMessages = List<MessageEntity>.from(currentRoom.messages)
          ..add(sentMessage);
        final updatedRoom = currentRoom.copyWith(
          messages: updatedMessages,
          lastMessage: sentMessage,
        );

        final roomsResult = await _chatRepository.getChatRooms();
        roomsResult.fold(
          (failure) => null,
          (rooms) {
            emit(state.copyWith(rooms: rooms, activeRoom: updatedRoom));
            _simulatePartnerReply(roomId, currentRoom.partner.fullName);
          },
        );
      },
    );
  }

  void _simulatePartnerReply(String roomId, String partnerName) {
    // Kích hoạt trạng thái "Đối phương đang soạn tin..." (isTyping = true) sau 800ms
    Timer(const Duration(milliseconds: 800), () {
      if (state.activeRoom?.id == roomId) {
        emit(state.copyWith(isTyping: true));
      }
    });

    // Tạo tin nhắn phản hồi sau 2.5 giây
    Timer(const Duration(milliseconds: 2500), () async {
      if (state.activeRoom?.id != roomId) {
        return; // Nếu đã thoát phòng chat thì hủy
      }

      final partnerId = state.activeRoom!.partner.id;
      final replyText =
          'Chào Sang! Rất vui được trò chuyện. Mình đã nhận được tin nhắn: "${state.activeRoom!.messages.last.content}"';

      final replyResult = await _chatRepository.sendMessage(
        roomId,
        partnerId,
        replyText,
      );
      replyResult.fold(
        (failure) => null,
        (replyMessage) async {
          if (state.activeRoom?.id != roomId) return;

          final currentRoom = state.activeRoom!;
          final updatedMessages = List<MessageEntity>.from(currentRoom.messages)
            ..add(replyMessage);
          final updatedRoom = currentRoom.copyWith(
            messages: updatedMessages,
            lastMessage: replyMessage,
          );

          final roomsResult = await _chatRepository.getChatRooms();
          roomsResult.fold(
            (failure) => null,
            (rooms) => emit(
              ChatState(
                rooms: rooms,
                activeRoom: updatedRoom,
                isLoading: false,
                isTyping: false,
              ),
            ),
          );
        },
      );
    });
  }
}
