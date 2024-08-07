import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../theming/colors.dart';
import '../theming/fonts.dart';

class DefaultHeader extends StatelessWidget {
  const DefaultHeader({
    super.key,
    required this.header,
    this.onBackPressed,
    this.height = 27,
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
      margin: EdgeInsets.only(
        top: AppConstants.heightBasedOnFigmaDevice(context, 36),
      ),
      color: Colors.transparent,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Align(
            alignment: textAlignment ?? AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: textLeftPadding,
              ),
              child: Text(
                header,
                style: AppFonts.inter20HeaderBlack700.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: alignment,
            children: [
              if (isShowPrefixIcon)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: onBackPressed ??
                        () {
                          Navigator.pop(context);
                        },
                    child: const SizedBox(
                      height: 25,
                      width: 40,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              if (suffixIcon != null) suffixIcon!
            ],
          ),
        ],
      ),
    );
  }
}
