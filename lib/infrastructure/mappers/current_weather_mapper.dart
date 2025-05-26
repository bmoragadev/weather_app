import 'package:miniweather/domain/entities/current_weather.dart';

class CurrentWeatherMapper {
  static CurrentWeather fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
        temperature: json['temp_c']?.toDouble() ?? 0.0,
        conditionCode: json['condition']['code'],
        isDay: json['is_day'] == 1);
  }

  static Map<String, dynamic> toJson(CurrentWeather current) {
    return {
      'temp_c': current.temperature,
      'condition': {
        'code': current.conditionCode,
      },
      'is_day': current.isDay ? 1 : 0,
    };
  }
}
