import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/screens_arguments.dart';
import 'package:turbo/core/services/local/token_service.dart';
import 'package:turbo/presentation/auth/requests/widgets/signup_confirm_booking.dart';
import 'package:turbo/presentation/auth/requests/widgets/signup_form.dart';
import 'package:turbo/presentation/auth/requests/widgets/stepper.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/helpers/dropdown_keys.dart';
import '../../../core/routing/routes.dart';
import '../../../core/widgets/custom_header.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocWatch = context.watch<SignupCubit>();
    var blocRead = context.read<SignupCubit>();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (UserTokenService.currentUserToken.isEmpty) {
          context.pushReplacementNamed(
            Routes.loginScreen,
            arguments: LoginScreenArguments(
              carId: blocRead.requestedCarId,
              dailyPrice: blocRead.dailyPrice,
              weeklyPrice: blocRead.weeklyPrice,
              monthlyPrice: blocRead.monthlyPrice,
            ),
          );
        } else if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: SizedBox(
          width: AppConstants.screenWidth(context),
          height: AppConstants.screenHeight(context),
          child: InkWell(
            highlightColor: Colors.transparent,
            onTap: () {
              if (clientTypeKey.currentState != null) {
                if (clientTypeKey.currentState!.isOpen) {
                  clientTypeKey.currentState!.closeBottomSheet();
                }
              }
            },
            child: Column(
              children: [
                DefaultHeader(
                  header: UserTokenService.currentUserToken.isNotEmpty
                      ? "Confirm Booking"
                      : "signUp".getLocale(context: context),
                  textAlignment: AlignmentDirectional.topCenter,
                  onBackPressed: () {
                    if (UserTokenService.currentUserToken.isEmpty) {
                      context.pushReplacementNamed(
                        Routes.loginScreen,
                        arguments: LoginScreenArguments(
                          carId: blocRead.requestedCarId,
                          dailyPrice: blocRead.dailyPrice,
                          weeklyPrice: blocRead.weeklyPrice,
                          monthlyPrice: blocRead.monthlyPrice,
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (UserTokenService.currentUserToken.isEmpty &&
                    blocWatch.requestedCarId.isNotEmpty)
                  const SignupStepper(),
                if ((blocWatch.requestedCarId.isNotEmpty &&
                        blocWatch.currentStep == 0) ||
                    ((UserTokenService.currentUserToken.isEmpty &&
                        blocWatch.currentStep == 0)))
                  const InfoStepForm(),
                if ((blocWatch.requestedCarId.isNotEmpty &&
                        blocWatch.currentStep == 1) &&
                    (((UserTokenService.currentUserToken.isEmpty &&
                            blocWatch.currentStep == 1)) ||
                        UserTokenService.currentUserToken.isNotEmpty))
                  const Expanded(
                    child: SignupConfirmBooking(),
                  ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
