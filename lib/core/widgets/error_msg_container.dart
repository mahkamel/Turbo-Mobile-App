import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../theming/colors.dart';
import '../theming/fonts.dart';

class ErrorMsgContainer extends StatelessWidget {
  const ErrorMsgContainer({
    super.key,
    required this.errMsg,
    this.margin = const EdgeInsetsDirectional.only(
      start: 26,
      end: 26,
      top: 10,
      bottom: 12,
    ),
  });

  final String errMsg;
  final EdgeInsetsDirectional margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: AppConstants.screenWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.lightRed,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          errMsg,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppFonts.ibm14ErrorRed400,
        ),
      ),
    );
  }
}
