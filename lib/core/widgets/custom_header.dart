import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../theming/colors.dart';
import '../theming/fonts.dart';

class DefaultHeader extends StatelessWidget {
  const DefaultHeader({
    super.key,
    required this.header,
    this.onBackPressed,
    this.height = 46,
    this.alignment = MainAxisAlignment.start,
    this.textAlignment,
    this.isShowPrefixIcon = true,
    this.textLeftPadding = 0,
    this.suffixIcon,
  });

  final double height;
  final double textLeftPadding;
  final String header;
  final MainAxisAlignment alignment;
  final bool isShowPrefixIcon;
  final Widget? suffixIcon;
  final void Function()? onBackPressed;
  final AlignmentDirectional? textAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: AppConstants.screenWidth(context),
      margin: EdgeInsets.only(
        top: AppConstants.heightBasedOnFigmaDevice(context, 16),
      ),
      color: Colors.transparent,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Align(
            alignment: textAlignment ?? AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: textLeftPadding,
              ),
              child: Text(
                header,
                style: AppFonts.ibm24HeaderBlue600.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize:  AppConstants.screenHeight(context) < 600
                      ? 20:24,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: alignment,
            children: [
              if (isShowPrefixIcon)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: onBackPressed ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                                color: AppColors.black.withOpacity(0.15)),
                            BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 0,
                                offset: const Offset(0, 1),
                                color: AppColors.black.withOpacity(0.30))
                          ]),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              if (suffixIcon != null)
                Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: suffixIcon!)
            ],
          ),
        ],
      ),
    );
  }
}
