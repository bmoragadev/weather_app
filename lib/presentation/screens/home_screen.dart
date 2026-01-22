import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miniweather/config/constants/error_codes.dart';
import 'package:miniweather/config/constants/temp_unit.dart';
import 'package:miniweather/config/helpers/formatter.dart';
import 'package:miniweather/domain/entities/hourly_weather.dart';
import 'package:miniweather/presentation/providers/permissions/permissions_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:miniweather/config/constants/weather_code_icons.dart';
import 'package:miniweather/config/helpers/conversor.dart';
import 'package:miniweather/l10n/app_localizations.dart';
import 'package:miniweather/presentation/providers/weather/weather_provider.dart';
import 'package:miniweather/presentation/widgets/custom_radial_gradient.dart';
import 'package:miniweather/presentation/widgets/widgets.dart';

import '../../config/helpers/strings.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    final tempUnit = ref.watch(weatherProvider).tempUnit;

    return Scaffold(
      body: const _HomeView(),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.1, 1.0],
                  colors: [
                    colors.primaryContainer,
                    colors.brightness == Brightness.light
                        ? const Color.fromARGB(0, 255, 255, 255)
                        : Colors.transparent
                  ],
                )),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(AppLocalizations.of(context)!.drawer_config,
                        style: textStyles.headlineMedium),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.drawer_temperature_unit,
                    textAlign: TextAlign.start,
                    style: textStyles.bodyLarge,
                  ),
                  RadioListTile(
                      title: Text(
                        'Celsius',
                        style: textStyles.labelLarge,
                      ),
                      value: TempUnit.celsius,
                      groupValue: tempUnit,
                      onChanged: (value) async {
                        await ref
                            .read(weatherProvider.notifier)
                            .setTempUnit(value as TempUnit);
                      }),
                  RadioListTile(
                      title: Text(
                        'Fahrenheit',
                        style: textStyles.labelLarge,
                      ),
                      value: TempUnit.fahrenheit,
                      groupValue: tempUnit,
                      onChanged: (value) async {
                        await ref
                            .read(weatherProvider.notifier)
                            .setTempUnit(value as TempUnit);
                      }),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading:
                  Icon(Icons.wb_sunny_outlined, color: colors.onSurfaceVariant),
              title: Text(AppLocalizations.of(context)!.drawer_about_app,
                  style: textStyles.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(context).pop();
                showAboutDialog(
                    context: context,
                    applicationIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primaryContainer),
                      child: Image.asset(
                        'assets/imgs/icon.png',
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    applicationName: AppLocalizations.of(context)!.app_name,
                    applicationVersion: '1.3.6',
                    children: [
                      Text(AppLocalizations.of(context)!.about_text,
                          style: textStyles.bodyMedium),
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context)!.created_by,
                          style: textStyles.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      Text(AppLocalizations.of(context)!.made_in,
                          style: textStyles.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ]);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class _HomeView extends ConsumerWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    final currentWeatherState = ref.watch(weatherProvider);

    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CurrentWeather(
              colors: colors,
              textStyles: textStyles,
            ),
            if (currentWeatherState.error == ErrorCode.none)
              _WeatherDetailInfo(colors: colors, textStyles: textStyles)
          ],
        ),
      ),
    );
  }
}

class _WeatherDetailInfo extends StatelessWidget {
  const _WeatherDetailInfo({required this.colors, required this.textStyles});
  final ColorScheme colors;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LastFetchText(colors: colors, textStyles: textStyles),
        _WeatherOnDayByTime(
          colors: colors,
        ),
        //_ExtraMetricsGrid(colors: colors, textStyles: textStyles),
        _WeatherWeek(
          colors: colors,
          textStyle: textStyles,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(AppLocalizations.of(context)!.data_from),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class _ExtraMetricsGrid extends ConsumerWidget {
  const _ExtraMetricsGrid({required this.colors, required this.textStyles});
  final ColorScheme colors;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherState = ref.watch(weatherProvider);
    final weather = currentWeatherState.weatherData?.current;

    if (weather == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                _MetricItem(
                  label: AppLocalizations.of(context)!.feels_like,
                  value: currentWeatherState.tempUnit == TempUnit.celsius
                      ? '${weather.feelsLike.toInt()}°'
                      : '${Conversor.celsiusToFahrenheit(weather.feelsLike).toInt()}°',
                  icon: Icons.thermostat,
                  colors: colors,
                  textStyles: textStyles,
                ),
                _MetricItem(
                  label: AppLocalizations.of(context)!.humidity,
                  value: '${weather.humidity}%',
                  icon: Icons.water_drop,
                  colors: colors,
                  textStyles: textStyles,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetricItem(
                  label: AppLocalizations.of(context)!.wind,
                  value: '${weather.windKph.toInt()} km/h',
                  icon: Icons.air,
                  colors: colors,
                  textStyles: textStyles,
                ),
                _MetricItem(
                  label: AppLocalizations.of(context)!.uv_index,
                  value: '${weather.uv.toInt()}',
                  icon: Icons.sunny,
                  colors: colors,
                  textStyles: textStyles,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.colors,
    required this.textStyles,
  });

  final String label;
  final String value;
  final IconData icon;
  final ColorScheme colors;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colors.onPrimaryContainer, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textStyles.labelMedium?.copyWith(
                  color: colors.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w600, // Bolder Label
                ),
              ),
              Text(
                value,
                style: textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800, // Much Bolder Value
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LastFetchText extends ConsumerWidget {
  const _LastFetchText({required this.colors, required this.textStyles});
  final ColorScheme colors;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherState = ref.watch(weatherProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();

    if (currentWeatherState.isLoading) {
      return const SizedBox();
    }

    return FadeInDown(
      from: 50,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.last_update_text,
            style: textStyles.bodySmall,
          ),
          Text(
            Formatter.formatBasedOnLocale(
                context, currentWeatherState.weatherData!.fetchTime),
            style: textStyles.bodySmall,
          )
        ],
      ),
    );
  }
}

class _WeatherWeek extends ConsumerWidget {
  const _WeatherWeek({
    required this.colors,
    required this.textStyle,
  });

  final ColorScheme colors;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherState = ref.watch(weatherProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            String currentDay = currentWeatherState.weatherData == null
                ? ''
                : DateFormat.E()
                    .add_d()
                    .format(currentWeatherState.weatherData!.daily[index].date);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  (currentWeatherState.weatherData == null ||
                          currentWeatherState.isLoading)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 40, height: 14))
                      : Expanded(
                          child: Text(
                            Strings.capitalize(currentDay),
                            style: textStyle.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherData == null ||
                          currentWeatherState.isLoading)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 24, height: 24))
                      : Expanded(
                          // child: Icon(
                          //   Icons.sunny,
                          //   color: Colors.orange,
                          // ),
                          child: SvgPicture.asset(
                            WeatherCodeIcons.getIcon(currentWeatherState
                                .weatherData!.daily[index].conditionCode
                                .toInt()),
                            // 'assets/icons/partly_cloudy_day.svg',
                            height: 32,
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherData == null ||
                          currentWeatherState.isLoading)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 20, height: 32))
                      : Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              gradient: LinearGradient(colors: [
                                Colors.lightBlue.withOpacity(0.5),
                                colors.primaryContainer.withOpacity(0.1),
                              ]),
                            ),
                            child: FadeInRight(
                              from: 50,
                              child: Text(
                                currentWeatherState.tempUnit ==
                                        TempUnit.fahrenheit
                                    ? '${Conversor.celsiusToFahrenheit(currentWeatherState.weatherData!.daily[index].minTemp).toInt()}°F'
                                    : '${currentWeatherState.weatherData!.daily[index].minTemp.toInt()}°C',
                                //'${currentWeatherState.weatherDaily!.minTemperature[index].toInt()}${currentWeatherState.tempUnit == TempUnit.fahrenheit ? '°F' : '°C'}',
                                style: textStyle.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors.brightness == Brightness.light
                                        ? Colors.blueGrey.shade700
                                        : Colors.blueGrey.shade100),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherData == null ||
                          currentWeatherState.isLoading)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 20, height: 32))
                      : Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              gradient: LinearGradient(colors: [
                                colors.primaryContainer.withOpacity(0.1),
                                Colors.orange.withOpacity(0.75)
                              ]),
                            ),
                            child: FadeInLeft(
                              from: 50,
                              child: Text(
                                currentWeatherState.tempUnit ==
                                        TempUnit.fahrenheit
                                    ? '${Conversor.celsiusToFahrenheit(currentWeatherState.weatherData!.daily[index].maxTemp).toInt()}°F'
                                    : '${currentWeatherState.weatherData!.daily[index].maxTemp.toInt()}°C',
                                style: textStyle.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colors.brightness == Brightness.light
                                        ? Colors.orange.shade900
                                        : Colors.orange.shade100),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: colors.primary,
              indent: 15,
              endIndent: 15,
              thickness: 0.2,
            );
          },
        ),
      ),
    );
  }
}

class _WeatherOnDayByTime extends ConsumerWidget {
  const _WeatherOnDayByTime({
    required this.colors,
  });

  final ColorScheme colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherState = ref.watch(weatherProvider);

    final currentMinIndex =
        ref.watch(weatherProvider.notifier).getCurrentMinIndex();

    final List<HourlyWeather> combinedHourly = [
      ...currentWeatherState.weatherData?.daily[0].hourly ?? [],
      ...currentWeatherState.weatherData?.daily[1].hourly ?? []
    ];

    final maxHourlyItems = combinedHourly.length;

    final validCount = (maxHourlyItems - currentMinIndex + 1).clamp(0, 48);

    if (currentWeatherState.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height: 160,
            child: Center(
                child: LoadingAnimationWidget.progressiveDots(
                    color: colors.primary, size: 48))),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: validCount,
            itemBuilder: (context, index) {
              return FadeInUp(
                child: _WeatherDaySlide(
                  minIndex: currentMinIndex,
                  hourlyData: combinedHourly,
                  isLoading: currentWeatherState.isLoading,
                  tempUnit: currentWeatherState.tempUnit,
                  colors: colors,
                  index: index,
                ),
              );
            },
          )),
    );
  }
}

class _WeatherDaySlide extends StatelessWidget {
  const _WeatherDaySlide(
      {required this.colors,
      required this.index,
      required this.minIndex,
      required this.hourlyData,
      required this.isLoading,
      required this.tempUnit});

  final ColorScheme colors;
  final int index;
  final int minIndex;
  final List<HourlyWeather>? hourlyData;
  final TempUnit? tempUnit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // DateTime? currentTime =
    //     DateTime.tryParse(weather!.time[minIndex + index] as String);

    String timeFormatted = hourlyData == null
        ? ''
        : DateFormat.Hm().format(hourlyData![minIndex + index - 1].time);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      child: GlassContainer(
        width: 100,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            (hourlyData == null || isLoading)
                ? _ShimmerLoading(colors: colors, width: 40, height: 14)
                : Text(hourlyData == null ? '...' : timeFormatted),
            const Spacer(),
            (hourlyData == null || isLoading)
                ? _ShimmerLoading(colors: colors, width: 32, height: 32)
                // : const Icon(
                //     Icons.cloudy_snowing,
                //     color: Colors.blueGrey,
                //     size: 32,
                //   ),
                : SvgPicture.asset(
                    // 'assets/icons/partly_cloudy_day.svg',
                    WeatherCodeIcons.getIcon(
                        hourlyData![minIndex + index - 1].conditionCode,
                        isDay: hourlyData![minIndex + index - 1].isDay),
                    height: 32,
                  ),
            const Spacer(),
            (hourlyData == null || isLoading)
                ? _ShimmerLoading(colors: colors, width: 40, height: 14)
                : Text(
                    tempUnit == TempUnit.fahrenheit
                        ? '${Conversor.celsiusToFahrenheit(hourlyData![minIndex + index - 1].temperature).toInt()}°F'
                        : '${hourlyData![minIndex + index - 1].temperature.toInt()}°C',
                  ),

            //'${weather == null ? '...' : weather!.temperature[minIndex + index].toInt()}${tempUnit == TempUnit.fahrenheit ? '°F' : '°C'}'),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading({
    required this.colors,
    required this.width,
    required this.height,
  });

  final ColorScheme colors;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: colors.primary.withOpacity(0.25),
        highlightColor: colors.primary.withOpacity(0.125),
        direction: ShimmerDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey,
          ),
          width: width,
          height: height,
        ));
  }
}

class _CurrentWeather extends ConsumerWidget {
  final ColorScheme colors;
  final TextTheme textStyles;

  const _CurrentWeather({required this.colors, required this.textStyles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherState = ref.watch(weatherProvider);

    final currentTemperature =
        ref.watch(weatherProvider.notifier).getCurrentTemperature();

    final currentWeatherCode =
        ref.watch(weatherProvider.notifier).getCurrentWeatherCode();

    final currentLocationPermission =
        ref.watch(permissionsProvider).locationGranted;

    final currentIsDay = ref.watch(weatherProvider.notifier).getCurrentIsDay();

    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Stack(
          children: [
            CustomRadialGradient(
              stops: const [0.1, 1.0],
              colors: [
                colors.primaryContainer,
                colors.brightness == Brightness.light
                    ? (currentWeatherState.error == ErrorCode.none
                        ? const Color.fromARGB(0, 255, 255, 255)
                        : const Color.fromARGB(0, 255, 0, 0))
                    : Colors.transparent
              ],
            ),
            CustomLinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 1.0],
              colors: [
                colors.primaryContainer,
                colors.brightness == Brightness.light
                    ? const Color.fromARGB(0, 255, 255, 255)
                    : Colors.transparent
              ],
            ),
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (!currentLocationPermission) {
                                ref
                                    .read(permissionsProvider.notifier)
                                    .requestLocationAccess();
                                return;
                              }
                              await ref
                                  .read(weatherProvider.notifier)
                                  .forceRefreshWeather();
                            },
                            label: currentWeatherState.isLoading
                                ? LoadingAnimationWidget.waveDots(
                                    color: colors.primary, size: 32)
                                : Text(
                                    currentWeatherState
                                            .currentLocation?.cityName ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            icon: const Icon(Icons.location_on),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                child: const Icon(Icons.settings))),
                      ],
                    ),
                    const Spacer(),
                    if (currentWeatherState.isLoading)
                      LoadingAnimationWidget.hexagonDots(
                          color: colors.primary, size: 64)
                    else if (currentWeatherState.error == ErrorCode.none)
                      _CurrentWeatherWidget(
                        currentWeatherCode: currentWeatherCode,
                        currentIsDay: currentIsDay,
                        currentWeatherState: currentWeatherState,
                        currentTemperature: currentTemperature,
                        textStyles: textStyles,
                        colors: colors,
                      )
                    else
                      ErrorWidget(
                        colors: colors,
                        textStyles: textStyles,
                      ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ErrorWidget extends ConsumerWidget {
  const ErrorWidget({
    super.key,
    required this.colors,
    required this.textStyles,
  });

  final ColorScheme colors;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);

    return Column(
      children: [
        switch (weatherState.error) {
          ErrorCode.locationOff => Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.location_disabled,
                  size: 128,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.localization_off_error,
                  style: textStyles.bodyLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      ref.read(permissionsProvider.notifier).openSettings();
                    },
                    child: Text(
                        AppLocalizations.of(context)!.open_settings_button)),
              ],
            ),
          ErrorCode.none => throw UnimplementedError(),
          ErrorCode.noInternet => Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.signal_wifi_connected_no_internet_4,
                  size: 128,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.no_internet_error,
                  style: textStyles.bodyLarge,
                ),
              ],
            ),
          ErrorCode.noLocalData => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.error_outline,
                  size: 128,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.no_local_data_error,
                  style: textStyles.bodyLarge,
                ),
              ],
            ),
        }
      ],
    );
  }
}

class _CurrentWeatherWidget extends StatelessWidget {
  const _CurrentWeatherWidget({
    required this.currentWeatherCode,
    required this.currentIsDay,
    required this.currentWeatherState,
    required this.currentTemperature,
    required this.textStyles,
    required this.colors,
  });

  final int currentWeatherCode;
  final bool? currentIsDay;
  final WeatherState currentWeatherState;
  final int currentTemperature;
  final TextTheme textStyles;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Icon(
        //   Icons.sunny,
        //   color: Colors.orange,
        //   size: 128,
        // ),
        Tada(
          child: SvgPicture.asset(
            WeatherCodeIcons.getIcon(currentWeatherCode, isDay: currentIsDay),
            // 'assets/icons/partly_cloudy_day.svg',
            height: 128,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                currentWeatherState.tempUnit == TempUnit.fahrenheit
                    ? '${Conversor.celsiusToFahrenheit(currentTemperature.toDouble()).toInt()}'
                    : '$currentTemperature',

                //'$currentTemperature',
                style: textStyles.displayLarge),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                currentWeatherState.tempUnit == TempUnit.fahrenheit
                    ? '°F'
                    : '°C',
                style: textStyles.headlineSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
