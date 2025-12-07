import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

enum VoiceInputState { idle, listening }

class VoiceInputService {
  final SpeechToText _speech = SpeechToText();

  VoiceInputState _state = VoiceInputState.idle;
  VoiceInputState get state => _state;

  bool get isListening => _state == VoiceInputState.listening;

  Function(String)? onResult;
  Function(String)? onPartialResult;
  Function(String)? onError;
  Function(VoiceInputState)? onStateChanged;

  bool _initialized = false;

  Future<void> initialize() async {
    try {
      _initialized = await _speech.initialize(
        onError: (err) {
          print("INIT ERROR: ${err.errorMsg}");
          onError?.call(err.errorMsg);
        },
        onStatus: (status) {
          print("STATUS: $status");
        },
      );
      if (!_initialized) {
        onError?.call("فشل تهيئة التعرف الصوتي");
      }
      print("SPEECH INIT: $_initialized");
    } catch (e) {
      onError?.call("خطأ أثناء تهيئة الصوت: $e");
    }
  }

  Future<void> startListening() async {
    if (!_initialized) {
      onError?.call("لم يتم تهيئة محرك التعرف الصوتي");
      return;
    }

    final isAvailable = await _speech.initialize();
    print("AVAILABLE: $isAvailable");


    final micStatus = await Permission.microphone.status;
    print("MIC STATUS: $micStatus");

    final hasPermission = await Permission.microphone.request();
    if (!hasPermission.isGranted) {
      onError?.call("يرجى منح إذن الميكروفون");
      return;
    }

    _state = VoiceInputState.listening;
    onStateChanged?.call(_state);

    await _speech.listen(
      listenMode: ListenMode.dictation,
      localeId: "ar_JO",
      partialResults: true,
      onResult: (result) {
        final text = result.recognizedWords;

        if (result.finalResult) {
          onResult?.call(text);
        } else {
          onPartialResult?.call(text);
        }
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    _state = VoiceInputState.idle;
    onStateChanged?.call(_state);
  }

  void dispose() {
    _speech.stop();
  }
}
