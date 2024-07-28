import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/fonts.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.screenWidth(context),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20.0,
            top: 12,
          ),
          child: SizedBox(
            height: 38,
            width: 160,
            child: InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
              },
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "forgetPassword".getLocale(context: context),
                  style: AppFonts.inter16Black500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
