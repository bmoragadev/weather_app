import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/infrastructure/repositories/weather_repository_impl.dart';
import 'package:miniweather/domain/entities/weather_data.dart';
import 'package:miniweather/domain/entities/current_weather.dart';
import 'package:miniweather/domain/entities/daily_weather.dart';

import 'weather_repository_test.mocks.dart';

@GenerateMocks([WeatherDatasource])
void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockWeatherDatasource();
    repository = WeatherRepositoryImpl(datasource: mockDatasource);
  });

  final tLocation = Location(position: null, cityName: 'London');
  final tCurrentWeather = CurrentWeather(
    temperature: 20.0,
    conditionCode: 1003,
    isDay: true,
    feelsLike: 22.0,
    humidity: 60,
    windKph: 15.0,
    uv: 5.0,
  );
  final tWeatherData = WeatherData(
    current: tCurrentWeather,
    daily: [],
    fetchTime: DateTime.now(),
  );

  test('should return WeatherData when datasource call is successful',
      () async {
    // arrange
    when(mockDatasource.getWeatherData(any))
        .thenAnswer((_) async => tWeatherData);
    // act
    final result = await repository.getWeatherData(tLocation);
    // assert
    expect(result, tWeatherData);
    verify(mockDatasource.getWeatherData(tLocation));
    verifyNoMoreInteractions(mockDatasource);
  });

  test('should throw exception when datasource call fails', () async {
    // arrange
    when(mockDatasource.getWeatherData(any)).thenThrow(Exception());
    // act
    final call = repository.getWeatherData;
    // assert
    expect(() => call(tLocation), throwsException);
  });
}
