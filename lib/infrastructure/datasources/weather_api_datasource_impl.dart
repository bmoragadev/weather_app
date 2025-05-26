import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/infrastructure/mappers/current_weather_mapper.dart';
import 'package:miniweather/infrastructure/mappers/daily_weather_mapper.dart';

class WeatherApiDatasourceImpl extends WeatherDatasource {
  late final Dio dio;

  WeatherApiDatasourceImpl()
      : dio = Dio(BaseOptions(baseUrl: dotenv.env["WEATHERAPI_BASE_URL"]!));

  // Future<Response> _fetchForecast(Location location) {
  //   return dio.get('/forecast.json', queryParameters: {
  //     'key': dotenv.env["WEATHERAPI_KEY"],
  //     'q': '${location.position.latitude},${location.position.longitude}',
  //     'days': 7,
  //     'aqi': 'no',
  //     'alerts': 'no',
  //   });
  // }

  // @override
  // Future<CurrentWeather> getCurrentWeather(Location location) async {
  //   try {
  //     final response = await _fetchForecast(location);
  //     return CurrentWeatherMapper.fromJson(response.data);
  //   } catch (error) {
  //     throw Exception('Error fetching current weather: $error');
  //   }
  // }

  // @override
  // Future<List<HourlyWeather>> getHourlyWeather(Location location) async {
  //   try {
  //     final response = await _fetchForecast(location);
  //     return HourlyWeatherMapper.fromJson(response.data);
  //   } catch (error) {
  //     throw Exception('Error fetching hourly weather: $error');
  //   }
  // }

  // @override
  // Future<List<DailyWeather>> getDailyWeather(Location location) async {
  //   try {
  //     final response = await _fetchForecast(location);
  //     return DailyWeatherMapper.fromJson(response.data);
  //   } catch (error) {
  //     throw Exception('Error fetching daily weather: $error');
  //   }
  // }

  @override
  Future<WeatherData> getWeatherData(Location location) async {
    try {
      final response = await dio.get('/forecast.json', queryParameters: {
        'key': dotenv.env["WEATHERAPI_KEY"],
        'q': '${location.position.latitude},${location.position.longitude}',
        'days': 7,
        'aqi': 'no',
        'alerts': 'no',
      });

      final data = response.data;

      final current = CurrentWeatherMapper.fromJson(data['current']);
      final daily =
          DailyWeatherMapper.fromJson(data['forecast']['forecastday']);

      return WeatherData(current: current, daily: daily);
    } catch (error) {
      throw Exception('Error fetching weather: $error');
    }
  }
}
