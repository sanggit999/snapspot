import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/router/app_routes.dart';
import 'package:snapspot/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:snapspot/features/chat/presentation/screens/chat_room_screen.dart';

/// Route Màn hình Chat Room toàn màn hình (không có BottomBar)
GoRoute buildChatRoomRoute(GlobalKey<NavigatorState> rootNavigatorKey) {
  return GoRoute(
    path: AppRoutes.chatRoom,
    name: AppRoutes.chatRoomName,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final roomId = state.pathParameters['roomId']!;
      return ChatRoomScreen(roomId: roomId);
    },
  );
}

/// Route Danh sách Chat nằm trong ShellRoute (Main Tab)
GoRoute buildChatTabRoute() {
  return GoRoute(
    path: AppRoutes.chat,
    name: AppRoutes.chatName,
    builder: (context, state) => const ChatListScreen(),
  );
}
