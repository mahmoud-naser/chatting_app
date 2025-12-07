import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ClearMessagesEvent>(_onClearMessages);
  }

  void _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) {
    final message = types.TextMessage(
      author: state.user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.text,
    );

    emit(state.copyWith(
      messages: [message,...state.messages],
    ));
  }

  void _onClearMessages(
      ClearMessagesEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(messages: []));
  }
}
