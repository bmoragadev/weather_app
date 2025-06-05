import 'package:miniweather/domain/entities/current_weather.dart';
import 'package:miniweather/domain/entities/daily_weather.dart';

class WeatherData {
  final CurrentWeather current;
  final List<DailyWeather> daily;
  final DateTime fetchTime;

  WeatherData(
      {required this.current, required this.daily, required this.fetchTime});
}
