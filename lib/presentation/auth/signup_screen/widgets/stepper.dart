import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/signup/signup_cubit.dart';
import '../../../../core/theming/colors.dart';

class SignupStepper extends StatelessWidget {
  const SignupStepper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => current is ChangeIndicatorStepState,
      builder: (context, state) {
        var blocWatch = context.watch<SignupCubit>();
        var blocRead = context.read<SignupCubit>();
        return SizedBox(
          height: 120,
          child: EasyStepper(
            activeStep: blocWatch.currentStep,
            stepShape: StepShape.rRectangle,
            stepBorderRadius: 15,
            borderThickness: 2,
            fitWidth: true,
            stepRadius: 28,
            enableStepTapping: false,
            finishedStepBorderColor: AppColors.black,
            finishedStepTextColor: AppColors.black,
            finishedStepBackgroundColor: AppColors.white,
            activeStepIconColor: AppColors.black,
            showLoadingAnimation: false,
            internalPadding: 16,
            padding: EdgeInsets.zero,
            steps: [
              EasyStep(
                customStep: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Opacity(
                    opacity: blocWatch.currentStep == 0 ? 1 : 0.3,
                    child: const Icon(Icons.info_outline_rounded),
                  ),
                ),
                customTitle: const Text(
                  'Your Info',
                  textAlign: TextAlign.center,
                ),
              ),
              EasyStep(
                customStep: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Opacity(
                    opacity: blocWatch.currentStep == 1 ? 1 : 0.3,
                    child: const Icon(Icons.document_scanner_rounded),
                  ),
                ),
                customTitle: const Text(
                  'Required Documents',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            onStepReached: (index) {
              blocRead.changeStepIndicator(index);
            },
          ),
        );
      },
    );
  }
}
