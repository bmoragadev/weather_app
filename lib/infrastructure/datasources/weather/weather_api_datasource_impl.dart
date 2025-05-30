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

  @override
  Future<WeatherData> getWeatherData(Location location) async {
    try {
      final response = await dio.get('/forecast.json', queryParameters: {
        'key': dotenv.env["WEATHERAPI_KEY"],
        'q': '${location.position!.latitude},${location.position!.longitude}',
        'days': 7,
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
