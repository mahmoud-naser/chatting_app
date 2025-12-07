import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chat_app_new/src/feature/chat/widget/chat_app_bar.dart';
import 'package:chat_app_new/src/feature/chat/widget/scope/chat_scope.dart';
import 'package:chat_app_new/src/feature/chat/service/voice_input_service.dart';
import 'package:chat_app_new/src/feature/chat/widget/voice_recording_overlay.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';

// Simplified ChatBloc and ChatState for demo purposes
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ClearMessagesEvent>(_onClearMessages);
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) {
    // Create a TextMessage from the text
    final message = types.TextMessage(
      author: state.user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.text,
    );
    final newMessages = [...state.messages, message];
    emit(state.copyWith(messages: newMessages));
  }

  void _onClearMessages(ClearMessagesEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(messages: []));
  }
}

abstract class ChatEvent {}
class SendMessageEvent extends ChatEvent {
  final String text;
  SendMessageEvent(this.text);
}
class ClearMessagesEvent extends ChatEvent {}

class ChatState {
  final List<types.Message> messages;
  final bool isLoading;
  final types.User user;
  final types.User assistant;

  ChatState({
    required this.messages,
    this.isLoading = false,
    required this.user,
    required this.assistant,
  });

  factory ChatState.initial() {
    return ChatState(
      messages: [],
      user: const types.User(id: 'user'),
      assistant: const types.User(id: 'assistant'),
    );
  }

  ChatState copyWith({
    List<types.Message>? messages,
    bool? isLoading,
    types.User? user,
    types.User? assistant,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      assistant: assistant ?? this.assistant,
    );
  }
}

@RoutePage(name: 'ChatRoute')
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _isDialogShowing = false;
  final VoiceInputService _voiceService = VoiceInputService();
  bool _isListening = false;
  String? _currentTranscript;

  @override
  void initState() {
    super.initState();
    _voiceService.onResult = (text) {
      if (text.trim().isNotEmpty) {
        ChatScope.sendMessage(context, text);
      }
      setState(() {
        _isListening = false;
        _currentTranscript = null;
      });
    };
    _voiceService.onPartialResult = (text) {
      setState(() {
        _currentTranscript = text;
      });
    };
    _voiceService.onError = (error) {
      if (mounted && error != null) {
        _showError(error);
      }
      setState(() {
        _isListening = false;
      });
    };
    _voiceService.onStateChanged = (state) {
      setState(() {
        _isListening = state == VoiceInputState.listening;
        if (state != VoiceInputState.listening) {
          _currentTranscript = null;
        }
      });
    };
    _voiceService.initialize();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  Future<void> _toggleVoiceInput() async {
    if (_voiceService.isListening) {
      _voiceService.stopListening();
    } else {
      final hasPermission = await _voiceService.checkPermission();
      if (!hasPermission) {
        final granted = await _voiceService.requestPermission();
        if (!granted) {
          if (mounted) {
            _showError('Microphone permission is required for voice input');
          }
          return;
        }
      }
      await _voiceService.startListening();
    }
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ChatScope(
        child: BlocListener<ChatBloc, ChatState>(
          listener: _blocListener,
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
              final secondaryColor = isDark 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05);
              final l10n = AppLocalizations.of(context)!;
              
              return Stack(
                children: [
                  Scaffold(
                    appBar: ChatAppBar(
                      isTyping: state.isLoading,
                    ),
                    body: ui.Chat(
                      messages: state.messages,
                      inputOptions: ui.InputOptions(
                        sendButtonVisibilityMode: state.isLoading
                            ? ui.SendButtonVisibilityMode.hidden
                            : ui.SendButtonVisibilityMode.editing,
                      ),
                      onSendPressed: (partialText) => ChatScope.sendMessage(
                        context,
                        partialText.text,
                      ),
                      emptyState: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 80,
                            color: Theme.of(context).primaryColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.startConversation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.askMeAnything,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      user: state.user,
                      scrollPhysics: const BouncingScrollPhysics(),
                      dateHeaderBuilder: (header) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              DateFormat('MMM d, y').format(header.dateTime),
                              style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      theme: ui.DefaultChatTheme(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        messageInsetsHorizontal: 16,
                        messageInsetsVertical: 12,
                        messageBorderRadius: 18,
                        primaryColor: Theme.of(context).primaryColor,
                        secondaryColor: secondaryColor,
                        receivedMessageBodyTextStyle: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                        sentMessageBodyTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                        inputBorderRadius: BorderRadius.zero,
                        inputBackgroundColor: isDark 
                            ? const Color(0xFF1E1E1E)
                            : Colors.white,
                        inputTextColor: textColor,
                        inputTextCursorColor: Theme.of(context).primaryColor,
                        inputPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        inputTextStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: textColor,
                          height: 1.4,
                        ),
                        inputContainerDecoration: BoxDecoration(
                          color: isDark 
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        inputTextDecoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.2),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          isCollapsed: true,
                        ),
                        sendButtonMargin: const EdgeInsets.only(left: 8),
                        sendButtonIcon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Theme.of(context).primaryColor,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: _toggleVoiceInput,
                      backgroundColor: _isListening 
                          ? Colors.red 
                          : Theme.of(context).primaryColor,
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                      tooltip: _isListening ? 'Stop recording' : 'Start voice input',
                    ),
                  ),
                  // Voice recording overlay
                  if (_isListening)
                    VoiceRecordingOverlay(
                      onStop: () => _voiceService.stopListening(),
                      transcript: _currentTranscript ?? _voiceService.lastWords,
                    ),
                ],
              );
            },
          ),
        ),
      );

  void _blocListener(BuildContext context, ChatState state) {
    // Handle error states if needed
  }

  Future<void> _showErrorDialog(BuildContext context, String error) async {
    _isDialogShowing = true;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('An error has occurred'),
        content: Text(error),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Okay',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
    _isDialogShowing = false;
  }
}

