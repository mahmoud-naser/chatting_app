import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
class VoiceRecordingOverlay extends StatefulWidget {
  final VoidCallback onStop;
  final String transcript;

  const VoiceRecordingOverlay({
    super.key,
    required this.onStop,
    required this.transcript,
  });

  @override
  State<VoiceRecordingOverlay> createState() => _VoiceRecordingOverlayState();
}

class _VoiceRecordingOverlayState extends State<VoiceRecordingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔵 Pulse animation
              SizedBox(
                width: 120,
                height: 120,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final scale = 1 + (_controller.value * 0.5);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(1 - _controller.value),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // 🎙️ Mic icon
              Icon(
                Icons.mic,
                size: 36,
                color: Colors.white,
              ),

              const SizedBox(height: 12),

              // 📝 live transcript
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  widget.transcript.isEmpty
                      ? l10n.listening
                      : widget.transcript,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
