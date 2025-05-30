import '../../config/constants/temp_unit.dart';
import '../entities/location.dart';
import '../entities/weather_data.dart';

abstract class LocalStorageRepository {
  Future<void> saveWeatherData(WeatherData weatherData);
  Future<WeatherData?> loadWeatherData();

  Future<void> saveTempUnit(TempUnit tempUnit);
  Future<TempUnit?> loadTempUnit();

  Future<void> saveLocation(Location location);
  Future<Location?> loadLocation();
}
