import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'MiniWeather'**
  String get app_name;

  /// No description provided for @drawer_config.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get drawer_config;

  /// No description provided for @drawer_temperature_unit.
  ///
  /// In en, this message translates to:
  /// **'Temperature Unit'**
  String get drawer_temperature_unit;

  /// No description provided for @drawer_about_app.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get drawer_about_app;

  /// No description provided for @about_text.
  ///
  /// In en, this message translates to:
  /// **'MiniWeather is a personal project developed in Flutter that provides a simple and efficient interface for checking the current weather. The app also displays hourly forecasts and weather conditions for the next 3 days, including minimum and maximum temperatures.'**
  String get about_text;

  /// No description provided for @created_by.
  ///
  /// In en, this message translates to:
  /// **'Created by Benjamín Moraga R.'**
  String get created_by;

  /// No description provided for @made_in.
  ///
  /// In en, this message translates to:
  /// **'Made in Chile'**
  String get made_in;

  /// No description provided for @data_from.
  ///
  /// In en, this message translates to:
  /// **'Data provided by WeatherAPI'**
  String get data_from;

  /// No description provided for @localization_off_error.
  ///
  /// In en, this message translates to:
  /// **'Real-time location permission denied.'**
  String get localization_off_error;

  /// No description provided for @no_internet_error.
  ///
  /// In en, this message translates to:
  /// **'No Internet connection.'**
  String get no_internet_error;

  /// No description provided for @no_local_data_error.
  ///
  /// In en, this message translates to:
  /// **'No local weather data found.'**
  String get no_local_data_error;

  /// No description provided for @open_settings_button.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get open_settings_button;

  /// No description provided for @last_update_text.
  ///
  /// In en, this message translates to:
  /// **'Latest forecast'**
  String get last_update_text;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @feels_like.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feels_like;

  /// No description provided for @uv_index.
  ///
  /// In en, this message translates to:
  /// **'UV Index'**
  String get uv_index;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
