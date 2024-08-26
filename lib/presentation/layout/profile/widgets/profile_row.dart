import 'package:flutter/material.dart';
import 'package:turbo/core/theming/fonts.dart';

import '../../../../core/theming/colors.dart';

class ProfileRow extends StatelessWidget {
  const ProfileRow({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.suffixWidget,
    this.icon,
    this.isWithArrow = false,
    this.textColor = AppColors.textBlack,
  });

  final String title;
  final String value;
  final void Function() onTap;
  final Widget? suffixWidget;
  final bool isWithArrow;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 12,
            ),
            if (icon != null)
              Icon(
                icon,
                color: textColor,
              ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              flex: 4,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.inter16Black500,
              ),
            ),
            const Spacer(),
            if (suffixWidget != null) suffixWidget!,
            if (suffixWidget == null)
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppFonts.ibm11Grey400,
                ),
              ),
            if (isWithArrow)
              const Padding(
                padding: EdgeInsets.only(
                  top: 4.0,
                  left: 4.0,
                  right: 12.0,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.greyBorder,
                ),
              ),
            if (!isWithArrow)
              const SizedBox(
                width: 12,
              ),
          ],
        ),
      ),
    );
  }
}
