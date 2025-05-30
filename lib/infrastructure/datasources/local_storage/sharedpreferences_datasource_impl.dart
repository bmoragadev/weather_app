import 'dart:convert';

import 'package:miniweather/config/constants/temp_unit.dart';
import 'package:miniweather/domain/datasources/local_storage_datasource.dart';
import 'package:miniweather/domain/entities/location.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mappers/location_mapper.dart';
import '../../mappers/weather_data_mapper.dart';

class SharedpreferencesDatasourceImpl extends LocalStorageDatasource {
  final SharedPreferences prefs;

  SharedpreferencesDatasourceImpl({required this.prefs});

  @override
  Future<Location?> loadLocation() async {
    try {
      String? locationEncoded = prefs.getString("location");
      if (locationEncoded == null) return null;
      Map<String, dynamic> locationJson = jsonDecode(locationEncoded);
      Location location = LocationMapper.fromJson(locationJson);
      return location;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<TempUnit?> loadTempUnit() async {
    try {
      String? tempUnitString = prefs.getString("tempUnit");
      TempUnit tempUnit;
      if (tempUnitString == 'TempUnit.fahrenheit') {
        tempUnit = TempUnit.fahrenheit;
      } else {
        tempUnit = TempUnit.celsius;
      }
      return tempUnit;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<WeatherData?> loadWeatherData() async {
    try {
      String? weatherDataEncoded = prefs.getString("weatherData");
      if (weatherDataEncoded == null) return null;
      Map<String, dynamic> weatherDataJson = jsonDecode(weatherDataEncoded);
      WeatherData weatherData = WeatherDataMapper.fromJson(weatherDataJson);
      return weatherData;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> saveLocation(Location location) async {
    try {
      String locationJson = jsonEncode(LocationMapper.toJson(location));
      prefs.setString("location", locationJson);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> saveTempUnit(TempUnit tempUnit) async {
    try {
      prefs.setString("tempUnit", (tempUnit).toString());
      // prefs.setString("tempUnit", (tempUnit ?? TempUnit.celsius).toString());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> saveWeatherData(WeatherData weatherData) async {
    try {
      String weatherDataJson =
          jsonEncode(WeatherDataMapper.toJson(weatherData));
      prefs.setString('weatherData', weatherDataJson);
    } catch (e) {
      throw Exception(e);
    }
  }
}
