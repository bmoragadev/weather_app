import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/domain/datasources/weather_datasource.dart';
import 'package:miniweather/infrastructure/datasources/weather/weather_api_datasource_impl.dart';

final weatherDatasourceProvider = Provider<WeatherDatasource>((ref) {
  return WeatherApiDatasourceImpl();
});
