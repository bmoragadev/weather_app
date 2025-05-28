import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/infrastructure/datasources/weather_api_datasource_impl.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherDatasource datasource;

  WeatherRepositoryImpl({WeatherDatasource? datasource})
      : datasource = datasource ?? WeatherApiDatasourceImpl();

  @override
  Future<WeatherData> getWeatherData(Location location) {
    return datasource.getWeatherData(location);
  }

  // @override
  // Future<CurrentWeather> getCurrentWeather(Location location) {
  //   return datasource.getCurrentWeather(location);
  // }

  // @override
  // Future<List<DailyWeather>> getDailyWeather(Location location) {
  //   return datasource.getDailyWeather(location);
  // }

  // @override
  // Future<List<HourlyWeather>> getHourlyWeather(Location location) {
  //   return datasource.getHourlyWeather(location);
  // }
}
