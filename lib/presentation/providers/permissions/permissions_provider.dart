import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionsProvider =
    StateNotifierProvider<PermissionNotifier, PermissionsState>((ref) {
  return PermissionNotifier();
});

class PermissionNotifier extends StateNotifier<PermissionsState> {
  PermissionNotifier() : super(PermissionsState()) {
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    final permissionsArray = await Future.wait([
      Permission.location.status,
      Permission.locationAlways.status,
      Permission.locationWhenInUse.status,
    ]);

    state = state.copyWith(
      location: permissionsArray[0],
      locationAlways: permissionsArray[1],
      locationWhenInUse: permissionsArray[2],
    );
  }

  void _checkPermissionState(PermissionStatus status) {
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  void requestLocationAccess() async {
    final status = await Permission.location.request();
    state = state.copyWith(location: status);

    _checkPermissionState(status);
  }

  void requestLocationAlwaysAccess() async {
    final status = await Permission.locationAlways.request();
    state = state.copyWith(locationAlways: status);

    _checkPermissionState(status);
  }

  void requestLocationWhenInUse() async {
    final status = await Permission.locationWhenInUse.request();
    state = state.copyWith(locationWhenInUse: status);

    _checkPermissionState(status);
  }
}

class PermissionsState {
  final PermissionStatus location;
  final PermissionStatus locationAlways;
  final PermissionStatus locationWhenInUse;

  PermissionsState({
    this.location = PermissionStatus.denied,
    this.locationAlways = PermissionStatus.denied,
    this.locationWhenInUse = PermissionStatus.denied,
  });

  get locationGranted {
    return location == PermissionStatus.granted;
  }

  get locationAlwasGranted {
    return locationAlways == PermissionStatus.granted;
  }

  get locationWhenInUseGranted {
    return locationWhenInUse == PermissionStatus.granted;
  }

  PermissionsState copyWith({
    PermissionStatus? location,
    PermissionStatus? locationAlways,
    PermissionStatus? locationWhenInUse,
  }) =>
      PermissionsState(
        location: location ?? this.location,
        locationAlways: locationAlways ?? this.locationAlways,
        locationWhenInUse: locationWhenInUse ?? this.locationWhenInUse,
      );
}
