import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:turbo/presentation/auth/signup_screen/widgets/signup_form.dart';
import 'package:turbo/presentation/auth/signup_screen/widgets/stepper.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/routing/routes.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../core/widgets/custom_header.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<CustomDropdownState> clientTypeKey =
        GlobalKey<CustomDropdownState>();
    var blocWatch = context.watch<SignupCubit>();
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: AppConstants.screenWidth(context),
        height: AppConstants.screenHeight(context),
        child: Column(
          children: [
            DefaultHeader(
              header: "Signup",
              textAlignment: AlignmentDirectional.topCenter,
              onBackPressed: () {
                context.pushNamedAndRemoveUntil(
                  Routes.loginScreen,
                  predicate: (route) => false,
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const SignupStepper(),
            if (blocWatch.currentStep == 0)
              InfoStepForm(
                clientTypeKey: clientTypeKey,
              ),
            if (blocWatch.currentStep == 1)
              Expanded(
                  child: Container(
                color: AppColors.buttonGreyBorder,
              ))
          ],
        ),
      )),
    );
  }
}
