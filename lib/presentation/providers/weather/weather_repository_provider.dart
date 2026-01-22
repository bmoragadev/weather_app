import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/domain/domain.dart';
import 'package:miniweather/infrastructure/repositories/weather_repository_impl.dart';

import 'package:miniweather/presentation/providers/weather/weather_datasource_provider.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final datasource = ref.watch(weatherDatasourceProvider);
  return WeatherRepositoryImpl(datasource: datasource);
});
