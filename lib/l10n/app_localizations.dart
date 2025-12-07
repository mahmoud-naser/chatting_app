import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Chat App'**
  String get appTitle;

  /// Title for AI assistant in chat header
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// Status indicator when assistant is online
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Status indicator when assistant is Offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Status indicator when assistant is typing
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Tooltip for clear chat button
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get clearChat;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get startConversation;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Ask me anything'**
  String get askMeAnything;

  /// Confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear chat history?'**
  String get clearChatHistory;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Settings section title for appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System default theme option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Settings section title for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Settings section title for future settings
  ///
  /// In en, this message translates to:
  /// **'More Settings'**
  String get moreSettings;

  /// Placeholder text for future settings
  ///
  /// In en, this message translates to:
  /// **'More settings coming soon...'**
  String get moreSettingsComingSoon;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'es', 'fr', 'hi', 'it', 'ja', 'ko', 'pt', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
