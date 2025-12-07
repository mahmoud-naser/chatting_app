import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chat_bloc.dart';

class ChatScope extends StatelessWidget {
  final Widget child;

  const ChatScope({required this.child, super.key});

  static void sendMessage(BuildContext context, String text) {
    context.read<ChatBloc>().add(SendMessageEvent(text));
  }

  static void clearMessages(BuildContext context) {
    context.read<ChatBloc>().add(ClearMessagesEvent());
  }

  const ChatScope._(this.child);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(),
      child: child,
    );
  }
}
