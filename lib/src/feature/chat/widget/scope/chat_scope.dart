import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_new/src/feature/chat/page/chat_page.dart';

class ChatScope extends StatelessWidget {
  final Widget child;

  const ChatScope({
    required this.child,
    super.key,
  });

  static ChatBloc _blocOf(BuildContext context) => context.read<ChatBloc>();

  static void sendMessage(BuildContext context, String text) {
    _blocOf(context).add(SendMessageEvent(text));
  }

  static void clearMessages(BuildContext context) {
    _blocOf(context).add(ClearMessagesEvent());
  }

  @override
  Widget build(BuildContext context) => BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(),
        child: child,
      );
}

