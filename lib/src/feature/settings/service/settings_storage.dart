import 'package:shared_preferences/shared_preferences.dart';
import '../enum/app_language.dart';
import '../enum/app_theme.dart';

class SettingsStorage {
  static const _themeKey = 'app_theme_v1';
  static const _langKey  = 'app_language_v1';

  Future<void> saveTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.name);
  }

  Future<AppTheme> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_themeKey);
    return AppTheme.values.firstWhere(
          (e) => e.name == raw,
      orElse: () => AppTheme.system,
    );
  }

  Future<void> saveLanguage(AppLanguage lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, lang.code);
  }

  Future<AppLanguage> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_langKey);
    return AppLanguage.values.firstWhere(
          (e) => e.code == raw,
      orElse: () => AppLanguage.system,
    );
  }
}
