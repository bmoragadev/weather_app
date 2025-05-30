import 'package:miniweather/config/constants/temp_unit.dart';
import 'package:miniweather/domain/datasources/local_storage_datasource.dart';
import 'package:miniweather/domain/entities/location.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/domain/repositories/local_storage_repository.dart';
// import 'package:miniweather/infrastructure/datasources/local_storage/sharedpreferences_datasource_impl.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl({LocalStorageDatasource? datasource})
      : datasource = datasource!;

  @override
  Future<Location?> loadLocation() {
    return datasource.loadLocation();
  }

  @override
  Future<TempUnit?> loadTempUnit() {
    return datasource.loadTempUnit();
  }

  @override
  Future<WeatherData?> loadWeatherData() {
    return datasource.loadWeatherData();
  }

  @override
  Future<void> saveLocation(Location location) {
    return datasource.saveLocation(location);
  }

  @override
  Future<void> saveTempUnit(TempUnit tempUnit) {
    return datasource.saveTempUnit(tempUnit);
  }

  @override
  Future<void> saveWeatherData(WeatherData weatherData) {
    return datasource.saveWeatherData(weatherData);
  }
}
