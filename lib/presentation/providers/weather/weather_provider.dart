import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/config/constants/error_codes.dart';
import 'package:miniweather/config/constants/temp_unit.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/domain/repositories/local_storage_repository.dart';
import 'package:miniweather/presentation/providers/local_storage/local_storage_repository_provider.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/domain/services/geolocation_service.dart';
// import 'package:miniweather/infrastructure/mappers/location_mapper.dart';
import 'package:miniweather/infrastructure/services/geolocation_service_impl.dart';
import 'package:miniweather/presentation/providers/weather/weather_repository_provider.dart';

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final weatherRepository = ref.watch(weatherRepositoryProvider);
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  final geolocationServiceImpl = GeolocationServiceImpl();

  return WeatherNotifier(
    weatherRepository: weatherRepository,
    geolocationService: geolocationServiceImpl,
    localStorageRepository: localStorageRepository,
  );
});

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository weatherRepository;
  final GeolocationService geolocationService;
  final LocalStorageRepository localStorageRepository;

  DateTime? _lastRefresh;

  WeatherNotifier(
      {required this.weatherRepository,
      required this.geolocationService,
      required this.localStorageRepository})
      : super(WeatherState()) {
    _loadTempUnit();
    refreshWeather();
  }

  Future<void> saveWeatherData() async {
    // SharedPreferences localStorage = App.localStorage;

    localStorageRepository.saveWeatherData(state.weatherData!);
    localStorageRepository.saveLocation(state.currentLocation!);
    localStorageRepository.saveTempUnit(state.tempUnit ?? TempUnit.celsius);

    // String weatherDataJson =
    //     jsonEncode(WeatherDataMapper.toJson(state.weatherData!));
    // // String locationJson =
    // //     jsonEncode(LocationMapper.toJson(state.currentLocation!));

    // localStorage.setString("weatherData", weatherDataJson);
    // // localStorage.setString("location", locationJson);
    // localStorage.setString(
    //     "tempUnit", (state.tempUnit ?? TempUnit.celsius).toString());
  }

  Future<void> loadLocalWeather() async {
    try {
      WeatherData? weatherData = await localStorageRepository.loadWeatherData();
      Location? location = await localStorageRepository.loadLocation();
      TempUnit? tempUnit = await localStorageRepository.loadTempUnit();

      if (weatherData == null || location == null) {
        if (tempUnit == null) {
          state = state.copyWith(
            tempUnit: TempUnit.celsius,
          );
        }
        state = state.copyWith(isLoading: false, error: ErrorCode.noLocalData);
        return;
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
      final location = await getCurrentLocation();
      if (location == null) {
        state = state.copyWith(isLoading: false, error: ErrorCode.locationOff);
        return;
      }

      final weatherData = await weatherRepository.getWeatherData(location);

      state = state.copyWith(
        isLoading: false,
        weatherData: weatherData,
        currentLocation: location,
      );
      _lastRefresh = DateTime.now();
      await saveWeatherData();
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

  int getCurrentTemperature() {
    if (state.weatherData == null ||
        state.weatherData!.daily.isEmpty ||
        state.weatherData!.daily[0].hourly.isEmpty) {
      return 999;
    }
    int index = getCurrentMinIndex();
    return state.weatherData!.daily[0].hourly[index].temperature.toInt();
  }

  bool? getCurrentIsDay() {
    if (state.weatherData == null ||
        state.weatherData!.daily.isEmpty ||
        state.weatherData!.daily[0].hourly.isEmpty) {
      return null;
    }
    int index = getCurrentMinIndex();
    return state.weatherData!.daily[0].hourly[index].isDay;
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
    // final geolocationPermission =
    //     await geolocationService.handleLocationPermission();
    // if (geolocationPermission != 0) {
    //   // state = state.copyWith(currentLocation: null, isLoading: true);
    //   return null;
    // }

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
    final now = DateTime.now();
    if (_lastRefresh != null && now.difference(_lastRefresh!).inMinutes < 60) {
      return;
    }

    state = state.copyWith(isLoading: true, error: ErrorCode.none);

    var connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = !connectivityResult.contains(ConnectivityResult.none);

    if (!hasInternet) {
      await loadLocalWeather();
      if (state.error != ErrorCode.noLocalData) {
        state = state.copyWith(isLoading: false, error: ErrorCode.noInternet);
      }
      return;
    }

    // state = state.copyWith(isLoading: true);
    await loadWeather();
  }

  Future<void> forceRefreshWeather() async {
    _lastRefresh = null;
    await refreshWeather();
  }

  Future<void> _loadTempUnit() async {
    try {
      TempUnit? tempUnitLoaded = await localStorageRepository.loadTempUnit();
      state = state.copyWith(tempUnit: tempUnitLoaded ?? TempUnit.celsius);
    } catch (e) {
      state = state.copyWith(tempUnit: TempUnit.celsius);
    }
  }

  Future<void> setTempUnit(TempUnit tempUnit) async {
    state = state.copyWith(
      tempUnit: tempUnit,
    );
    await localStorageRepository.saveTempUnit(tempUnit);
  }

  void setLoading(bool flag) {
    state = state.copyWith(isLoading: flag);
  }

  void setError(ErrorCode errorCode) {
    state = state.copyWith(error: errorCode);
  }
}

class WeatherState {
  final WeatherData? weatherData;
  final Location? currentLocation;
  final TempUnit? tempUnit;
  final bool isLoading;
  final ErrorCode error;

  WeatherState({
    this.weatherData,
    this.currentLocation,
    this.tempUnit,
    this.isLoading = true,
    this.error = ErrorCode.none,
  });

  WeatherState copyWith({
    WeatherData? weatherData,
    Location? currentLocation,
    TempUnit? tempUnit,
    bool? isLoading,
    ErrorCode? error,
  }) =>
      WeatherState(
        weatherData: weatherData ?? this.weatherData,
        currentLocation: currentLocation ?? this.currentLocation,
        tempUnit: tempUnit ?? this.tempUnit,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
