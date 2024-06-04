import 'package:get_it/get_it.dart';

import '../../blocs/layout/layout_cubit.dart';
import '../services/networking/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  //Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  //Blocs
  getIt.registerFactory<LayoutCubit>(
    () => LayoutCubit(

    ),
  );
}
