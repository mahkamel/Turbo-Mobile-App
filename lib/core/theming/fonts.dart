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


  static TextStyle sfPro22HeaderBlack700 =
  navigatorKey.currentContext != null &&
      AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
    fontFamily: 'SFPro',
    fontSize: 22.0.sp(navigatorKey.currentContext!),
    fontWeight: FontWeight.w700,
    color: AppColors.headerBlack,
  )
      : const TextStyle(
    fontFamily: 'SFPro',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.headerBlack,
  );


  static TextStyle sfPro18HeaderBlack700 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'SFPro',
              fontSize: 18.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w700,
              color: AppColors.headerBlack,
            )
          : const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.headerBlack,
            );

  static TextStyle sfPro18Black500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 18.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        );

  static TextStyle sfPro18White500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 18.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 18,
          fontWeight: FontWeight.w500,
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

  static TextStyle sfPro16TypeGreyHeader600 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'SFPro',
              fontSize: 16.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w600,
              color: AppColors.typeGreyHeader,
            )
          : const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.typeGreyHeader,
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

  static TextStyle sfPro16Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 16.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        );

  static TextStyle sfPro15Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 15.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        );
  static TextStyle sfPro15buttonGreyBorder400 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'SFPro',
              fontSize: 15.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w400,
              color: AppColors.buttonGreyBorder)
          : const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.buttonGreyBorder,
            );


  static TextStyle sfPro14Grey400 = navigatorKey.currentContext != null &&
      AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
    fontFamily: 'SFPro',
    fontSize: 14.0.sp(navigatorKey.currentContext!),
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  )
      : const TextStyle(
    fontFamily: 'SFPro',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
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

  static TextStyle sfPro14Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 14.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        );
  static TextStyle sfPro14ErrorRed400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'SFPro',
          fontSize: 14.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.errorRed,
        )
      : const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.errorRed,
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
