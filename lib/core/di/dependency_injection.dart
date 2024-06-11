import 'package:get_it/get_it.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/services/networking/api_services/auth_service.dart';

import '../../blocs/layout/layout_cubit.dart';
import '../services/networking/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  //Services
  getIt.registerLazySingleton<AuthServices>(
    () => AuthServices(),
  );

  //Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      getIt<AuthServices>(),
    ),
  );

  //Blocs
  getIt.registerFactory<LayoutCubit>(
    () => LayoutCubit(),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(),
  );
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<AuthRepository>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<AuthRepository>()),
  );
}
