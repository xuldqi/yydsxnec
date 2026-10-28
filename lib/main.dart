import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/router/app_router.dart';
import 'l10n/app_localizations.dart';

late final String initialRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure the shared preferences are initialized but don't decide the route yet
  await SharedPreferences.getInstance();
  initialRoute = '/start-logo';

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const ProviderScope(child: StepsApp()));
}

class StepsApp extends StatelessWidget {
  const StepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: MaterialApp.router(
        title: '微刻运动',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: const [Locale('zh'), Locale('en')],
        locale: const Locale('zh'),
        routerConfig: router,
      ),
    );
  }
}

