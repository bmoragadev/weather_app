import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/infrastructure/mappers/weather_data_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:miniweather/config/globals/globals.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/domain/services/geolocation_service.dart';
import 'package:miniweather/infrastructure/mappers/location_mapper.dart';
import 'package:miniweather/infrastructure/services/geolocation_service_impl.dart';
import 'package:miniweather/presentation/providers/weather_repository_provider.dart';

enum TempUnit { celsius, fahrenheit }

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final weatherRepository = ref.watch(weatherRepositoryProvider);

  return WeatherNotifier(weatherRepository: weatherRepository);
});

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository weatherRepository;
  final GeolocationService geolocationService;

  WeatherNotifier({required this.weatherRepository})
      : geolocationService = GeolocationServiceImpl(),
        super(WeatherState()) {
    loadLocalWeather();
    loadWeather();
  }

  Future<void> saveWeatherData() async {
    SharedPreferences localStorage = App.localStorage;

    String weatherDataJson =
        jsonEncode(WeatherDataMapper.toJson(state.weatherData!));
    String locationJson =
        jsonEncode(LocationMapper.toJson(state.currentLocation!));

    localStorage.setString("weatherData", weatherDataJson);
    localStorage.setString("location", locationJson);
    localStorage.setString("tempUnit", state.tempUnit.toString());
  }

  Future<void> loadLocalWeather() async {
    try {
      SharedPreferences localStorage = App.localStorage;

      String? weatherDataEncoded = localStorage.getString("weatherData");
      String? locationEncoded = localStorage.getString("location");
      String? tempUnitString = localStorage.getString("tempUnit");

      if (weatherDataEncoded == null || locationEncoded == null) {
        if (tempUnitString == null) {
          state = state.copyWith(
            tempUnit: TempUnit.celsius,
          );
        }
        return;
      }

      Map<String, dynamic> weatherDataJson = jsonDecode(weatherDataEncoded);
      Map<String, dynamic> locationJson = jsonDecode(locationEncoded);

      WeatherData weatherData = WeatherDataMapper.fromJson(weatherDataJson);
      Location location = LocationMapper.fromJson(locationJson);

      TempUnit tempUnit;
      if (tempUnitString == 'TempUnit.fahrenheit') {
        tempUnit = TempUnit.fahrenheit;
      } else {
        tempUnit = TempUnit.celsius;
      }

      state = state.copyWith(
        isLoading: false,
        weatherData: weatherData,
        currentLocation: location,
        tempUnit: tempUnit,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> loadWeather() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        loadLocalWeather();

        return;
      }

      final location = await getCurrentLocation();
      if (location == null) return;

      final weatherData = await weatherRepository.getWeatherData(location);

      state = state.copyWith(
        isLoading: false,
        weatherData: weatherData,
        currentLocation: location,
      );

      saveWeatherData();
    } catch (e) {
      throw Exception(e);
    }
  }

  int _findClosestTimeIndex(List<DateTime> time) {
    DateTime now = DateTime.now();
    int closestIndex = 0;
    Duration smallestDifference = now.difference(time[0]).abs();

    for (int i = 0; i < time.length; i++) {
      Duration difference = now.difference(time[i]).abs();
      if (difference < smallestDifference) {
        smallestDifference = difference;
        closestIndex = i;
      }
    }
    return closestIndex;
  }

  int _findClosestTimeIndex2(List<DateTime> times) {
    DateTime now = DateTime.now();
    return times.asMap().entries.reduce((a, b) {
      final diffA = now.difference(a.value).abs();
      final diffB = now.difference(b.value).abs();
      return diffA < diffB ? a : b;
    }).key;
  }

  int getCurrentTemperature() {
    if (state.weatherData == null ||
        state.weatherData!.daily.isEmpty ||
        state.weatherData!.daily[0].hourly.isEmpty) {
      return 999;
    }
    int index = getCurrentMinIndex();
    return state.weatherData!.daily[0].hourly[index].temperature.toInt();
  }

  int getCurrentMinIndex() {
    if (state.weatherData == null ||
        state.weatherData!.daily.isEmpty ||
        state.weatherData!.daily[0].hourly.isEmpty) {
      return 999;
    }
    //int index = _findClosestTimeIndex(state.weather!.time);
    List<DateTime> time =
        state.weatherData!.daily[0].hourly.map((h) => h.time).toList();
    return _findClosestTimeIndex(time);
  }

  int getCurrentWeatherCode() {
    if (state.weatherData == null ||
        state.weatherData!.daily.isEmpty ||
        state.weatherData!.daily[0].hourly.isEmpty) {
      return -1;
    }
    int index = getCurrentMinIndex();
    if (index < 0 || index >= state.weatherData!.daily[0].hourly.length) {
      return -1;
    }
    return state.weatherData!.daily[0].hourly[index].conditionCode.toInt();
  }

  Future<Location?> getCurrentLocation() async {
    final geolocationPermission =
        await geolocationService.handleLocationPermission();
    if (geolocationPermission != 0) {
      // state = state.copyWith(currentLocation: null, isLoading: true);
      return null;
    }

    final currentPosition = await geolocationService.getCurrentPosition();
    final currentCity =
        await geolocationService.getCurrentCity(currentPosition);
    // state = state.copyWith(
    //   currentLocation:
    //       Location(position: currentPosition, cityName: currentCity!),
    // );
    return Location(position: currentPosition, cityName: currentCity!);
  }

  Future<void> refreshWeather() async {
    state = state.copyWith(isLoading: true);
    loadWeather();
  }

  TempUnit _loadLocalTempUnit() {
    try {
      SharedPreferences localStorage = App.localStorage;

      String? tempUnitString = localStorage.getString("tempUnit");

      TempUnit tempUnit;
      if (tempUnitString == 'fahrenheit') {
        tempUnit = TempUnit.fahrenheit;
      } else {
        tempUnit = TempUnit.celsius;
      }

      return tempUnit;
    } catch (e) {
      throw Exception(e);
    }
  }

  TempUnit getTempUnit() {
    return state.tempUnit ?? _loadLocalTempUnit();
  }

  Future<void> setTempUnit(TempUnit tempUnit) async {
    state = state.copyWith(
      tempUnit: tempUnit,
    );

    saveWeatherData();
  }
}

class WeatherState {
  final WeatherData? weatherData;
  final Location? currentLocation;
  final TempUnit? tempUnit;
  final bool isLoading;

  WeatherState({
    this.weatherData,
    this.currentLocation,
    this.tempUnit,
    this.isLoading = true,
  });

  WeatherState copyWith({
    WeatherData? weatherData,
    Location? currentLocation,
    TempUnit? tempUnit,
    bool? isLoading,
  }) =>
      WeatherState(
        weatherData: weatherData ?? this.weatherData,
        currentLocation: currentLocation ?? this.currentLocation,
        tempUnit: tempUnit ?? this.tempUnit,
        isLoading: isLoading ?? this.isLoading,
      );
}
