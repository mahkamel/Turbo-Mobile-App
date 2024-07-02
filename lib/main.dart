import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:turbo/core/di/dependency_injection.dart';
import 'package:turbo/core/helpers/functions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:turbo/models/customer_model.dart';
import 'package:turbo/turbo_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/helpers/constants.dart';
import 'core/services/networking/dio_helper.dart';
import 'core/services/notifications_service.dart';
import 'firebase_options.dart';

import 'bloc_observe.dart';
import 'core/routing/app_router.dart';
import 'core/services/local/cache_helper.dart';
import 'flavors.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationServices notificationServices = NotificationServices();
  await notificationServices.onInit();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await configureApp(Flavor.DEV);
  await DioHelper.init(FlavorConfig.instance.baseUrl);
  await setupGetIt();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Future.wait([
    CacheHelper.init(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  NotificationServices().onInit();
  await Future.delayed(const Duration(seconds: 1));
  if (kIsWeb) {
    // AppConstants.fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BO4fsO8a7cQQLhN5dC0mTY3FsXI7JrFZstKiJqMqY4y4aR6ctsIc_4-rUBCdpb1EHAPTqyA2G_3sdUpevG4pZ_Q") ?? "";
  } else {
    if (Platform.isIOS) {
      if (await FirebaseMessaging.instance.getAPNSToken() != null) {
        AppConstants.fcmToken =
            await FirebaseMessaging.instance.getToken() ?? "";
      }
    } else {
      AppConstants.fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
    }
  }
  debugPrint("tokeennn: ${AppConstants.fcmToken}");
  FirebaseMessaging.instance.setAutoInitEnabled(true);

  final CustomerModel? cachedCustomer = await getCustomerData();
  debugPrint("useeerTokeneee: ${cachedCustomer?.token}");

  Bloc.observer = MyBlocObserver();
  final bool isFirstTime =
      await CacheHelper.getData(key: "isFirstTime") ?? true;
  runApp(
    MyApp(
      appRouter: AppRouter(),
      isFirstTime: isFirstTime,
      customer: cachedCustomer,
    ),
  );
}
