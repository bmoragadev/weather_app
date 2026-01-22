import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:miniweather/config/constants/error_codes.dart';
import 'package:miniweather/config/globals/globals.dart';
import 'package:miniweather/config/router/app_router.dart';
import 'package:miniweather/config/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/l10n/app_localizations.dart';
import 'package:miniweather/presentation/providers/app_state/app_state_provider.dart';
import 'package:miniweather/presentation/providers/local_storage/local_storage_provider.dart';
import 'package:miniweather/presentation/providers/permissions/permissions_provider.dart';
import 'package:miniweather/presentation/providers/weather/weather_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Para las screenshots!
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  // await App.init();
  final prefs = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterNativeSplash.remove();
  runApp(ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    // ignore: prefer_const_constructors
    child: MainApp(),
  ));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(permissionsProvider.notifier).checkPermissions();
    final locationProvider = ref.read(permissionsProvider);
    if (!locationProvider.locationGranted) {
      ref.read(permissionsProvider.notifier).requestLocationAccess();
      return;
    }
    ref.read(weatherProvider.notifier).forceRefreshWeather();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(appStateProvider.notifier).update((state) => state);
    if (state == AppLifecycleState.resumed) {
      _handleResume();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _handleResume() async {
    await ref.read(permissionsProvider.notifier).checkPermissions();
    final locationProvider = ref.read(permissionsProvider);

    if (locationProvider.locationGranted) {
      await ref.read(weatherProvider.notifier).refreshWeather();
    } else {
      ref.read(weatherProvider.notifier).setError(ErrorCode.locationOff);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme().getLightTheme(),
      darkTheme: AppTheme().getDarkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
