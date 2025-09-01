// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_text": MessageLookupByLibrary.simpleMessage(
      "MiniWeather es un proyecto personal desarrollado en Flutter que ofrece una interfaz sencilla y eficiente para consultar el clima actual. La aplicación también muestra pronósticos por hora y el estado del tiempo para los próximos 3 días, con detalles de temperatura mínima y máxima.",
    ),
    "app_name": MessageLookupByLibrary.simpleMessage("MiniWeather"),
    "created_by": MessageLookupByLibrary.simpleMessage(
      "Creado por Benjamín Moraga R.",
    ),
    "data_from": MessageLookupByLibrary.simpleMessage(
      "Datos proporcionados por WeatherAPI",
    ),
    "drawer_about_app": MessageLookupByLibrary.simpleMessage(
      "Acerca de esta aplicación",
    ),
    "drawer_config": MessageLookupByLibrary.simpleMessage("Configuración"),
    "drawer_temperature_unit": MessageLookupByLibrary.simpleMessage(
      "Unidad de Temperatura",
    ),
    "last_update_text": MessageLookupByLibrary.simpleMessage(
      "Última actualización",
    ),
    "localization_off_error": MessageLookupByLibrary.simpleMessage(
      "Permiso de ubicación en tiempo real denegado.",
    ),
    "made_in": MessageLookupByLibrary.simpleMessage("Hecho en Chile"),
    "no_internet_error": MessageLookupByLibrary.simpleMessage(
      "Sin conexión a Internet.",
    ),
    "no_local_data_error": MessageLookupByLibrary.simpleMessage(
      "No se encontraron datos meteorológicos locales.",
    ),
    "open_settings_button": MessageLookupByLibrary.simpleMessage(
      "Abrir configuración",
    ),
  };
}
