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
  log("tokeennn: ${AppConstants.fcmToken}");
  FirebaseMessaging.instance.setAutoInitEnabled(true);

  final CustomerModel? cachedCustomer = await getCustomerData();
  log("useeerTokeneee: ${cachedCustomer?.attachments.length}");
  log("useeerTokeneee: ${cachedCustomer?.token}");
  log("useeerTokeneee: ${cachedCustomer?.customerId}");

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
