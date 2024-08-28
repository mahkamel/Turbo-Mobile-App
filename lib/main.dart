import 'dart:developer';

import 'main_paths.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationServices notificationServices = NotificationServices();
  await notificationServices.onInit();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  debugPrint("**** current flavor ${F.appFlavor} *****");
  await configureApp(F.appFlavor ?? Flavor.dev);
  await DioHelper.init(FlavorConfig.instance.baseUrl);
  await setupGetIt();
  await Future.wait([
    CacheHelper.init(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  bool isNotificationAllowed =
      await CacheHelper.getData(key: "NotificationRequest") ?? true;
  if (isNotificationAllowed) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationServices().onInit();
    await Future.delayed(const Duration(seconds: 1));
    if (Platform.isIOS) {
      if (await FirebaseMessaging.instance.getAPNSToken() != null) {
        AppConstants.fcmToken =
            await FirebaseMessaging.instance.getToken() ?? "";
      }
    } else {
      AppConstants.fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
    }
    log("tokeennn: ${AppConstants.fcmToken}");
    FirebaseMessaging.instance.setAutoInitEnabled(true);
  }
  final CustomerModel? cachedCustomer = await getCustomerData();
  log("useeerTokeneee: ${cachedCustomer?.token}");

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
