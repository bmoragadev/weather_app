// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `MiniWeather`
  String get app_name {
    return Intl.message('MiniWeather', name: 'app_name', desc: '', args: []);
  }

  /// `Configuration`
  String get drawer_config {
    return Intl.message(
      'Configuration',
      name: 'drawer_config',
      desc: '',
      args: [],
    );
  }

  /// `Temperature Unit`
  String get drawer_temperature_unit {
    return Intl.message(
      'Temperature Unit',
      name: 'drawer_temperature_unit',
      desc: '',
      args: [],
    );
  }

  /// `About this app`
  String get drawer_about_app {
    return Intl.message(
      'About this app',
      name: 'drawer_about_app',
      desc: '',
      args: [],
    );
  }

  /// `MiniWeather is a personal project developed in Flutter that provides a simple and efficient interface for checking the current weather. The app also displays hourly forecasts and weather conditions for the next 7 days, including minimum and maximum temperatures.`
  String get about_text {
    return Intl.message(
      'MiniWeather is a personal project developed in Flutter that provides a simple and efficient interface for checking the current weather. The app also displays hourly forecasts and weather conditions for the next 7 days, including minimum and maximum temperatures.',
      name: 'about_text',
      desc: '',
      args: [],
    );
  }

  /// `Created by Benjamín Moraga R.`
  String get created_by {
    return Intl.message(
      'Created by Benjamín Moraga R.',
      name: 'created_by',
      desc: '',
      args: [],
    );
  }

  /// `Made in Chile`
  String get made_in {
    return Intl.message('Made in Chile', name: 'made_in', desc: '', args: []);
  }

  /// `Data provided by WeatherAPI`
  String get data_from {
    return Intl.message(
      'Data provided by WeatherAPI',
      name: 'data_from',
      desc: '',
      args: [],
    );
  }

  /// `Real-time location permission denied.`
  String get localization_off_error {
    return Intl.message(
      'Real-time location permission denied.',
      name: 'localization_off_error',
      desc: '',
      args: [],
    );
  }

  /// `No Internet connection.`
  String get no_internet_error {
    return Intl.message(
      'No Internet connection.',
      name: 'no_internet_error',
      desc: '',
      args: [],
    );
  }

  /// `No local weather data found.`
  String get no_local_data_error {
    return Intl.message(
      'No local weather data found.',
      name: 'no_local_data_error',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get open_settings_button {
    return Intl.message(
      'Open Settings',
      name: 'open_settings_button',
      desc: '',
      args: [],
    );
  }

  /// `Last update`
  String get last_update_text {
    return Intl.message(
      'Last update',
      name: 'last_update_text',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
