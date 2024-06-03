import 'package:flutter/material.dart';
import 'package:turbo/core/routing/routes.dart';

class AppRouter {
  static final Map<String, Widget Function(BuildContext, dynamic)> _routes = {
    // Routes.onBoardingScreen: (context, _) => BlocProvider(
    //       create: (context) => getIt<OnboardingCubit>(),
    //       child: const OnBoardingScreen(),
    //     ),
    Routes.onBoardingScreen: (context, _) => const Placeholder(),
  };

  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    final routeBuilder = _routes[settings.name];

    if (routeBuilder != null) {
      return MaterialPageRoute(
        builder: (context) {
          return routeBuilder(context, arguments);
        },
      );
    } else {
      return null;
    }
  }
}
