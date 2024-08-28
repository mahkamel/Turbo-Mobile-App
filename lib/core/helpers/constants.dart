import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppConstants {
  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;
  static double heightBasedOnFigmaDevice(BuildContext context, double height) {
    return MediaQuery.sizeOf(context).height * (height / 844) >= height
        ? MediaQuery.sizeOf(context).height * (height / 844)
        : height;
  }

  static double widthBasedOnFigmaDevice(BuildContext context, double width) =>
      MediaQuery.sizeOf(context).width * (width / 375) >= width
          ? MediaQuery.sizeOf(context).width * (width / 375)
          : width;

  static SizedBox verticalGap(double height) {
    return SizedBox(height: height);
  }

  static String fcmToken = '';

  static bool isFirstTimeGettingCarRec = true;

  static num vat = -1;
  static num driverFees = -1;

  //env keys
  static String devBaseUrl = "BASE_URL_DEV";
  static String filesBaseUrlDev = "FILES_BASE_DEV";

  static String qaBasUrl = "BASE_URL_QA";
  static String filesBaseUrlQA = "FILES_BASE_QA";

  static String prodBasUrl = "BASE_URL_PROD";
  static String filesBaseUrlProd = "FILES_BASE_LIVE";

  static String customerData = "CUSTOMER_KEY";
}

SizedBox horizontalGap(double width) {
  return SizedBox(width: width);
}
