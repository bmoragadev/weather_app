// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'MiniWeather';

  @override
  String get drawer_config => 'Configuración';

  @override
  String get drawer_temperature_unit => 'Unidad de Temperatura';

  @override
  String get drawer_about_app => 'Acerca de esta aplicación';

  @override
  String get about_text =>
      'MiniWeather es un proyecto personal desarrollado en Flutter que ofrece una interfaz sencilla y eficiente para consultar el clima actual. La aplicación también muestra pronósticos por hora y el estado del tiempo para los próximos 3 días, con detalles de temperatura mínima y máxima.';

  @override
  String get created_by => 'Creado por Benjamín Moraga R.';

  @override
  String get made_in => 'Hecho en Chile';

  @override
  String get data_from => 'Datos proporcionados por WeatherAPI';

  @override
  String get localization_off_error =>
      'Permiso de ubicación en tiempo real denegado.';

  @override
  String get no_internet_error => 'Sin conexión a Internet.';

  @override
  String get no_local_data_error =>
      'No se encontraron datos meteorológicos locales.';

  @override
  String get open_settings_button => 'Abrir configuración';

  @override
  String get last_update_text => 'Última actualización';
}
