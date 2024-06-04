import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:turbo/core/di/dependency_injection.dart';
import 'package:turbo/turbo_app.dart';

import 'bloc_observe.dart';
import 'core/routing/app_router.dart';
import 'core/services/local/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await setupGetIt();
  Bloc.observer = MyBlocObserver();
  final bool isFirstTime =
      await CacheHelper.getData(key: "isFirstTime") ?? true;
  runApp(
    MyApp(
      appRouter: AppRouter(),
      isFirstTime: isFirstTime,
    ),
  );
}
