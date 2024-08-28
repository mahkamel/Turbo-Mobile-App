import 'dart:io';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../theming/colors.dart';
import 'local/cache_helper.dart';

class NotificationServices {
  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();

  Future<void> onInit() async {
    try {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      NotificationSettings? settings;
      if (Platform.isAndroid) {
        await _awesomeNotifications.isNotificationAllowed().then(
          (value) async {
            CacheHelper.setData(key: "NotificationRequest", value: value);
            if (value) {
              AwesomeNotifications().initialize(
                  null,
                  [
                    NotificationChannel(
                      channelGroupKey: 'basic_channel_group',
                      channelKey: 'basic_channel',
                      channelName: 'Basic notifications',
                      channelDescription:
                          'Notification channel for basic tests',
                      ledColor: AppColors.primaryGreen,
                      playSound: true,
                      importance: NotificationImportance.High,
                      channelShowBadge: true,
                      enableVibration: true,
                      enableLights: true,
                    )
                  ],
                  // Channel groups are only visual and are not required
                  channelGroups: [
                    NotificationChannelGroup(
                        channelGroupKey: 'basic_channel_group',
                        channelGroupName: 'Basic group')
                  ],
                  debug: true);
              settings = await firebaseMessaging.requestPermission(
                alert: true,
                announcement: false,
                badge: true,
                carPlay: false,
                criticalAlert: false,
                provisional: false,
                sound: true,
              );
              await FirebaseMessaging.instance
                  .setForegroundNotificationPresentationOptions(
                alert: true,
                badge: true,
                sound: true,
              );
            } else {
              await _awesomeNotifications
                  .requestPermissionToSendNotifications()
                  .then(  
                (value) async {
                  if (await _awesomeNotifications.isNotificationAllowed()) {
                    CacheHelper.setData(
                        key: "NotificationRequest", value: true);
                    AwesomeNotifications().initialize(
                        null,
                        [
                          NotificationChannel(
                            channelGroupKey: 'basic_channel_group',
                            channelKey: 'basic_channel',
                            channelName: 'Basic notifications',
                            channelDescription:
                                'Notification channel for basic tests',
                            ledColor: AppColors.primaryGreen,
                            playSound: true,
                            importance: NotificationImportance.High,
                            channelShowBadge: true,
                            enableVibration: true,
                            enableLights: true,
                          )
                        ],
                        // Channel groups are only visual and are not required
                        channelGroups: [
                          NotificationChannelGroup(
                              channelGroupKey: 'basic_channel_group',
                              channelGroupName: 'Basic group')
                        ],
                        debug: true);
                    settings = await firebaseMessaging.requestPermission(
                      alert: true,
                      announcement: false,
                      badge: true,
                      carPlay: false,
                      criticalAlert: false,
                      provisional: false,
                      sound: true,
                    );
                    await FirebaseMessaging.instance
                        .setForegroundNotificationPresentationOptions(
                      alert: true,
                      badge: true,
                      sound: true,
                    );
                  } else {
                    CacheHelper.setData(
                        key: "NotificationRequest", value: false);
                  }
                },
              );
            }
          },
        );
      }
      if (settings!.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (message.notification != null) {
            final notification = message.notification;
            showNotification(
              title: notification?.title ?? '',
              body: notification?.body,
              imageUrl: notification?.android?.imageUrl,
              payload: message.data
                  .map((key, value) => MapEntry(key, value.toString())),
            );
          }
        });
      }
    } catch (e) {}
  }

  void showNotification({
    required String title,
    String? body,
    Map<String, String>? payload,
    String? imageUrl,
  }) async {
    _awesomeNotifications.createNotification(
      content: NotificationContent(
        id: Random().nextInt(10000000),
        channelKey: "basic_channel",
        title: title,
        body: body,
        displayOnBackground: true,
        displayOnForeground: true,
        payload: payload,
      ),
    );
  }
}
