import 'package:flutter/material.dart';

import '../../../../../core/theming/fonts.dart';
import 'container_with_shadow.dart';

class ShadowContainerWithPrefixTextButton extends StatelessWidget {
  const ShadowContainerWithPrefixTextButton({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onTap,
    this.margin,
    this.prefixIcon,
  });

  final String title;
  final String buttonText;
  final void Function() onTap;
  final EdgeInsets? margin;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: DefaultContainerWithShadow(
        height: 52,
        radius: 10,
        marginStart: margin?.left ?? 0.0,
        marginTop: margin?.top ?? 0.0,
        marginEnd: margin?.right ?? 0.0,
        marginBottom: margin?.bottom ?? 0.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: buttonText.isNotEmpty
                  ? AppFonts.inter16Black400.copyWith(
                      fontWeight: FontWeight.w300,
                    )
                  : AppFonts.inter16Black400,
            ),
            prefixIcon ??
                Text(
                  buttonText,
                  style: AppFonts.inter14PrimaryBlue500,
                ),
          ],
        ),
      ),
    );
  }
}
