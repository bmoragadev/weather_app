import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simpleweather/config/constants/weather_code_icons.dart';
import 'package:simpleweather/config/helpers/conversor.dart';
import 'package:simpleweather/domain/entities/weather.dart';
import 'package:simpleweather/generated/l10n.dart';
import 'package:simpleweather/presentation/providers/weather_provider.dart';
import 'package:simpleweather/presentation/widgets/custom_radial_gradient.dart';
import 'package:simpleweather/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(weatherProvider.notifier).getTempUnit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    TempUnit tempUnit = ref.read(weatherProvider.notifier).getTempUnit();

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
                    Text(S.current.drawer_config,
                        style: textStyles.headlineMedium),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.drawer_temperature_unit,
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
                      onChanged: (TempUnit? value) {
                        ref.read(weatherProvider.notifier).setTempUnit(value!);
                        setState(() {});
                      }),
                  RadioListTile(
                      title: Text(
                        'Fahrenheit',
                        style: textStyles.labelLarge,
                      ),
                      value: TempUnit.fahrenheit,
                      groupValue: tempUnit,
                      onChanged: (TempUnit? value) {
                        ref.read(weatherProvider.notifier).setTempUnit(value!);
                        setState(() {});
                      }),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(S.current.drawer_about_app),
              onTap: () {
                Navigator.of(context).pop();
                showAboutDialog(
                    context: context,
                    applicationIcon: ClipOval(
                      child: Image.asset(
                        'assets/imgs/icon.png',
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    applicationName: S.current.app_name,
                    applicationVersion: '1.0.0',
                    children: [
                      Text(S.current.about_text),
                      const SizedBox(height: 10),
                      Text(S.current.created_by, style: textStyles.labelLarge),
                      Text(S.current.made_in, style: textStyles.labelLarge),
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

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

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
            _WeatherOnDayByTime(
              colors: colors,
            ),
            _WeatherWeek(
              colors: colors,
              textStyle: textStyles,
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.2],
            colors: [
              colors.brightness == Brightness.light
                  ? Colors.white
                  : colors.primaryContainer,
              colors.secondaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              color: colors.brightness == Brightness.light
                  ? colors.secondary
                  : Colors.transparent,
              blurRadius: 0.5,
            )
          ],
          color: colors.primaryContainer,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (context, index) {
            String currentDay = currentWeatherState.weatherDaily == null
                ? ''
                : DateFormat.E()
                    .add_d()
                    .format(currentWeatherState.weatherDaily!.days[index]);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  (currentWeatherState.weatherDaily == null ||
                          currentWeatherState.isLoading)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 40, height: 14))
                      : Expanded(
                          child: Text(
                            currentDay,
                            style: textStyle.labelLarge,
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherDaily == null ||
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
                                .weatherDaily!.weatherCode[index]
                                .toInt()),
                            // 'assets/icons/partly_cloudy_day.svg',
                            height: 32,
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherDaily == null ||
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
                            child: Text(
                              currentWeatherState.tempUnit ==
                                      TempUnit.fahrenheit
                                  ? '${Conversor.celsiusToFahrenheit(currentWeatherState.weatherDaily!.minTemperature[index]).toInt()}°F'
                                  : '${currentWeatherState.weatherDaily!.minTemperature[index].toInt()}°C',
                              //'${currentWeatherState.weatherDaily!.minTemperature[index].toInt()}${currentWeatherState.tempUnit == TempUnit.fahrenheit ? '°F' : '°C'}',
                              style: textStyle.labelLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherDaily == null ||
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
                            child: Text(
                              currentWeatherState.tempUnit ==
                                      TempUnit.fahrenheit
                                  ? '${Conversor.celsiusToFahrenheit(currentWeatherState.weatherDaily!.maxTemperature[index]).toInt()}°F'
                                  : '${currentWeatherState.weatherDaily!.maxTemperature[index].toInt()}°C',
                              style: textStyle.labelLarge,
                              textAlign: TextAlign.center,
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24,
            itemBuilder: (context, index) {
              return _WeatherDaySlide(
                minIndex: currentMinIndex,
                weather: currentWeatherState.weather,
                isLoading: currentWeatherState.isLoading,
                tempUnit: currentWeatherState.tempUnit,
                colors: colors,
                index: index,
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
      required this.weather,
      required this.isLoading,
      required this.tempUnit});

  final ColorScheme colors;
  final int index;
  final int minIndex;
  final Weather? weather;
  final TempUnit? tempUnit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // DateTime? currentTime =
    //     DateTime.tryParse(weather!.time[minIndex + index] as String);

    String timeFormatted = weather == null
        ? ''
        : DateFormat.Hm().format(weather!.time[minIndex + index - 1]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.7],
            colors: [
              colors.brightness == Brightness.light
                  ? Colors.white
                  : colors.primaryContainer,
              colors.secondaryContainer
            ],
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              color: colors.brightness == Brightness.light
                  ? colors.secondary
                  : Colors.transparent,
              blurRadius: 0.5,
            )
          ],
          color: colors.primaryContainer,
        ),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            (weather == null || isLoading)
                ? _ShimmerLoading(colors: colors, width: 40, height: 14)
                : Text(weather == null ? '...' : timeFormatted),
            const Spacer(),
            (weather == null || isLoading)
                ? _ShimmerLoading(colors: colors, width: 32, height: 32)
                // : const Icon(
                //     Icons.cloudy_snowing,
                //     color: Colors.blueGrey,
                //     size: 32,
                //   ),
                : SvgPicture.asset(
                    // 'assets/icons/partly_cloudy_day.svg',
                    WeatherCodeIcons.getIcon(
                        weather!.weatherCode[minIndex + index - 1]),
                    height: 32,
                  ),
            const Spacer(),
            (weather == null || isLoading)
                ? _ShimmerLoading(colors: colors, width: 40, height: 14)
                : Text(
                    tempUnit == TempUnit.fahrenheit
                        ? '${Conversor.celsiusToFahrenheit(weather!.temperature[minIndex + index - 1]).toInt()}°F'
                        : '${weather!.temperature[minIndex + index - 1].toInt()}°C',
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
                    ? const Color.fromARGB(0, 255, 255, 255)
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
                              await ref
                                  .read(weatherProvider.notifier)
                                  .refreshWeather();
                            },
                            label: currentWeatherState.isLoading
                                ? LoadingAnimationWidget.waveDots(
                                    color: colors.primary, size: 32)
                                : Text(
                                    currentWeatherState
                                        .currentLocation!.cityName,
                                    style: const TextStyle(
                                      fontSize: 22,
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
                    currentWeatherState.isLoading
                        ? LoadingAnimationWidget.hexagonDots(
                            color: colors.primary, size: 64)
                        : Column(
                            children: [
                              // const Icon(
                              //   Icons.sunny,
                              //   color: Colors.orange,
                              //   size: 128,
                              // ),
                              SvgPicture.asset(
                                WeatherCodeIcons.getIcon(currentWeatherCode),
                                // 'assets/icons/partly_cloudy_day.svg',
                                height: 128,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      currentWeatherState.tempUnit ==
                                              TempUnit.fahrenheit
                                          ? '${Conversor.celsiusToFahrenheit(currentTemperature.toDouble()).toInt()}'
                                          : '${currentTemperature}',

                                      //'$currentTemperature',
                                      style: textStyles.displayLarge),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      currentWeatherState.tempUnit ==
                                              TempUnit.fahrenheit
                                          ? '°F'
                                          : '°C',
                                      style: textStyles.headlineSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
