import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../helpers/constants.dart';
import 'colors.dart';

class AppFonts {
  static TextStyle sfPro28White600 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 28.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        );

  static TextStyle sfPro24White600 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 24.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        );

  static TextStyle sfPro18SubTextGrey400 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'SFPro',
              fontSize: 18.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w400,
              color: AppColors.subTextGrey,
            )
          : const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.subTextGrey,
            );

  static TextStyle sfPro16LocationBlue600 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'SFPro',
              fontSize: 16.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w600,
              color: AppColors.locationBlue,
            )
          : const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.locationBlue,
            );

  static TextStyle sfPro16Black500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 16.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        );

  static TextStyle sfPro14White500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 14.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        );

  static TextStyle sfPro12Grey400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 12.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
        );
  static TextStyle sfPro12Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 12.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        );
}
