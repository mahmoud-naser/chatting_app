import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

enum VoiceInputState {
  idle,
  listening,
  processing,
  error,
}

class VoiceInputService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;
  VoiceInputState _state = VoiceInputState.idle;
  String _lastWords = '';
  String? _errorMessage;

  VoiceInputState get state => _state;
  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;
  String get lastWords => _lastWords;
  String? get errorMessage => _errorMessage;

  // Callback functions
  Function(String)? onResult;
  Function(String)? onPartialResult;
  Function(String?)? onError;
  Function(VoiceInputState)? onStateChanged;

  /// Initialize speech recognition
  Future<bool> initialize() async {
    try {
      _isAvailable = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );
      return _isAvailable;
    } catch (e) {
      _setState(VoiceInputState.error);
      _errorMessage = 'Failed to initialize speech recognition: $e';
      onError?.call(_errorMessage);
      return false;
    }
  }

  /// Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Check if microphone permission is granted
  Future<bool> checkPermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Start listening for speech
  Future<bool> startListening({String? locale}) async {
    if (!_isAvailable) {
      final initialized = await initialize();
      if (!initialized) {
        return false;
      }
    }

    // Check permission
    if (!await checkPermission()) {
      final granted = await requestPermission();
      if (!granted) {
        _setState(VoiceInputState.error);
        _errorMessage = 'Microphone permission denied';
        onError?.call(_errorMessage);
        return false;
      }
    }

    try {
      _lastWords = '';
      _isListening = await _speech.listen(
        onResult: _onSpeechResult,
        localeId: locale,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
      );
      
      if (_isListening) {
        _setState(VoiceInputState.listening);
      }
      return _isListening;
    } catch (e) {
      _setState(VoiceInputState.error);
      _errorMessage = 'Failed to start listening: $e';
      onError?.call(_errorMessage);
      return false;
    }
  }

  /// Stop listening
  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
      _setState(VoiceInputState.idle);
    }
  }

  /// Cancel listening
  void cancelListening() {
    if (_isListening) {
      _speech.cancel();
      _isListening = false;
      _lastWords = '';
      _setState(VoiceInputState.idle);
    }
  }

  /// Get available locales
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    if (!_isAvailable) {
      await initialize();
    }
    return _speech.locales();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    
    if (result.finalResult) {
      _setState(VoiceInputState.processing);
      onResult?.call(_lastWords);
      stopListening();
    } else {
      // Partial result - update in real-time
      onPartialResult?.call(_lastWords);
    }
  }

  void _onSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _isListening = false;
      if (_state == VoiceInputState.listening) {
        _setState(VoiceInputState.idle);
      }
    }
  }

  void _onSpeechError(stt.SpeechRecognitionError error) {
    _isListening = false;
    _setState(VoiceInputState.error);
    _errorMessage = error.errorMsg;
    onError?.call(_errorMessage);
  }

  void _setState(VoiceInputState newState) {
    if (_state != newState) {
      _state = newState;
      onStateChanged?.call(_state);
    }
  }

  void dispose() {
    stopListening();
  }
}

