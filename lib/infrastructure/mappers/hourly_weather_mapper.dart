import 'package:miniweather/domain/entities/hourly_weather.dart';

class HourlyWeatherMapper {
  static List<HourlyWeather> fromJson(List<dynamic> hourlyList) {
    return hourlyList.map((hourJson) {
      return HourlyWeather(
        time: DateTime.parse(hourJson['time']),
        temperature: hourJson['temp_c']?.toDouble() ?? 0.0,
        conditionCode: hourJson['condition']['code'],
        isDay: hourJson['is_day'] == 1,
      );
    }).toList();
  }

  static List<Map<String, dynamic>> toJson(List<HourlyWeather> hourlyList) {
    return hourlyList.map((hour) {
      return {
        'time': hour.time.toIso8601String(),
        'temp_c': hour.temperature,
        'condition': {
          'code': hour.conditionCode,
        },
        'is_day': hour.isDay ? 1 : 0,
      };
    }).toList();
  }
}
