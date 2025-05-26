import 'package:miniweather/domain/entities/current_weather.dart';
import 'package:miniweather/domain/entities/daily_weather.dart';

class WeatherData {
  final CurrentWeather current;
  final List<DailyWeather> daily;

  WeatherData({required this.current, required this.daily});
}
