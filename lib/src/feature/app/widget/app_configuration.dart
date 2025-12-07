import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_new/src/core/resources/dark_theme.dart';
import 'package:chat_app_new/src/core/resources/light_theme.dart';
import 'package:chat_app_new/src/core/router/app_router.dart';
import 'package:chat_app_new/src/core/localization/app_localization.dart';
import 'package:chat_app_new/src/feature/app/widget/app_router_builder.dart';
import 'package:chat_app_new/src/feature/settings/bloc/settings_bloc.dart';
import 'package:chat_app_new/src/feature/settings/model/settings_state.dart';
import 'package:chat_app_new/src/feature/settings/widget/scope/settings_scope.dart';


class AppConfiguration extends StatelessWidget {
  const AppConfiguration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final themeMode = SettingsScope.themeModeOf(context);
        final locale = AppLocalization.getLocale(context);

        return AppRouterBuilder(
          createRouter: (context) => AppRouter(),
          builder: (context, parser, delegate) => MaterialApp.router(
            routeInformationParser: parser,
            routerDelegate: delegate,
            title: 'Chat App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            localizationsDelegates: AppLocalization.localizationsDelegates,
            supportedLocales: AppLocalization.supportedLocales,
            locale: locale,
          ),
        );
      },
    );
  }
}

