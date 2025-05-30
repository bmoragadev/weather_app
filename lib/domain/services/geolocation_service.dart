import 'package:geolocator/geolocator.dart';

abstract class GeolocationService {
  // Future<int> handleLocationPermission();
  Future<Position> getCurrentPosition();
  Future<String?> getCurrentCity(Position position);
}
