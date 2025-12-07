part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String text;
  SendMessageEvent(this.text);
}

class ClearMessagesEvent extends ChatEvent {}
