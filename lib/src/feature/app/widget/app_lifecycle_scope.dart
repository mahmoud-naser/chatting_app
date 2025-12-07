import 'package:flutter/material.dart';

class AppLifecycleScope extends StatefulWidget {
  final Widget child;

  const AppLifecycleScope({
    required this.child,
    super.key,
  });

  @override
  State<AppLifecycleScope> createState() => _AppLifecycleScopeState();
}

class _AppLifecycleScopeState extends State<AppLifecycleScope>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Handle resumed
        break;
      case AppLifecycleState.inactive:
        // Handle inactive
        break;
      case AppLifecycleState.paused:
        // Handle paused
        break;
      case AppLifecycleState.detached:
        // Handle detached
        break;
      case AppLifecycleState.hidden:
        // Handle hidden
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

