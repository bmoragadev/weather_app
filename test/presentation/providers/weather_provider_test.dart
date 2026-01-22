import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/config/constants/error_codes.dart';
import 'package:miniweather/config/constants/temp_unit.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/presentation/providers/weather/weather_provider.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/domain/entities/current_weather.dart';
import 'package:miniweather/domain/repositories/local_storage_repository.dart';
import 'package:miniweather/domain/services/geolocation_service.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'weather_provider_test.mocks.dart';

@GenerateMocks([
  WeatherRepository,
  GeolocationService,
  LocalStorageRepository,
  Connectivity
])
void main() {
  late WeatherNotifier notifier;
  late MockWeatherRepository mockRepository;
  late MockGeolocationService mockGeolocation;
  late MockLocalStorageRepository mockLocalStorage;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockRepository = MockWeatherRepository();
    mockGeolocation = MockGeolocationService();
    mockLocalStorage = MockLocalStorageRepository();
    mockConnectivity = MockConnectivity();

    // Default stubs
    when(mockLocalStorage.loadTempUnit())
        .thenAnswer((_) async => TempUnit.celsius);
    when(mockLocalStorage.loadWeatherData()).thenAnswer((_) async => null);
    when(mockLocalStorage.loadLocation()).thenAnswer((_) async => null);
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
  });

  WeatherNotifier buildNotifier() {
    return WeatherNotifier(
      weatherRepository: mockRepository,
      geolocationService: mockGeolocation,
      localStorageRepository: mockLocalStorage,
      connectivity: mockConnectivity,
    );
  }

  test('initial state should be loading using loadTempUnit', () async {
    notifier = buildNotifier();
    expect(notifier.state.isLoading, true);
    // You might need to wait for async init in real scenario or modify Notifier to be testable
  });
}
