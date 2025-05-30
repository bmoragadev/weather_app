import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/infrastructure/datasources/weather/weather_api_datasource_impl.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherDatasource datasource;

  WeatherRepositoryImpl({WeatherDatasource? datasource})
      : datasource = datasource ?? WeatherApiDatasourceImpl();

  @override
  Future<WeatherData> getWeatherData(Location location) {
    return datasource.getWeatherData(location);
  }
}
