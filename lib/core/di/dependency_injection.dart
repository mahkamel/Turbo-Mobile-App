import 'package:get_it/get_it.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/services/networking/api_services/auth_service.dart';
import 'package:turbo/core/services/networking/api_services/car_services.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';

import '../../blocs/layout/layout_cubit.dart';
import '../services/networking/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  //Services
  getIt.registerLazySingleton<AuthServices>(
    () => AuthServices(),
  );
  getIt.registerLazySingleton<CarServices>(
    () => CarServices(),
  );

  //Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthServices>()),
  );

  getIt.registerLazySingleton<CarRepository>(
    () => CarRepository(getIt<CarServices>()),
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
    ),
  );
  getIt.registerFactory<CarDetailsCubit>(
    () => CarDetailsCubit(getIt<CarRepository>()),
  );
}
