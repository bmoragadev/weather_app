class HourlyWeather {
  final DateTime time;
  final double temperature;
  final int conditionCode;
  final bool isDay;

  HourlyWeather(
      {required this.time,
      required this.temperature,
      required this.conditionCode,
      required this.isDay});
}
