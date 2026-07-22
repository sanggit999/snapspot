import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/chat/presentation/blocs/chat_cubit.dart';
import 'package:intl/intl.dart';

/// Màn hình Phòng chat chi tiết chuẩn Type Scale & High Contrast Light/Dark Mode.
class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  const ChatRoomScreen({super.key, required this.roomId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().enterRoom(widget.roomId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _onSendPressed() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<ChatCubit>().sendMessage(
        widget.roomId,
        text,
        authState.currentUser.id,
      );
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<ChatCubit>().leaveRoom();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 19,
              color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
            ),
            onPressed: () {
              context.read<ChatCubit>().leaveRoom();
              Navigator.pop(context);
            },
          ),
          title: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state.activeRoom == null) return const Text('Chat');

              final partner = state.activeRoom!.partner;
              return Row(
                children: [
                  AppAvatar(
                    imageUrl: partner.avatarUrl,
                    size: AppAvatarSize.small,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partner.fullName,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          state.isTyping
                              ? 'Đang soạn tin...'
                              : context.tr('online'),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: state.isTyping
                                ? AppColors.primary
                                : AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.videocam_outlined,
                color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.info_outline_rounded,
                color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state.activeRoom == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final room = state.activeRoom!;
            final authState = context.read<AuthCubit>().state;
            final currentUserId = authState is AuthSuccess
                ? authState.currentUser.id
                : '';

            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: room.messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == room.messages.length && state.isTyping) {
                        return _buildTypingIndicator(
                          room.partner.avatarUrl,
                          isLight,
                        );
                      }

                      final msg = room.messages[index];
                      final isMe = msg.senderId == currentUserId;

                      return _buildMessageBubble(msg, isMe, isLight);
                    },
                  ),
                ),

                // Ô nhập tin nhắn
                Container(
                  padding: EdgeInsets.fromLTRB(
                    12,
                    8,
                    12,
                    8 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: isLight ? Colors.white : AppColors.surfaceDark,
                    border: Border(
                      top: BorderSide(
                        color: isLight ? AppColors.borderLight : AppColors.borderDark,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.photo_outlined,
                          color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                        ),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isLight ? Colors.grey[100] : Colors.grey[900],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(
                              fontSize: 14.5,
                              color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: context.tr('type_message'),
                              hintStyle: TextStyle(
                                fontSize: 13.5,
                                color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _onSendPressed(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                        onPressed: _onSendPressed,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageBubble(dynamic msg, bool isMe, bool isLight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            AppAvatar(
              imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
              size: AppAvatarSize.small,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.primary
                        : (isLight ? Colors.grey[200] : Colors.grey[850]),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : Radius.zero,
                      bottomRight: isMe
                          ? Radius.zero
                          : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    msg.content,
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : (isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary),
                      fontSize: 14.5,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    DateFormat('HH:mm').format(msg.createdAt),
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(String partnerAvatarUrl, bool isLight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppAvatar(imageUrl: partnerAvatarUrl, size: AppAvatarSize.small),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isLight ? Colors.grey[200] : Colors.grey[850],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
