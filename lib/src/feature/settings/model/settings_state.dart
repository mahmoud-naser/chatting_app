import 'package:chat_app_new/src/feature/settings/enum/app_language.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_theme.dart';

class SettingsState {
  final AppTheme theme;
  final AppLanguage language;
  final bool isLoading;

  const SettingsState({
    required this.theme,
    required this.language,
    this.isLoading = false,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      theme: AppTheme.system,
      language: AppLanguage.system,
    );
  }

  SettingsState copyWith({
    AppTheme? theme,
    AppLanguage? language,
    bool? isLoading,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

