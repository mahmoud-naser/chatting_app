import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_language.dart'
    show AppLanguage, AppLanguageX;
import 'package:chat_app_new/src/feature/settings/enum/app_theme.dart';

class SettingsRepository {
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';
  static const String _showTimeKey = 'show_time';

  Future<AppTheme> getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);
      if (themeString != null) {
        return AppTheme.values.firstWhere(
          (theme) => theme.name == themeString,
          orElse: () => AppTheme.system,
        );
      }
    } catch (e) {
      // Handle error silently, return default
    }
    return AppTheme.system;
  }

  Future<bool> getShowTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showTimeKey) ?? true;
  }

  Future<void> saveShowTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showTimeKey, value);
  }

  Future<void> saveTheme(AppTheme theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme.name);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<AppLanguage> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageString = prefs.getString(_languageKey);
      if (languageString != null) {
        return AppLanguage.values.firstWhere(
          (lang) => lang.code == languageString,
          orElse: () => AppLanguage.system,
        );
      }
    } catch (e) {
      // Handle error silently, return default
    }
    return AppLanguage.system;
  }

  Future<void> saveLanguage(AppLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language.code);
    } catch (e) {
      // Handle error silently
    }
  }
}
