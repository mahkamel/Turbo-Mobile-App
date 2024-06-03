import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../helpers/constants.dart';
import 'colors.dart';

class AppFonts {
  static TextStyle sfPro12Black400 = navigatorKey.currentContext != null &&
          AppConstants.screenWidth(navigatorKey.currentContext!) < 600
      ? TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.0.sp(navigatorKey.currentContext!),
          fontWeight: FontWeight.w400,
          color: AppColors.navBarGrey,
        )
      : const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.navBarGrey,
        );
}
