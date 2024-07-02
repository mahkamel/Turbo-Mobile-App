import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class AuthRichText extends StatelessWidget {
  const AuthRichText({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onTap,
  });

  final String text;
  final String buttonText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Align(
          alignment: AlignmentDirectional.center,
          child: Text.rich(
            TextSpan(
              text: text,
              style: AppFonts.inter16Black500,
              children: [
                TextSpan(
                  text: " $buttonText",
                  style: AppFonts.inter16Black500
                      .copyWith(color: AppColors.primaryRed),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
