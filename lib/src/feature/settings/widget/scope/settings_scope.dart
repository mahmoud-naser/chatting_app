import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_language.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_theme.dart';
import 'package:chat_app_new/src/feature/settings/bloc/settings_bloc.dart';
import 'package:chat_app_new/src/feature/settings/model/settings_state.dart';

class SettingsScope extends StatelessWidget {
  final Widget child;

  const SettingsScope({
    required this.child,
    super.key,
  });

  static SettingsBloc _blocOf(BuildContext context) => context.read<SettingsBloc>();
  static SettingsState _stateOf(BuildContext context) => context.watch<SettingsBloc>().state;

  static ThemeMode themeModeOf(BuildContext context) {
    final state = _stateOf(context);
    return state.theme.when(
      light: () => ThemeMode.light,
      dark: () => ThemeMode.dark,
      system: () => ThemeMode.system,
    );
  }

  static AppTheme appThemeOf(BuildContext context) {
    return _stateOf(context).theme;
  }

  static AppLanguage appLanguageOf(BuildContext context) {
    return _stateOf(context).language;
  }

  static void setTheme(BuildContext context, AppTheme theme) {
    _blocOf(context).add(ChangeThemeEvent(theme));
  }

  static void setLanguage(BuildContext context, AppLanguage language) {
    _blocOf(context).add(ChangeLanguageEvent(language));
  }

  @override
  Widget build(BuildContext context) => BlocProvider<SettingsBloc>(
        create: (context) => SettingsBloc(),
        child: child,
      );
}
