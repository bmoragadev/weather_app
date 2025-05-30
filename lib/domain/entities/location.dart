import 'package:geolocator/geolocator.dart';

class Location {
  final Position? position;
  final String cityName;

  Location({
    required this.position,
    required this.cityName,
  });
}
