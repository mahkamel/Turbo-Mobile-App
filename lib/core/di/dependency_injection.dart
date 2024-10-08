import 'package:get_it/get_it.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/blocs/payment/payment_cubit.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/blocs/search/search_cubit.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/services/networking/api_services/auth_service.dart';
import 'package:turbo/core/services/networking/api_services/car_service.dart';
import 'package:turbo/core/services/networking/api_services/cities_districts_services.dart';
import 'package:turbo/core/services/networking/api_services/pricing_policy_service.dart';
import 'package:turbo/core/services/networking/api_services/requests_services.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';
import 'package:turbo/core/services/networking/repositories/payment_repository.dart';

import '../../blocs/layout/layout_cubit.dart';
import '../../blocs/orders/order_cubit.dart';
import '../services/networking/api_services/payment_service.dart';
import '../services/networking/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  //Services
  getIt.registerLazySingleton<AuthServices>(() => AuthServices());
  getIt.registerLazySingleton<CarServices>(() => CarServices());
  getIt.registerLazySingleton<PaymentService>(() => PaymentService());
  getIt.registerLazySingleton<CitiesDistrictsServices>(
      () => CitiesDistrictsServices());
  getIt.registerLazySingleton<PricingPolicyService>(
      () => PricingPolicyService());
  getIt.registerLazySingleton<RequestsService>(() => RequestsService());

  //Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      getIt<AuthServices>(),
    ),
  );

  getIt.registerLazySingleton<CarRepository>(
    () => CarRepository(
      getIt<CarServices>(),
      getIt<PricingPolicyService>(),
      getIt<RequestsService>(),
    ),
  );

  getIt.registerLazySingleton<CitiesDistrictsRepository>(
    () => CitiesDistrictsRepository(
      getIt<CitiesDistrictsServices>(),
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepository(getIt<PaymentService>()),
  );

  //Blocs
  getIt.registerFactory<LayoutCubit>(() => LayoutCubit());
  getIt.registerFactory<LoginCubit>(() => LoginCubit(
        getIt<AuthRepository>(),
        getIt<PaymentRepository>(),
      ));
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(
      authRepository: getIt<AuthRepository>(),
      citiesDistrictsRepository: getIt<CitiesDistrictsRepository>(),
      carRepository: getIt<CarRepository>(),
    ),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getIt<AuthRepository>(),
      getIt<CarRepository>(),
      getIt<CitiesDistrictsRepository>(),
    ),
  );
  getIt.registerFactory<CarDetailsCubit>(
    () => CarDetailsCubit(
      getIt<CarRepository>(),
      getIt<AuthRepository>(),
    ),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(
      getIt<CarRepository>(),
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<PaymentCubit>(
    () => PaymentCubit(
      getIt<PaymentRepository>(),
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getIt<PaymentRepository>(),
      getIt<AuthRepository>(),
      getIt<CarRepository>(),
    ),
  );
  getIt.registerFactory<OrderCubit>(
    () => OrderCubit(
      getIt<CarRepository>(),
      getIt<AuthRepository>(),
    ),
  );
}
