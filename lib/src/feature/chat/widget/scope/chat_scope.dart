import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/app_prefs.dart';
import '../../bloc/chat_bloc.dart';
import '../../service/chat_storage.dart';

class ChatScope extends StatelessWidget {
  final Widget child;

  const ChatScope({required this.child, super.key});

  static void sendMessage(BuildContext context, String text) {
    context.read<ChatBloc>().add(SendMessageEvent(text));
  }

  static Future<void> clearMessages(BuildContext context) async {
    context.read<ChatBloc>().add(ClearMessagesEvent());
    await AppPrefs().clearMessages();

  }

  const ChatScope._(this.child);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(ChatStorage()),
      child: child,
    );
  }
}
