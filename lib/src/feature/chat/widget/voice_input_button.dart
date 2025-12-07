import 'package:flutter/material.dart';
import 'package:chat_app_new/src/feature/chat/service/voice_input_service.dart';

class VoiceInputButton extends StatefulWidget {
  final Function(String text) onTranscriptReceived;
  final VoidCallback? onListeningStateChanged;

  const VoiceInputButton({
    required this.onTranscriptReceived,
    this.onListeningStateChanged,
    super.key,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  late VoiceInputService _voiceService;
  late AnimationController _animationController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceInputService();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _voiceService.onResult = (text) {
      if (text.trim().isNotEmpty) {
        widget.onTranscriptReceived(text);
      }
    };

    _voiceService.onError = (error) {
      if (mounted && error != null) {
        _showError(error);
      }
    };

    _voiceService.onStateChanged = (state) {
      if (mounted) {
        setState(() {});
        widget.onListeningStateChanged?.call();
        if (state == VoiceInputState.listening) {
          _animationController.repeat(reverse: true);
        } else {
          _animationController.stop();
          _animationController.reset();
        }
      }
    };

    _initializeVoiceService();
  }

  Future<void> _initializeVoiceService() async {
    final initialized = await _voiceService.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = initialized;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_voiceService.isListening) {
      _voiceService.stopListening();
    } else {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isListening = _voiceService.isListening;

    if (!_isInitialized) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _toggleListening,
      onLongPressEnd: (_) {
        if (_voiceService.isListening) {
          _voiceService.stopListening();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final scale = isListening
              ? 1.0 + (_animationController.value * 0.2)
              : 1.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isListening
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                boxShadow: isListening
                    ? [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}

