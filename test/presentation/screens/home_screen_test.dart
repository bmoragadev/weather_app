import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:miniweather/presentation/screens/home_screen.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:miniweather/presentation/providers/weather/weather_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:miniweather/l10n/app_localizations.dart';
import 'package:miniweather/presentation/providers/permissions/permissions_provider.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/domain/services/geolocation_service.dart';
import 'package:miniweather/domain/repositories/local_storage_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart'; // For Position
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/domain/entities/current_weather.dart';

import 'home_screen_test.mocks.dart';

class FakePermissionNotifier extends PermissionNotifier {
  @override
  Future<void> checkPermissions() async {
    state = state.copyWith(location: PermissionStatus.granted);
  }
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return '<svg viewBox="0 0 10 10"><rect x="0" y="0" width="10" height="10" /></svg>';
  }

  @override
  Future<ByteData> load(String key) async {
    return ByteData.view(Uint8List.fromList(utf8.encode(
            '<svg viewBox="0 0 10 10"><rect x="0" y="0" width="10" height="10" /></svg>'))
        .buffer);
  }
}

@GenerateMocks([
  WeatherRepository,
  LocalStorageRepository,
  GeolocationService,
  Connectivity
])
void main() {
  late MockWeatherRepository mockWeatherRepository;
  late MockLocalStorageRepository mockLocalStorageRepository;
  late MockGeolocationService mockGeolocationService;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    mockLocalStorageRepository = MockLocalStorageRepository();
    mockGeolocationService = MockGeolocationService();
    mockConnectivity = MockConnectivity();

    // Default stubs to prevent crashes
    when(mockLocalStorageRepository.loadTempUnit())
        .thenAnswer((_) async => null);
    when(mockLocalStorageRepository.loadWeatherData())
        .thenAnswer((_) async => null);
    when(mockLocalStorageRepository.loadLocation())
        .thenAnswer((_) async => null);
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);

    // Stub Geolocation
    when(mockGeolocationService.getCurrentPosition()).thenAnswer((_) async =>
        Position(
            longitude: 0,
            latitude: 0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0));

    when(mockWeatherRepository.getWeatherData(any)).thenAnswer((_) async {
      return WeatherData(
          current: CurrentWeather(
            temperature: 20,
            conditionCode: 1000,
            isDay: true,
            feelsLike: 22,
            humidity: 50,
            windKph: 10,
            uv: 3,
          ),
          daily: [],
          fetchTime: DateTime.now());
    });
  });

  testWidgets('HomeScreen should render', skip: true,
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          permissionsProvider.overrideWith((ref) => FakePermissionNotifier()),
          weatherProvider.overrideWith((ref) => WeatherNotifier(
                weatherRepository: mockWeatherRepository,
                geolocationService: mockGeolocationService,
                localStorageRepository: mockLocalStorageRepository,
                connectivity: mockConnectivity,
              )),
        ],
        child: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(),
          ),
        ),
      ),
    );
    // Allow async calls to finish
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Localization works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Text(AppLocalizations.of(context)!.app_name);
        }),
      ),
    );
    await tester.pump();
    expect(find.text('MiniWeather'), findsOneWidget);
  });
}
