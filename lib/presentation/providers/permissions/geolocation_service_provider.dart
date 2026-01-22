import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/domain/services/geolocation_service.dart';
import 'package:miniweather/infrastructure/services/geolocation_service_impl.dart';

final geolocationServiceProvider = Provider<GeolocationService>((ref) {
  return GeolocationServiceImpl();
});
