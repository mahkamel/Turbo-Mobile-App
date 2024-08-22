import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../theming/colors.dart';
import '../theming/fonts.dart';

class WidgetWithHeader extends StatelessWidget {
  const WidgetWithHeader(
      {super.key,
      required this.header,
      required this.widget,
      this.headerStyle,
      this.width,
      this.isWithBlackHeader = false,
      this.padding = const EdgeInsetsDirectional.symmetric(horizontal: 18.0),
      this.isRequiredField = false});
  final String header;
  final Widget widget;
  final EdgeInsetsDirectional padding;
  final TextStyle? headerStyle;
  final double? width;
  final bool isWithBlackHeader;
  final bool isRequiredField;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? AppConstants.screenWidth(context),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isRequiredField
                ? Text.rich(
                    TextSpan(
                        text: header,
                        style: headerStyle ??
                            AppFonts.inter16Black500.copyWith(
                              color: isWithBlackHeader
                                  ? AppColors.black
                                  : AppColors.primaryBlue,
                            ),
                        children: [
                          TextSpan(
                            text: "*",
                            style: headerStyle ??
                                AppFonts.inter16Black500.copyWith(
                                  color: isWithBlackHeader
                                      ? AppColors.black
                                      : AppColors.primaryBlue,
                                ),
                          )
                        ]),
                  )
                : Text(
                    header,
                    style: headerStyle ??
                        AppFonts.inter16Black500.copyWith(
                          color: isWithBlackHeader
                              ? AppColors.black
                              : AppColors.primaryBlue,
                        ),
                  ),
            const SizedBox(
              height: 8,
            ),
            widget,
          ],
        ),
      ),
    );
  }
}
