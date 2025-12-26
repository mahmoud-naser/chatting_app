import 'package:android_intent_plus/android_intent.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bubble/bubble.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

import '../../../core/storage/app_prefs.dart';
import '../bloc/chat_bloc.dart';
import '../service/chat_storage.dart';
import '../widget/chat_app_bar.dart';
import '../widget/scope/chat_scope.dart';
import '../service/voice_input_service.dart';
import '../widget/voice_recording_overlay.dart';

@RoutePage(name: 'ChatRoute')
class ChatPage extends StatefulWidget implements AutoRouteWrapper {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(ChatStorage()),
      child: this,
    );
  }
}

class _ChatPageState extends State<ChatPage> {
  final VoiceInputService _voiceService = VoiceInputService();
  final TextEditingController _controller = TextEditingController();

  bool _isListening = false;
  bool _showSendButton = false;
  bool _isOnline = false;
  String? _currentTranscript;

  Future<void> openGoogleMicPermission() async {
    const intent = AndroidIntent(
      action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
      data: 'package:com.google.android.googlequicksearchbox',
    );

    await intent.launch();
  }

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((status) {
      setState(() {
        _isOnline = status != ConnectivityResult.none;
      });
    });
    Future.microtask(() async {
      final prefs = AppPrefs();
      final saved = await prefs.loadMessages();
      if (mounted) {
        context.read<ChatBloc>().add(SetMessagesEvent(saved));
      }
      await _voiceService.initialize();
    });

    // 🔵 نتيجة نهائية للكلام (بعد انتهاء المستخدم)
    _voiceService.onResult = (text) {
      setState(() {
        _controller.text = text;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        _showSendButton = text.trim().isNotEmpty;
        _isListening = false;
      });
    };

    // 🟡 تحديث مباشر أثناء الكلام
    _voiceService.onPartialResult = (text) {
      setState(() {
        _controller.text = text;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        _showSendButton = text.trim().isNotEmpty;
      });
    };

    // 🔴 الأخطاء
    _voiceService.onError = (error) {
      if (error == "error_permission") {
        _showError("يرجى منح إذن الميكروفون لخدمات Google");

        openGoogleMicPermission();
      } else {
        _showError(error);
      }

      setState(() => _isListening = false);
    };

    // 🔵 حالة record
    _voiceService.onStateChanged = (state) {
      setState(() {
        _isListening = state == VoiceInputState.listening;
        if (!_isListening) _currentTranscript = null;
      });
    };
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = AppPrefs();
    return ChatScope(
        child: BlocListener<ChatBloc, ChatState>(
      listenWhen: (prev, curr) => prev.messages.length != curr.messages.length,
      listener: (context, state) async {
        await prefs.saveMessages(state.messages);
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: ChatAppBar(
                  isTyping: false,
                  isOnline: _isOnline,
                ),

                // 👇👇 جسم الدردشة Scrollable طبيعي 100%
                body: chat_ui.Chat(
                  dateHeaderBuilder: (header) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          DateFormat('yyyy/MM/dd')
                              .format(header.dateTime), // ← التاريخ فقط
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  customBottomWidget: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        children: [
                          // 🟩 TextField بدون ScrollView (الحل الأساسي)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Builder(
                                builder: (context) {
                                  final locale = Localizations.localeOf(context)
                                      .languageCode;
                                  final isArabic = locale == "ar";
                                  final textDirection = isArabic
                                      ? ui.TextDirection.rtl
                                      : ui.TextDirection.ltr;
                                  final hint = isArabic
                                      ? "اكتب رسالة…"
                                      : "Type a message…";

                                  return Directionality(
                                    textDirection: textDirection,
                                    child: TextField(
                                      controller: _controller,
                                      minLines: 1,
                                      maxLines: 5,
                                      onChanged: (text) {
                                        setState(() => _showSendButton =
                                            text.trim().isNotEmpty);
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: hint,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // 🟦 زر إرسال أو زر مايك داخل TextField
                          GestureDetector(
                            onTap: () {
                              if (_showSendButton) {
                                ChatScope.sendMessage(
                                    context, _controller.text.trim());
                                _controller.clear();
                                setState(() => _showSendButton = false);
                              } else {
                                _voiceService.startListening();
                              }
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _showSendButton ? Icons.send : Icons.mic,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  messages: state.messages,
                  user: state.user,
                  inputOptions: const chat_ui.InputOptions(enabled: false),
                  onSendPressed: (partial) {
                    ChatScope.sendMessage(context, partial.text);
                  },
                  bubbleBuilder: (child,
                      {required message, required nextMessageInGroup}) {
                    final msg = message as types.Message;
                    final isMe = msg.author.id == state.user.id;

                    final lang = Localizations.localeOf(context)
                        .languageCode
                        .toLowerCase();
                    final isArabic = lang == 'ar';
                    final dir =
                        isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr;
                    final showTail =
                        !nextMessageInGroup; // ✅ فقط آخر رسالة في المجموعة
                    final createdAtMs =
                        msg.createdAt ?? DateTime.now().millisecondsSinceEpoch;
                    final time = DateFormat('HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(createdAtMs),
                    );

                    final bubbleColor = isMe
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200]!;
                    final textColor = isMe ? Colors.white : Colors.black87;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,

                      // 👇 يحدد أقصى عرض للفقاعة
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),

                        // 👇 يجعل العرض يلتف حول المحتوى
                        child: Bubble(
                          showNip: showTail,
                          radius: Radius.circular(10),
                          nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
                          color: bubbleColor,
                          padding: BubbleEdges.only(
                            right: isArabic ? 0 : 5,
                            left: isArabic ? 5 : 0,
                            bottom: 6,
                            top: nextMessageInGroup ? 2 : 6,
                          ),
                          child: Directionality(
                            textDirection: dir, // ✅ الاتجاه حسب اللغة
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              alignment: WrapAlignment.end,
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                    height: 1.3,
                                  ),
                                  child: child,
                                ),
                                Text(
                                  time,
                                  textDirection: dir,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        isMe ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // 👇👇 شريط الإدخال لا يغطي الشاشة (WhatsApp style)
              ),
              if (_isListening)
                VoiceRecordingOverlay(
                  onStop: () => _voiceService.stopListening(),
                  transcript: _currentTranscript ?? "",
                ),
            ],
          );
        },
      ),
    ));
  }
}
