// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_text": MessageLookupByLibrary.simpleMessage(
      "MiniWeather is a personal project developed in Flutter that provides a simple and efficient interface for checking the current weather. The app also displays hourly forecasts and weather conditions for the next 7 days, including minimum and maximum temperatures.",
    ),
    "app_name": MessageLookupByLibrary.simpleMessage("MiniWeather"),
    "created_by": MessageLookupByLibrary.simpleMessage(
      "Created by Benjamín Moraga R.",
    ),
    "data_from": MessageLookupByLibrary.simpleMessage(
      "Data provided by WeatherAPI",
    ),
    "drawer_about_app": MessageLookupByLibrary.simpleMessage("About this app"),
    "drawer_config": MessageLookupByLibrary.simpleMessage("Configuration"),
    "drawer_temperature_unit": MessageLookupByLibrary.simpleMessage(
      "Temperature Unit",
    ),
    "localization_off_error": MessageLookupByLibrary.simpleMessage(
      "Real-time location permission denied.",
    ),
    "made_in": MessageLookupByLibrary.simpleMessage("Made in Chile"),
    "no_internet_error": MessageLookupByLibrary.simpleMessage(
      "No Internet connection.",
    ),
    "no_local_data_error": MessageLookupByLibrary.simpleMessage(
      "No local weather data found.",
    ),
    "open_settings_button": MessageLookupByLibrary.simpleMessage(
      "Open Settings",
    ),
  };
}
