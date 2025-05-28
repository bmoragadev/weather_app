import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:miniweather/config/globals/globals.dart';
import 'package:miniweather/config/router/app_router.dart';
import 'package:miniweather/config/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/generated/l10n.dart';
import 'package:miniweather/presentation/providers/app_state_provider.dart';
import 'package:miniweather/presentation/providers/permissions/permissions_provider.dart';
import 'package:miniweather/presentation/providers/weather_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await App.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterNativeSplash.remove();
  runApp(const ProviderScope(
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
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    ref.read(appStateProvider.notifier).update((state) => state);
    if (state == AppLifecycleState.resumed) {
      await ref.read(permissionsProvider.notifier).checkPermissions();
      final locationProvider = ref.read(permissionsProvider);
      if (locationProvider.locationGranted) {
        ref.read(weatherProvider.notifier).refreshWeather();
      } else {
        ref.read(weatherProvider.notifier).setLoading(true);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: AppTheme().getLightTheme(),
      darkTheme: AppTheme().getDarkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
