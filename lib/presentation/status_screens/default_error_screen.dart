import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_buttons.dart';

class DefaultErrorScreen extends StatelessWidget {
  const DefaultErrorScreen({
    super.key,
    required this.errMsg,
  });

  final String errMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: AppConstants.heightBasedOnFigmaDevice(context,
                    AppConstants.screenHeight(context) < 600 ? 40 : 150),
              ),
              SvgPicture.asset(
                "assets/images/icons/error_img.svg",
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 18.0,
                  bottom: 34.0,
                ),
                child: Text(
                  "Error",
                  style: AppFonts.inter28Black600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Text(
                  errMsg,
                  style: AppFonts.inter16Black400,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              DefaultButton(
                function: () {
                  Navigator.of(context).pop();
                },
                text: "Ok",
                borderRadius: 0,
                color: AppColors.errorRed,
                border: Border.all(color: AppColors.buttonGreyBorder),
                marginLeft: 41,
                marginRight: 41,
                marginBottom:
                    AppConstants.heightBasedOnFigmaDevice(context, 37),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
