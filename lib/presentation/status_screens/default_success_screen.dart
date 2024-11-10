import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../core/theming/colors.dart';
import '../../core/helpers/constants.dart';
import '../../core/theming/fonts.dart';
import '../../core/widgets/default_buttons.dart';

class DefaultSuccessScreen extends StatelessWidget {
  const DefaultSuccessScreen({
    super.key,
    required this.message,
    required this.title,
    required this.onOkPressed,
    this.route,
    this.lottiePath,
    this.arguments = const [],
  });

  final String title;
  final String message;
  final String? route;
  final String? lottiePath;
  final dynamic arguments;
  final VoidCallback onOkPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SizedBox(
          height: AppConstants.screenHeight(context),
          width: AppConstants.screenWidth(context),
          child: SafeArea(
            child: AppConstants.screenHeight(context) < 600
                ? ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: AppConstants.heightBasedOnFigmaDevice(
                            context,
                            AppConstants.screenHeight(context) < 600
                                ? 30
                                : 90),
                      ),
                      if (lottiePath != null) Lottie.asset(lottiePath!),
                      if (lottiePath == null)
                        SvgPicture.asset(
                          "assets/images/icons/success_img.svg",
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 18.0,
                          bottom: 34.0,
                          left: 20,
                          right: 20,
                        ),
                        child: Text(
                          title,
                          style: AppFonts.ibm24HeaderBlue600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          message,
                          style: AppFonts.ibm15Grey400_600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DefaultButton(
                        function: route == null
                            ? onOkPressed
                            : () {
                                if (route != null) {
                                  context.pushReplacementNamed(
                                    route!,
                                    arguments: arguments,
                                  );
                                }
                              },
                        text: "Ok",
                        borderRadius: 0,
                        border: Border.all(color: AppColors.buttonGreyBorder),
                        marginLeft: 20,
                        marginRight: 20,
                        marginTop: 20,
                        marginBottom:
                            AppConstants.heightBasedOnFigmaDevice(context, 37),
                      ),
                    ],
                  )
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: AppConstants.heightBasedOnFigmaDevice(
                            context,
                            AppConstants.screenHeight(context) < 600
                                ? 30
                                : 90),
                      ),
                      if (lottiePath != null) Lottie.asset(lottiePath!),
                      if (lottiePath == null)
                        SvgPicture.asset(
                          "assets/images/icons/success_img.svg",
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 18.0,
                          bottom: 34.0,
                          left: 20,
                          right: 20,
                        ),
                        child: Text(
                          title,
                          style: AppFonts.ibm24HeaderBlue600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          message,
                          style: AppFonts.ibm15Grey400_600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // const Spacer(),
                      DefaultButton(
                        function: route == null
                            ? onOkPressed
                            : () {
                                if (route != null) {
                                  context.pushReplacementNamed(
                                    route!,
                                    arguments: arguments,
                                  );
                                }
                              },
                        text: "Ok",
                        borderRadius: 0,
                        border: Border.all(color: AppColors.buttonGreyBorder),
                        marginLeft: 20,
                        marginRight: 20,
                        marginTop: 20,
                        marginBottom:
                            AppConstants.heightBasedOnFigmaDevice(context, 37),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
