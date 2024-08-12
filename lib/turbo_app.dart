import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/localization/cubit/localization_cubit.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';
import 'package:turbo/core/services/networking/repositories/payment_repository.dart';
import 'package:turbo/models/customer_model.dart';

import 'blocs/localization/localization/app_localization_setup.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/constants.dart' show navigatorKey;
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/services/networking/repositories/auth_repository.dart';
import 'core/services/networking/repositories/car_repository.dart';
import 'core/theming/colors.dart';
import 'flavors.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.appRouter,
    required this.isFirstTime,
    this.customer,
  });

  final AppRouter appRouter;
  final bool isFirstTime;
  final CustomerModel? customer;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(
          value: getIt<AuthRepository>()..setCustomerData(customer),
        ),
        RepositoryProvider<PaymentRepository>.value(
          value: getIt<PaymentRepository>()..init(),
        ),
        RepositoryProvider<CarRepository>.value(
          value: getIt<CarRepository>()
            ..getCarTypes()
            ..getVat()
            ..getDriverFees(),
        ),
        RepositoryProvider.value(
          value: getIt<CitiesDistrictsRepository>()..getCities(),
        ),
      ],
      child: BlocProvider<LocalizationCubit>(
        create: (context) => LocalizationCubit()..onInit(),
        child: BlocBuilder<LocalizationCubit, LocalizationState>(
          buildWhen: (previous, current) {
            return current is SelectedLocalization ||
                previous is SelectedLocalization;
          },
          builder: (context, state) {
            if (state.locale.languageCode.contains("ar")) {
              AppLocalizationsSetup.isLoadAr = true;
            }
            Locale appLocale = const Locale('en', 'US');
            if (state is SelectedLocalization) {
              appLocale = state.locale;
            }

            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: MaterialApp(
                navigatorKey: navigatorKey,
                title: 'Turbo',
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,
                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                locale: appLocale,
                theme: ThemeData(
                  fontFamily: "Inter",
                  scaffoldBackgroundColor: AppColors.white,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.primaryRed,
                  ),
                  useMaterial3: true,
                ),
                debugShowCheckedModeBanner:
                    F.appFlavor != null && F.appFlavor == Flavor.dev
                        ? true
                        : false,
                initialRoute:
                    isFirstTime ? Routes.initLangScreen : Routes.layoutScreen,
                onGenerateRoute: appRouter.generateRoute,
              ),
            );
          },
        ),
      ),
    );
  }
}
