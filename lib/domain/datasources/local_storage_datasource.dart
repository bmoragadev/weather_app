import 'package:miniweather/config/constants/temp_unit.dart';
import 'package:miniweather/domain/entities/weather_data.dart';

import '../entities/location.dart';

abstract class LocalStorageDatasource {
  Future<void> saveWeatherData(WeatherData weatherData);
  Future<WeatherData?> loadWeatherData();

  Future<void> saveTempUnit(TempUnit tempUnit);
  Future<TempUnit?> loadTempUnit();

  Future<void> saveLocation(Location location);
  Future<Location?> loadLocation();
}
