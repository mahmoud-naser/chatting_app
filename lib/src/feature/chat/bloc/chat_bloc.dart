import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../service/chat_storage.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatStorage _storage;

  ChatBloc(this._storage) : super(ChatState.initial()) {
    on<LoadMessagesEvent>(_onLoad);
    on<SendMessageEvent>(_onSendMessage);
    on<ClearMessagesEvent>(_onClearMessages);
    on<SetMessagesEvent>((event, emit) async {
      emit(state.copyWith(messages: event.messages));
      await _storage.save(event.messages);
    });

    add(LoadMessagesEvent());
  }

  Future<void> _onLoad(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    final msgs = await _storage.load();
    msgs.sort((a, b) =>
        (b.createdAt ?? 0).compareTo(a.createdAt ?? 0)); // الأحدث أولاً
    emit(state.copyWith(messages: msgs));

  }

  Future<void> _onSendMessage(
      SendMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    final message = types.TextMessage(
      author: state.user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.text,
    );

    // ✅ الرسالة الجديدة في النهاية (لتطلع تحت)
    final newMessages = [message, ...state.messages];

    emit(state.copyWith(messages: newMessages));
    await _storage.save(newMessages);
  }

  Future<void> _onClearMessages(
      ClearMessagesEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(state.copyWith(messages: []));
    await _storage.clear();
  }
}

class LoadMessagesEvent extends ChatEvent {}

class SetMessagesEvent extends ChatEvent {
  final List<types.Message> messages;
  SetMessagesEvent(this.messages);
}
