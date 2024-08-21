import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../helpers/constants.dart';
import 'colors.dart';

class AppFonts {
  static TextStyle inter28White600 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 28.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        );

  static TextStyle inter28Black600 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 28.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        );

    static TextStyle ibm15LightBlack400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'IBM',
          fontSize: 15.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.lightBlack,
        )
      : const TextStyle(
          fontFamily: 'IBM',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.lightBlack,
        );

        static TextStyle ibm15subTextGrey400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'IBM',
          fontSize: 15.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.subTextGrey,
        )
      : const TextStyle(
          fontFamily: 'IBM',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.subTextGrey,
        );

  static TextStyle inter24White600 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 24.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        );

  static TextStyle ibm24HeaderBlue600 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'IBM',
              fontSize: 24.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            )
          : const TextStyle(
              fontFamily: 'IBM',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            );

    static TextStyle ibm16White700 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'IBM',
              fontSize: 16.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            )
          : const TextStyle(
              fontFamily: 'IBM',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            );
  


  static TextStyle inter18HeaderBlack700 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w700,
              color: AppColors.headerBlack,
            )
          : const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.headerBlack,
            );

  static TextStyle inter18Black500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 18.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        );

    static TextStyle ibm20Black600 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'IBM',
          fontSize: 20.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'IBM',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        );


  static TextStyle inter18White500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 18.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        );

  static TextStyle inter18BottomSheetGrey400 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w400,
              color: AppColors.bottomSheetGrey,
            )
          : const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.bottomSheetGrey,
            );

  static TextStyle ibm16SubTextGrey400 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'IBM',
              fontSize: 16.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w400,
              color: AppColors.subTextGrey,
            )
          : const TextStyle(
              fontFamily: 'IBM',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.subTextGrey,
            );

  static TextStyle inter16LocationBlue600 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w600,
              color: AppColors.locationBlue,
            )
          : const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.locationBlue,
            );

  static TextStyle inter16TypeGreyHeader600 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w600,
              color: AppColors.typeGreyHeader,
            )
          : const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.typeGreyHeader,
            );

  static TextStyle inter16Black600 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 16.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        );

  static TextStyle inter16Black500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 16.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        );

  static TextStyle inter16Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 16.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        );

  static TextStyle inter16BottomSheetGreyGrey100 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w100,
              color: AppColors.bottomSheetGrey,
            )
          : const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w100,
              color: AppColors.bottomSheetGrey,
            );

  static TextStyle inter15Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        );

  static TextStyle inter15buttonGreyBorder400 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w400,
              color: AppColors.buttonGreyBorder)
          : const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.buttonGreyBorder,
            );

  static TextStyle inter14TextBlack500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.textBlack,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textBlack,
        );

  static TextStyle inter14Grey400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
        );


  static TextStyle inter14PrimaryBlue500 = navigatorKey.currentContext != null &&
      AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0.sp(navigatorKey.currentContext!),
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlue,
  )
      : const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlue,
  );


  static TextStyle inter14White500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        );

  static TextStyle inter14Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        );
  static TextStyle inter14HeaderBlack400 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w400,
              color: AppColors.headerBlack,
            )
          : const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.headerBlack,
            );
  static TextStyle inter14ErrorRed400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.errorRed,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.errorRed,
        );

  static TextStyle inter14BottomSheetDarkerGrey400 =
  navigatorKey.currentContext != null &&
      AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0.sp(navigatorKey.currentContext!),
    fontWeight: FontWeight.w400,
    color: AppColors.bottomSheetDarkerGrey,
  )
      : const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.bottomSheetDarkerGrey,
  );

  static TextStyle inter14Black800_400 =
  navigatorKey.currentContext != null &&
      AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0.sp(navigatorKey.currentContext!),
    fontWeight: FontWeight.w400,
    color: AppColors.black800,
  )
      : const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black800,
  );

  static TextStyle inter14BottomSheetDarkerGrey100 =
      navigatorKey.currentContext != null &&
              AppConstants.screenWidth(navigatorKey.currentContext!) < 600
          ? TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0.sp(navigatorKey.currentContext!),
              fontWeight: FontWeight.w100,
              color: AppColors.bottomSheetDarkerGrey,
            )
          : const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w100,
              color: AppColors.bottomSheetDarkerGrey,
            );

  static TextStyle inter12Black500 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        );
  static TextStyle inter12Grey400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
        );
  static TextStyle inter12Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        );
}
