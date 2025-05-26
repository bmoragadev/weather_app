import '../entities/location.dart';
import '../entities/weather_data.dart';
// import '../entities/hourly_weather.dart';
// import '../entities/daily_weather.dart';

abstract class WeatherRepository {
  // Future<Weather> getCurrentWeather(Location location);
  // Future<WeatherDaily> getWeekWeather(Location location);
  // Future<CurrentWeather> getCurrentWeather(Location location);
  // Future<List<HourlyWeather>> getHourlyWeather(Location location);
  // Future<List<DailyWeather>> getDailyWeather(Location location);

  Future<WeatherData> getWeatherData(Location location);
}
