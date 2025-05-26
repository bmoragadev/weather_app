import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/infrastructure/repositories/weather_repository_impl.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final weatherRepository = WeatherRepositoryImpl();

  return weatherRepository;
});
