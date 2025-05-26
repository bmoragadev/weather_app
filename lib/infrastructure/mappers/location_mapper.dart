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
      "longitude": location.position.longitude,
      "latitude": location.position.latitude,
      "timestamp": location.position.timestamp.toString(),
      "accuracy": location.position.accuracy,
      "altitude": location.position.altitude,
      "altitudeAccuracy": location.position.altitudeAccuracy,
      "heading": location.position.heading,
      "headingAccuracy": location.position.headingAccuracy,
      "speed": location.position.speed,
      "speedAccuracy": location.position.speedAccuracy,
      "cityName": location.cityName,
    };
  }
}
