class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ServerException extends AppException {
  ServerException(super.message, {super.code});
}

class CacheException extends AppException {
  CacheException(super.message);
}

class LocationException extends AppException {
  LocationException(super.message);
}
