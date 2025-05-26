import 'package:miniweather/domain/entities/daily_weather.dart';
import 'package:miniweather/domain/entities/hourly_weather.dart';

class DailyWeatherMapper {
  static List<DailyWeather> fromJson(List<dynamic> forecastDays) {
    return forecastDays.map((dayJson) {
      final hourlyList = dayJson['hour']
          .cast<Map<String, dynamic>>()
          .map<HourlyWeather>((hourJson) {
        return HourlyWeather(
            time: DateTime.parse(hourJson['time']),
            temperature: hourJson['temp_c']?.toDouble() ?? 0.0,
            conditionCode: hourJson['condition']['code'],
            isDay: hourJson['is_day'] == 1);
      }).toList();

      return DailyWeather(
        date: DateTime.parse(dayJson['date']),
        minTemp: dayJson['day']['mintemp_c']?.toDouble() ?? 0.0,
        maxTemp: dayJson['day']['maxtemp_c']?.toDouble() ?? 0.0,
        conditionCode: dayJson['day']['condition']['code'],
        hourly: hourlyList,
      );
    }).toList();
  }

  static List<Map<String, dynamic>> toJson(List<DailyWeather> dailyList) {
    return dailyList.map((day) {
      return {
        'date': day.date.toIso8601String(),
        'day': {
          'mintemp_c': day.minTemp,
          'maxtemp_c': day.maxTemp,
          'condition': {
            'code': day.conditionCode,
          },
        },
        'hour': day.hourly.map((hour) {
          return {
            'time': hour.time.toIso8601String(),
            'temp_c': hour.temperature,
            'condition': {'code': hour.conditionCode},
            'is_day': hour.isDay ? 1 : 0,
          };
        }).toList(),
      };
    }).toList();
  }
}
