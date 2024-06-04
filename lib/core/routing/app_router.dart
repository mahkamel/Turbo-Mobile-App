import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/routing/routes.dart';

import '../../blocs/layout/layout_cubit.dart';
import '../../presentation/layout/layout_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  static final Map<String, Widget Function(BuildContext, dynamic)> _routes = {
    // Routes.onBoardingScreen: (context, _) => BlocProvider(
    //       create: (context) => getIt<OnboardingCubit>(),
    //       child: const OnBoardingScreen(),
    //     ),
    Routes.onBoardingScreen: (context, _) => const OnboardingScreen(),
    Routes.layoutScreen: (context, _) => BlocProvider(
      create: (context) => getIt<LayoutCubit>(),
      child: const LayoutScreen(),
    ),
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
