import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/infrastructure/mappers/current_weather_mapper.dart';
import 'package:miniweather/infrastructure/mappers/daily_weather_mapper.dart';
import 'package:miniweather/config/errors/app_exception.dart';

class WeatherApiDatasourceImpl extends WeatherDatasource {
  late final Dio dio;

  WeatherApiDatasourceImpl()
      : dio = Dio(BaseOptions(
            baseUrl: dotenv.env["WEATHERAPI_BASE_URL"]!,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15)));

  @override
  Future<WeatherData> getWeatherData(Location location) async {
    try {
      final response = await dio.get('/forecast.json', queryParameters: {
        'key': dotenv.env["WEATHERAPI_KEY"],
        'q': '${location.position!.latitude},${location.position!.longitude}',
        'days': 3,
      });

      final data = response.data;

      final current = CurrentWeatherMapper.fromJson(data['current']);
      final daily =
          DailyWeatherMapper.fromJson(data['forecast']['forecastday']);
      final DateTime fetchTime = DateTime.parse(data['location']['localtime']);

      return WeatherData(current: current, daily: daily, fetchTime: fetchTime);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error',
            code: e.response?.statusCode?.toString());
      }
    } catch (error) {
      throw AppException('Error fetching weather: $error');
    }
  }
}
