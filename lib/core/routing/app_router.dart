import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/blocs/payment/payment_cubit.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/routing/screens_arguments.dart';
import 'package:turbo/presentation/auth/login_screen/login_screen.dart';
import 'package:turbo/presentation/layout/car_details/car_details_screen.dart';

import '../../blocs/layout/layout_cubit.dart';
import '../../presentation/auth/requests/payment/payment_screen.dart';
import '../../presentation/auth/requests/signup_screen.dart';
import '../../presentation/layout/layout_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  static final Map<String, Widget Function(BuildContext, dynamic)> _routes = {
    Routes.onBoardingScreen: (context, _) => const OnboardingScreen(),
    Routes.loginScreen: (context, arguments) => BlocProvider<LoginCubit>(
          create: (context) => getIt<LoginCubit>(),
          child: LoginScreen(
            requestedCarId: (arguments as LoginScreenArguments).carId,
            dailyPrice: arguments.dailyPrice,
            weeklyPrice: arguments.weeklyPrice,
            monthlyPrice: arguments.monthlyPrice,
          ),
        ),
    Routes.signupScreen: (context, arguments) => BlocProvider<SignupCubit>(
          create: (context) => getIt<SignupCubit>()..onInit(arguments),
          child: SignupScreen(
            isFromLogin: (arguments as SignupScreenArguments).isFromLogin,
          ),
        ),
    Routes.layoutScreen: (context, _) => BlocProvider<LayoutCubit>(
          create: (context) => getIt<LayoutCubit>(),
          child: const LayoutScreen(),
        ),
    Routes.carDetailsScreen: (context, arguments) =>
        BlocProvider<CarDetailsCubit>(
          create: (context) => getIt<CarDetailsCubit>()
            ..getCarDetails(
              (arguments).car.carId,
            ),
          child: CardDetailsScreen(
            car: (arguments as CardDetailsScreenArguments).car,
          ),
        ),
    Routes.paymentScreen: (context, arguments) => BlocProvider<PaymentCubit>(
          create: (context) => getIt<PaymentCubit>(),
          child: PaymentScreen(
            value: (arguments as PaymentScreenArguments).value,
            carRequestId: arguments.carRequestId,
          ),
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
