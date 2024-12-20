import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/blocs/payment/payment_cubit.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/routing/screens_arguments.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/presentation/auth/forget_password/screens/forget_password_screen.dart';
import 'package:turbo/presentation/auth/forget_password/screens/otp_forget_password.dart';
import 'package:turbo/presentation/auth/forget_password/screens/create_new_password_screen.dart';
import 'package:turbo/presentation/auth/login_screen/login_screen.dart';
import 'package:turbo/presentation/auth/requests/widgets/upload_files_screen.dart';
import 'package:turbo/presentation/layout/car_details/car_details_screen.dart';
import 'package:turbo/presentation/layout/profile/screens/delete_account_screen.dart';
import 'package:turbo/presentation/layout/profile/screens/edit_account_screen.dart';

import '../../blocs/layout/layout_cubit.dart';
import '../../blocs/orders/order_cubit.dart';
import '../../presentation/auth/requests/payment/payment_screen.dart';
import '../../presentation/auth/requests/widgets/signup_otp_screen.dart';
import '../../presentation/auth/requests/signup_screen.dart';
import '../../presentation/layout/layout_screen.dart';
import '../../presentation/layout/orders/request_status/request_status_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  static final Map<String, Widget Function(BuildContext, dynamic)> _routes = {
    Routes.onBoardingScreen: (context, _) => const OnboardingScreen(),
    Routes.loginScreen: (context, arguments) => BlocProvider<LoginCubit>(
          create: (context) => getIt<LoginCubit>(),
          child: arguments != null
              ? LoginScreen(
                  requestedCarId: (arguments as LoginScreenArguments).carId,
                  dailyPrice: arguments.dailyPrice,
                  weeklyPrice: arguments.weeklyPrice,
                  monthlyPrice: arguments.monthlyPrice,
                  carColor: arguments.carColor,
                )
              : const LoginScreen(),
        ),
    Routes.forgetPasswordScreen: (context, arguments) {
      return BlocProvider.value(
        value: (arguments as LoginCubit),
        child: const ForgetPasswordScreen(),
      );
    },
    Routes.otpForgetPasswordScreen: (context, arguments) {
      return BlocProvider.value(
        value: (arguments as LoginCubit),
        child: const OtpForgetPassword(),
      );
    },
    Routes.createNewPasswordScreen: (context, arguments) {
      return BlocProvider.value(
        value: (arguments as LoginCubit),
        child: const CreateNewPassword(),
      );
    },
    Routes.editAccountScreen: (context, arguments) {
      return BlocProvider.value(
        value: (arguments as ProfileCubit),
        child: const EditAccountScreen(),
      );
    },
    Routes.deleteAccountScreen: (context, arguments) {
      return BlocProvider.value(
        value: (arguments as ProfileCubit),
        child: const DeleteAccountScreen(),
      );
    },
    Routes.signupScreen: (context, arguments) => arguments != null
        ? BlocProvider<SignupCubit>(
            create: (context) => getIt<SignupCubit>()
              ..onInit(arguments as SignupScreenArguments),
            child: const SignupScreen(),
          )
        : BlocProvider<SignupCubit>(
            create: (context) => getIt<SignupCubit>(),
            child: const SignupScreen(),
          ),
    Routes.signupOTPScreen: (context, arguments) =>
        BlocProvider<SignupCubit>.value(
          value: arguments as SignupCubit,
          child: const SignupOtpScreen(),
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
          create: (context) => getIt<PaymentCubit>()..init(),
          child: PaymentScreen(
            paymentAmount: (arguments as PaymentScreenArguments).paymentAmount,
            carRequestId: arguments.carRequestId,
            carRequestCode: arguments.carRequestCode,
            orderCubit: arguments.orderCubit,
          ),
        ),
    Routes.requestStatusScreen: (context, arguments) =>
        RepositoryProvider<AuthRepository>.value(
          value: getIt<AuthRepository>(),
          child: BlocProvider<OrderCubit>(
            create: (context) => getIt<OrderCubit>()
              ..getRequestStatus(
                (arguments).requestId,
              ),
            child: RequestStatusScreen(
              requestId: (arguments as RequestStatusScreenArguments).requestId,
              requestCode: arguments.requestCode,
              orderCubit: arguments.orderCubit,
              // orderCubit: arguments.orderCubit,
            ),
          ),
        ),
    Routes.uploadFilesScreen: (context, arguments) => BlocProvider.value(
          value: (arguments as SignupCubit),
          child: const UploadFilesStep(),
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
