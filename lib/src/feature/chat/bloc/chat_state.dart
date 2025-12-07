part of 'chat_bloc.dart';

class ChatState {
  final List<types.Message> messages;
  final types.User user;
  final types.User assistant;

  ChatState({
    required this.messages,
    required this.user,
    required this.assistant,
  });

  factory ChatState.initial() {
    return ChatState(
      messages: [],
      user: const types.User(id: "user"),
      assistant: const types.User(id: "assistant"),
    );
  }

  ChatState copyWith({
    List<types.Message>? messages,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      user: user,
      assistant: assistant,
    );
  }
}
