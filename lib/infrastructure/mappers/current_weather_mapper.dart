import 'package:miniweather/domain/entities/current_weather.dart';

class CurrentWeatherMapper {
  static CurrentWeather fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temp_c']?.toDouble() ?? 0.0,
      conditionCode: json['condition']['code'],
      isDay: json['is_day'] == 1,
      feelsLike: json['feelslike_c']?.toDouble() ?? 0.0,
      humidity: json['humidity']?.toInt() ?? 0,
      windKph: json['wind_kph']?.toDouble() ?? 0.0,
      uv: json['uv']?.toDouble() ?? 0.0,
    );
  }

  static Map<String, dynamic> toJson(CurrentWeather current) {
    return {
      'temp_c': current.temperature,
      'condition': {
        'code': current.conditionCode,
      },
      'is_day': current.isDay ? 1 : 0,
      'feelslike_c': current.feelsLike,
      'humidity': current.humidity,
      'wind_kph': current.windKph,
      'uv': current.uv,
    };
  }
}
