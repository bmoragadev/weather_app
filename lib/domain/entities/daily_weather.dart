import 'package:miniweather/domain/entities/hourly_weather.dart';

class DailyWeather {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final int conditionCode;
  final List<HourlyWeather> hourly;

  DailyWeather({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.conditionCode,
    required this.hourly,
  });
}
