import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_language.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_theme.dart';
import 'package:chat_app_new/src/feature/settings/model/settings_state.dart';
import 'package:chat_app_new/src/feature/settings/service/settings_repository.dart';

// Events
abstract class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class ChangeThemeEvent extends SettingsEvent {
  final AppTheme theme;
  ChangeThemeEvent(this.theme);
}

class ChangeLanguageEvent extends SettingsEvent {
  final AppLanguage language;
  ChangeLanguageEvent(this.language);
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc({SettingsRepository? repository})
      : _repository = repository ?? SettingsRepository(),
        super(SettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    
    // Load settings immediately
    add(LoadSettingsEvent());
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final theme = await _repository.getTheme();
      final language = await _repository.getLanguage();
      emit(SettingsState(
        theme: theme,
        language: language,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _repository.saveTheme(event.theme);
    emit(state.copyWith(theme: event.theme));
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _repository.saveLanguage(event.language);
    emit(state.copyWith(language: event.language));
  }
}

