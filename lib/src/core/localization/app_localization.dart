import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_language.dart';
import 'package:chat_app_new/src/feature/settings/widget/scope/settings_scope.dart';

import '../../../l10n/app_localizations.dart';

class AppLocalization {
  /// Get the current locale based on settings
  static Locale? getLocale(BuildContext context) {
    final language = SettingsScope.appLanguageOf(context);
    
    if (language == AppLanguage.system) {
      return null; // Let system decide
    }
    
    return Locale(language.code);
  }

  /// Get supported locales
  static List<Locale> get supportedLocales => const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('pt'),
        Locale('ja'),
        Locale('ko'),
        Locale('zh'),
        Locale('ar'),
        Locale('hi'),
        Locale('ru'),
      ];

  /// Get localization delegates
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  /// Helper to get AppLocalizations from context
  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }
}

