import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';
import 'package:snapspot/features/chat/presentation/blocs/chat_cubit.dart';
import 'package:intl/intl.dart';

/// Màn hình Danh sách hội thoại chat chuẩn Type Scale UI/UX.
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('chat_list'),
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w700,
            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
            letterSpacing: -0.3,
          ),
        ),
        elevation: 0,
        backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.isLoading && state.rooms.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 56,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('no_conversations'),
                    style: TextStyle(
                      fontSize: 14.5,
                      color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.rooms.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 76,
              color: isLight ? AppColors.borderLight : AppColors.borderDark,
            ),
            itemBuilder: (context, index) {
              final room = state.rooms[index];
              final hasUnread = room.unreadCount > 0;
              final formattedTime = room.lastMessage != null
                  ? DateFormat('HH:mm').format(room.lastMessage!.createdAt)
                  : '';

              return ListTile(
                leading: AppAvatar(
                  imageUrl: room.partner.avatarUrl,
                  size: AppAvatarSize.medium,
                  hasStory: true,
                  isStoryRead: true,
                ),
                title: Text(
                  room.partner.fullName,
                  style: TextStyle(
                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 15.0,
                    color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                subtitle: Text(
                  room.lastMessage?.content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.0,
                    height: 1.35,
                    color: hasUnread
                        ? (isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary)
                        : (isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary),
                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (hasUnread)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${room.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  context.push('/chat/${room.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
