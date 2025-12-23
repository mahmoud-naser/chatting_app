import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AppPrefs {
  static const _kMessages = 'chat_messages_v1';
  static const _kThemeMode = 'theme_mode'; // system/light/dark
  static const _kLanguageCode = 'language_code'; // ar/en/...

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  // -------- Messages --------
  Future<void> saveMessages(List<types.Message> messages) async {
    final p = await _prefs;
    final list = messages.map((m) => m.toJson()).toList();
    await p.setString(_kMessages, jsonEncode(list));
  }

  Future<List<types.Message>> loadMessages() async {
    final p = await _prefs;
    final raw = p.getString(_kMessages);
    if (raw == null || raw.isEmpty) return [];
    final decoded = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return decoded.map((e) => types.Message.fromJson(e)).toList();
  }

  Future<void> clearMessages() async {
    final p = await _prefs;
    await p.remove(_kMessages);
  }

  // -------- Theme --------
  Future<void> saveThemeMode(String mode) async {
    final p = await _prefs;
    await p.setString(_kThemeMode, mode); // "system" | "light" | "dark"
  }

  Future<String> loadThemeMode() async {
    final p = await _prefs;
    return p.getString(_kThemeMode) ?? 'system';
  }

  // -------- Language --------
  Future<void> saveLanguageCode(String code) async {
    final p = await _prefs;
    await p.setString(_kLanguageCode, code); // "ar", "en", ...
  }

  Future<String?> loadLanguageCode() async {
    final p = await _prefs;
    return p.getString(_kLanguageCode); // null => استخدم لغة الجهاز
  }
}
