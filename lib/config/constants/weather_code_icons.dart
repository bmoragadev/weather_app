class WeatherCodeIcons {
  static String headPath = 'assets/icons/';

  static Map<String, List<int>> weatherCodeGroups = {
    'clear': [1000],
    'partly_cloudy': [1003],
    'cloudy': [1006, 1009],
    'foggy': [1030, 1135, 1147],
    'rainy': [1063, 1180, 1183, 1189, 1240, 1243, 1246],
    'snowy': [1066, 1210, 1213, 1216, 1219, 1222, 1225, 1255, 1258],
    'hail': [1237, 1261, 1264],
    'thunderstorm': [1087, 1273, 1276, 1279, 1282],
  };

  static Map<String, String> weatherIconData = {
    'clear': 'sunny.svg',
    'partly_cloudy': 'partly_cloudy_day.svg',
    'cloudy': 'cloud.svg',
    'foggy': 'foggy.svg',
    'rainy': 'rainy.svg',
    'snowy': 'cloudy_snowing',
    'hail': 'weather_hail.svg',
    'thunderstorm': 'thunderstorm.svg',
  };

  static String getIcon(int code) {
    for (final entry in weatherCodeGroups.entries) {
      if (entry.value.contains(code)) {
        String iconKey = entry.key;
        return headPath +
            (weatherIconData[iconKey] ?? weatherIconData['clear']!);
      }
    }
    return headPath + weatherIconData['clear']!;

    // String icon = weatherIconData['clear']!;
    // if (code == 0) {
    //   icon = weatherIconData['clear']!;
    // } else if (code == 1) {
    //   icon = weatherIconData['partly_cloudy']!;
    // } else if (code >= 2 && code <= 3) {
    //   icon = weatherIconData['cloudy']!;
    // } else if (code >= 45 && code <= 48) {
    //   icon = weatherIconData['foggy']!;
    // } else if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
    //   icon = weatherIconData['rainy']!;
    // } else if ((code >= 71 && code <= 75) || (code >= 85 && code <= 86)) {
    //   icon = weatherIconData['snowy']!;
    // } else if (code == 95) {
    //   icon = weatherIconData['thunderstorm']!;
    // } else if (code == 77 && (code >= 96 && code <= 99)) {
    //   icon = weatherIconData['weather_hail']!;
    // }

    // return (headPath + icon);
  }
}
