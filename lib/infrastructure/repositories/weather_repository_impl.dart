import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/domain/entities/weather_data.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherDatasource datasource;

  WeatherRepositoryImpl({required this.datasource});

  @override
  Future<WeatherData> getWeatherData(Location location) {
    return datasource.getWeatherData(location);
  }
}
