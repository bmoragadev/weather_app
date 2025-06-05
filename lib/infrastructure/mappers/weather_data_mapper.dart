import 'package:miniweather/infrastructure/mappers/current_weather_mapper.dart';
import 'package:miniweather/infrastructure/mappers/daily_weather_mapper.dart';
import '../../domain/entities/weather_data.dart';

class WeatherDataMapper {
  static WeatherData fromJson(Map<String, dynamic> json) {
    final current = CurrentWeatherMapper.fromJson(json['current']);
    final forecastDays = json['forecast']['forecastday'] as List;
    final daily = DailyWeatherMapper.fromJson(forecastDays);
    final DateTime fetchTime = DateTime.parse(json['location']['localtime']);

    return WeatherData(current: current, daily: daily, fetchTime: fetchTime);
  }

  static Map<String, dynamic> toJson(WeatherData data) {
    return {
      'location': {
        'localtime': data.fetchTime.toIso8601String(),
      },
      'current': CurrentWeatherMapper.toJson(data.current),
      'forecast': {
        'forecastday': DailyWeatherMapper.toJson(data.daily),
      }
    };
  }
}
