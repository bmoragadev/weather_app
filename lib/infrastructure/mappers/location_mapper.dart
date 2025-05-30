import 'package:geolocator/geolocator.dart';
import 'package:miniweather/config/helpers/parsing.dart';

import '../../domain/domain.dart';

class LocationMapper {
  static Location fromJson(Map<String, dynamic> json) {
    return Location(
      position: Position(
          longitude: Parsing.tryDouble(json["longitude"]),
          latitude: Parsing.tryDouble(json["latitude"]),
          timestamp: DateTime.parse(json["timestamp"]),
          accuracy: Parsing.tryDouble(json["accuracy"]),
          altitude: Parsing.tryDouble(json["altitude"]),
          altitudeAccuracy: Parsing.tryDouble(json["altitudeAccuracy"]),
          heading: Parsing.tryDouble(json["heading"]),
          headingAccuracy: Parsing.tryDouble(json["headingAccuracy"]),
          speed: Parsing.tryDouble(json["speed"]),
          speedAccuracy: Parsing.tryDouble(json["speedAccuracy"])),
      cityName: json["cityName"],
    );
  }

  static Map<String, dynamic> toJson(Location location) {
    return {
      "longitude": location.position?.longitude ?? 0.0,
      "latitude": location.position?.latitude ?? 0.0,
      "timestamp": location.position?.timestamp.toString() ?? "",
      "accuracy": location.position?.accuracy ?? 0.0,
      "altitude": location.position?.altitude ?? '.',
      "altitudeAccuracy": location.position?.altitudeAccuracy ?? 0.0,
      "heading": location.position?.heading ?? 0.0,
      "headingAccuracy": location.position?.headingAccuracy ?? 0.0,
      "speed": location.position?.speed ?? 0.0,
      "speedAccuracy": location.position?.speedAccuracy ?? 0.0,
      "cityName": location.cityName,
    };
  }
}
