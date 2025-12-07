enum AppLanguage {
  system,
  en,
  es,
  fr,
  de,
  it,
  pt,
  ja,
  ko,
  zh,
  ar,
  hi,
  ru,
}

extension AppLanguageX on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.system:
        return 'system';
      case AppLanguage.en:
        return 'en';
      case AppLanguage.es:
        return 'es';
      case AppLanguage.fr:
        return 'fr';
      case AppLanguage.de:
        return 'de';
      case AppLanguage.it:
        return 'it';
      case AppLanguage.pt:
        return 'pt';
      case AppLanguage.ja:
        return 'ja';
      case AppLanguage.ko:
        return 'ko';
      case AppLanguage.zh:
        return 'zh';
      case AppLanguage.ar:
        return 'ar';
      case AppLanguage.hi:
        return 'hi';
      case AppLanguage.ru:
        return 'ru';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.system:
        return 'System Default';
      case AppLanguage.en:
        return 'English';
      case AppLanguage.es:
        return 'Español';
      case AppLanguage.fr:
        return 'Français';
      case AppLanguage.de:
        return 'Deutsch';
      case AppLanguage.it:
        return 'Italiano';
      case AppLanguage.pt:
        return 'Português';
      case AppLanguage.ja:
        return '日本語';
      case AppLanguage.ko:
        return '한국어';
      case AppLanguage.zh:
        return '中文';
      case AppLanguage.ar:
        return 'العربية';
      case AppLanguage.hi:
        return 'हिन्दी';
      case AppLanguage.ru:
        return 'Русский';
    }
  }

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.system,
    );
  }
}

