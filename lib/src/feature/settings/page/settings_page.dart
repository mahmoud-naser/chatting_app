import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_new/src/core/resources/sizes.dart';
import 'package:chat_app_new/src/feature/settings/bloc/settings_bloc.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_language.dart';
import 'package:chat_app_new/src/feature/settings/enum/app_theme.dart';
import 'package:chat_app_new/src/feature/settings/model/settings_state.dart';
import 'package:chat_app_new/src/feature/settings/widget/scope/settings_scope.dart';

import '../../../../l10n/app_localizations.dart';

@RoutePage(name: 'SettingsRoute')
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final dividerColor = isDark 
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.1);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // Theme Section
              _SettingsSection(
                title: l10n.appearance,
                icon: Icons.palette_outlined,
                children: [
                  _ThemeOption(
                    theme: AppTheme.light,
                    title: l10n.light,
                    icon: Icons.light_mode_outlined,
                    isSelected: state.theme == AppTheme.light,
                    onTap: () => SettingsScope.setTheme(context, AppTheme.light),
                    showDivider: true,
                  ),
                  _ThemeOption(
                    theme: AppTheme.dark,
                    title: l10n.dark,
                    icon: Icons.dark_mode_outlined,
                    isSelected: state.theme == AppTheme.dark,
                    onTap: () => SettingsScope.setTheme(context, AppTheme.dark),
                    showDivider: true,
                  ),
                  _ThemeOption(
                    theme: AppTheme.system,
                    title: l10n.systemDefault,
                    icon: Icons.phone_android_outlined,
                    isSelected: state.theme == AppTheme.system,
                    onTap: () => SettingsScope.setTheme(context, AppTheme.system),
                    showDivider: false,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Language Section
              _SettingsSection(
                title: l10n.language,
                icon: Icons.language_outlined,
                children: _buildLanguageOptions(context, state.language),
              ),

              const SizedBox(height: 24),

              // Future Settings Section Placeholder
              _SettingsSection(
                title: l10n.moreSettings,
                icon: Icons.settings_outlined,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding,
                      vertical: 16,
                    ),
                    child: Text(
                      l10n.moreSettingsComingSoon,
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildLanguageOptions(BuildContext context, AppLanguage selectedLanguage) {
    final languages = [
      AppLanguage.system,
      AppLanguage.en,
      AppLanguage.es,
      AppLanguage.fr,
      AppLanguage.de,
      AppLanguage.it,
      AppLanguage.pt,
      AppLanguage.ja,
      AppLanguage.ko,
      AppLanguage.zh,
      AppLanguage.ar,
      AppLanguage.hi,
      AppLanguage.ru,
    ];

    return List.generate(languages.length, (index) {
      final language = languages[index];
      final isLast = index == languages.length - 1;
      
      return _LanguageOption(
        language: language,
        isSelected: selectedLanguage == language,
        onTap: () => SettingsScope.setLanguage(context, language),
        showDivider: !isLast,
      );
    });
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: 8,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: textColor.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          decoration: BoxDecoration(
            color: isDark 
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _ThemeOption({
    required this.theme,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark 
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.1);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: 16,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : textColor.withOpacity(0.6),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : textColor,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
            indent: kDefaultPadding + 24 + 16, // icon + spacing
          ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark 
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.1);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : (isDark 
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      language.code == 'system' 
                          ? '🌐'
                          : language.code.toUpperCase().substring(0, 2),
                      style: TextStyle(
                        fontSize: language.code == 'system' ? 20 : 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    language.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : textColor,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
            indent: kDefaultPadding + 36 + 16, // container + spacing
          ),
      ],
    );
  }
}

