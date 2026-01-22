import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:miniweather/domain/services/geolocation_service.dart';
import 'package:miniweather/config/errors/app_exception.dart';

class GeolocationServiceImpl extends GeolocationService {
  // @override
  // Future<int> handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return -1;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return -2;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return -3;
  //   }

  //   return 0;
  // }

  @override
  Future<Position> getCurrentPosition() async {
    try {
      final currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5));
      return currentPosition;
    } catch (e) {
      throw LocationException('Failed to get location: $e');
    }
  }

  @override
  Future<String?> getCurrentCity(Position position) async {
    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    final currentCity = placemarks[0];

    return currentCity.locality!;
  }
}
