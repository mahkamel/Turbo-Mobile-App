import 'package:get_it/get_it.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/blocs/search/search_cubit.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/services/networking/api_services/auth_service.dart';
import 'package:turbo/core/services/networking/api_services/car_services.dart';
import 'package:turbo/core/services/networking/api_services/cities_districts_services.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';

import '../../blocs/layout/layout_cubit.dart';
import '../services/networking/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  //Services
  getIt.registerLazySingleton<AuthServices>(() => AuthServices());
  getIt.registerLazySingleton<CarServices>(() => CarServices());
  getIt.registerLazySingleton<CitiesDistrictsServices>(
      () => CitiesDistrictsServices());

  //Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthServices>(),

    ),
  );

  getIt.registerLazySingleton<CarRepository>(
    () => CarRepository(getIt<CarServices>()),
  );

  getIt.registerLazySingleton<CitiesDistrictsRepository>(
    () => CitiesDistrictsRepository(getIt<CitiesDistrictsServices>()),
  );

  //Blocs
  getIt.registerFactory<LayoutCubit>(() => LayoutCubit());
  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<AuthRepository>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getIt<AuthRepository>(),
      getIt<CarRepository>(),
      getIt<CitiesDistrictsRepository>(),
    ),
  );
  getIt.registerFactory<CarDetailsCubit>(
    () => CarDetailsCubit(getIt<CarRepository>()),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(getIt<CarRepository>()),
  );
}
