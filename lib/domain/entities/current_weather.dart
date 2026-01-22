class CurrentWeather {
  final double temperature;
  final int conditionCode;
  final bool isDay;
  final double feelsLike;
  final int humidity;
  final double windKph;
  final double uv;

  CurrentWeather({
    required this.temperature,
    required this.conditionCode,
    required this.isDay,
    required this.feelsLike,
    required this.humidity,
    required this.windKph,
    required this.uv,
  });
}
