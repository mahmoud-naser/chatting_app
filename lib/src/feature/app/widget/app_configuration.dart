import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app_new/src/core/resources/dark_theme.dart';
import 'package:chat_app_new/src/core/resources/light_theme.dart';
import 'package:chat_app_new/src/core/router/app_router.dart';
import 'package:chat_app_new/src/core/localization/app_localization.dart';
import 'package:chat_app_new/src/feature/app/widget/app_router_builder.dart';
import 'package:chat_app_new/src/feature/settings/bloc/settings_bloc.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_language.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_theme.dart';
import 'package:chat_app_new/src/feature/settings/model/settings_state.dart';

class AppConfiguration extends StatelessWidget {
  const AppConfiguration({super.key});

  ThemeMode _mapThemeMode(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
      default:
        return ThemeMode.system;
    }
  }

  Locale? _mapLocale(AppLanguage language) {
    if (language == AppLanguage.system) return null;
    // ملاحظة: عندك language.code جاهز (en/ar/...)
    return Locale(language.code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return AppRouterBuilder(
          createRouter: (context) => AppRouter(),
          builder: (context, parser, delegate) => MaterialApp.router(
            routeInformationParser: parser,
            routerDelegate: delegate,
            title: 'Chat App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: _mapThemeMode(state.theme),
            localizationsDelegates: AppLocalization.localizationsDelegates,
            supportedLocales: AppLocalization.supportedLocales,
            locale: _mapLocale(state.language),
          ),
        );
      },
    );
  }
}
