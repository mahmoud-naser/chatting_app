import 'package:flutter/material.dart';
import 'package:chat_app_new/src/feature/app/widget/app_configuration.dart';
import 'package:chat_app_new/src/feature/app/widget/app_lifecycle_scope.dart';
import 'package:chat_app_new/src/feature/settings/widget/scope/settings_scope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScope(
      child: AppLifecycleScope(
        child: AppConfiguration(),
      ),
    );
  }
}
