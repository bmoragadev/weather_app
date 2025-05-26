import '../entities/location.dart';
import '../entities/weather_data.dart';

abstract class WeatherDatasource {
  // Future<Weather> getCurrentWeather(Location location);
  // Future<WeatherDaily> getWeekWeather(Location location);

  // Future<CurrentWeather> getCurrentWeather(Location location);
  // Future<List<HourlyWeather>> getHourlyWeather(Location location);
  // Future<List<DailyWeather>> getDailyWeather(Location location);

  Future<WeatherData> getWeatherData(Location location);
}
