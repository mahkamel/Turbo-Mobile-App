import 'package:flutter/material.dart';

import 'blocs/localization/localization/app_localization_setup.dart';
import 'core/helpers/constants.dart' show navigatorKey;
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theming/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.appRouter,
    required this.isFirstTime,
  });
  final AppRouter appRouter;
  final bool isFirstTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Turbo',
      supportedLocales: AppLocalizationsSetup.supportedLocales,
      localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
      localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryRed,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isFirstTime ? Routes.onBoardingScreen : Routes.layoutScreen,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
