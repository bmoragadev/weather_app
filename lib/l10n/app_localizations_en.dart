// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'MiniWeather';

  @override
  String get drawer_config => 'Configuration';

  @override
  String get drawer_temperature_unit => 'Temperature Unit';

  @override
  String get drawer_about_app => 'About this app';

  @override
  String get about_text =>
      'MiniWeather is a personal project developed in Flutter that provides a simple and efficient interface for checking the current weather. The app also displays hourly forecasts and weather conditions for the next 3 days, including minimum and maximum temperatures.';

  @override
  String get created_by => 'Created by Benjamín Moraga R.';

  @override
  String get made_in => 'Made in Chile';

  @override
  String get data_from => 'Data provided by WeatherAPI';

  @override
  String get localization_off_error => 'Real-time location permission denied.';

  @override
  String get no_internet_error => 'No Internet connection.';

  @override
  String get no_local_data_error => 'No local weather data found.';

  @override
  String get open_settings_button => 'Open Settings';

  @override
  String get last_update_text => 'Latest forecast';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get feels_like => 'Feels like';

  @override
  String get uv_index => 'UV Index';
}
