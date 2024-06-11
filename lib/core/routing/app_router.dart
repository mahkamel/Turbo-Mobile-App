import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/presentation/auth/login_screen/login_screen.dart';
import 'package:turbo/presentation/auth/signup_screen/signup_screen.dart';

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
    Routes.loginScreen: (context, _) => BlocProvider<LoginCubit>(
          create: (context) => getIt<LoginCubit>(),
          child: const LoginScreen(),
        ),
    Routes.signupScreen: (context, _) => BlocProvider<SignupCubit>(
          create: (context) => getIt<SignupCubit>(),
          child: const SignupScreen(),
        ),
    Routes.layoutScreen: (context, _) => BlocProvider<LayoutCubit>(
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
