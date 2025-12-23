import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatStorage {
  static const _key = 'chat_messages_v1';

  Future<List<types.Message>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];

    return decoded
        .whereType<Map<String, dynamic>>()
        .map((m) => types.Message.fromJson(m))
        .toList();
  }

  Future<void> save(List<types.Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final list = messages.map((m) => m.toJson()).toList();
    await prefs.setString(_key, jsonEncode(list));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
