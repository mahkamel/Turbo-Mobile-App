import 'dart:developer';
import 'dart:io';


import 'bloc_observe.dart';
import 'core/routing/app_router.dart';
import 'core/services/local/cache_helper.dart';
import 'flavors.dart';
import 'main_paths.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationServices notificationServices = NotificationServices();
  await notificationServices.onInit();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await configureApp(Flavor.QA);
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
  log("useeerTokeneee: ${cachedCustomer?.token}",
  );

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
