import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../theming/fonts.dart';

class WidgetWithHeader extends StatelessWidget {
  const WidgetWithHeader({
    super.key,
    required this.header,
    required this.widget,
    this.headerStyle,
    this.padding = const EdgeInsetsDirectional.symmetric(horizontal: 18.0),
  });
  final String header;
  final Widget widget;
  final EdgeInsetsDirectional padding;
  final TextStyle? headerStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.screenWidth(context),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style:headerStyle ??  AppFonts.inter16Black500,
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
