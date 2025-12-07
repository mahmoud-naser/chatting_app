import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class VoiceRecordingOverlay extends StatefulWidget {
  final VoidCallback onStop;
  final String? transcript;

  const VoiceRecordingOverlay({
    required this.onStop,
    this.transcript,
  });

  @override
  State<VoiceRecordingOverlay> createState() => _VoiceRecordingOverlayState();
}

class _VoiceRecordingOverlayState extends State<VoiceRecordingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 120 + (_pulseController.value * 40),
                  height: 120 + (_pulseController.value * 40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.3 - (_pulseController.value * 0.2)),
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Listening...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.transcript != null && widget.transcript!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  widget.transcript!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: widget.onStop,
              icon: const Icon(Icons.stop),
              label: const Text('Stop Recording'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

