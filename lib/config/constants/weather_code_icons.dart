class WeatherCodeIcons {
  static String headPath = 'assets/icons/';

  static Map<String, List<int>> weatherIconCodes = {
    'clear_day.svg': [1000],
    'partly_cloudy_day.svg': [1003],
    'cloudy.svg': [1006, 1009],
    'haze_fog_dust_smoke.svg': [1030, 1135],
    'drizzle.svg': [1063, 1072, 1150, 1153, 1168, 1171],
    'flurries.svg': [1066, 1216, 1219],
    'sleet_hail.svg': [1069, 1198, 1201, 1204, 1207, 1249, 1252],
    'isolated_scattered_thunderstorms_day.svg': [1087, 1273],
    'blowing_snow.svg': [1114],
    'blizzard.svg': [1117],
    'icy.svg': [1147, 1237, 1261, 1264],
    'showers_rain.svg': [1180, 1183, 1186, 1189, 1243, 1246],
    'heavy_rain.svg': [1192, 1195],
    'scattered_snow_showers_day.svg': [1210, 1213, 1255],
    'heavy_snow.svg': [1222, 1225],
    'scattered_showers_day.svg': [1240],
    'showers_snow.svg': [1258],
    'strong_thunderstorms.svg': [1276, 1282],
    'isolated_thunderstorms.svg': [1279],
  };

  static Map<String, List<int>> weatherIconsNightVersion = {
    'clear_night.svg': [1000],
    'partly_cloudy_night.svg': [1003],
    'mostly_cloudy_night.svg': [
      1006
    ], // Puedes añadir los códigos si los necesitas
    'mostly_clear_night.svg': [], // Igual que arriba
    'scattered_showers_night.svg': [1240],
    'scattered_snow_showers_night.svg': [1210, 1213, 1255],
    'isolated_scattered_thunderstorms_night.svg': [1087, 1273],
  };

  // static Map<String, List<int>> weatherCodeGroups = {
  //   'clear': [1000],
  //   'partly_cloudy': [1003],
  //   'cloudy': [1006, 1009],
  //   'foggy': [1030, 1135, 1147],
  //   'rainy': [1063, 1180, 1183, 1189, 1240, 1243, 1246],
  //   'snowy': [1066, 1210, 1213, 1216, 1219, 1222, 1225, 1255, 1258],
  //   'hail': [1237, 1261, 1264],
  //   'thunderstorm': [1087, 1273, 1276, 1279, 1282],
  // };

  // static Map<String, String> weatherIconData = {
  //   'clear': 'sunny.svg',
  //   'partly_cloudy': 'partly_cloudy_day.svg',
  //   'cloudy': 'cloud.svg',
  //   'foggy': 'foggy.svg',
  //   'rainy': 'rainy.svg',
  //   'snowy': 'cloudy_snowing',
  //   'hail': 'weather_hail.svg',
  //   'thunderstorm': 'thunderstorm.svg',
  // };

  // static String getIcon(int code) {
  //   for (final entry in weatherCodeGroups.entries) {
  //     if (entry.value.contains(code)) {
  //       String iconKey = entry.key;
  //       return headPath +
  //           (weatherIconData[iconKey] ?? weatherIconData['clear']!);
  //     }
  //   }
  //   return headPath + weatherIconData['clear']!;
  // }

  static String getIcon(int code, {bool? isDay = true}) {
    if (isDay == null) return '${headPath}clear_day.svg';

    final map = isDay ? weatherIconCodes : weatherIconsNightVersion;

    for (final entry in map.entries) {
      if (entry.value.contains(code)) {
        return headPath + entry.key;
      }
    }

    if (!isDay) {
      for (final entry in weatherIconCodes.entries) {
        if (entry.value.contains(code)) {
          return headPath + entry.key;
        }
      }
    }

    return headPath + (isDay ? 'clear_night.svg' : 'clear_day.svg');
  }
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
