import 'package:flutter/material.dart';
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
          alignment: AlignmentDirectional.centerStart,
          child: Text.rich(
            TextSpan(
              text: text,
              style: AppFonts.ibm16Grey400,
              children: [
                TextSpan(
                  text: " $buttonText",
                  style: AppFonts.ibm16PrimaryBlue600
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
