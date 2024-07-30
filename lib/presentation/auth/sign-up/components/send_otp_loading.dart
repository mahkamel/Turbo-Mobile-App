import 'package:flutter/material.dart'
    show
        BuildContext,
        Center,
        CircularProgressIndicator,
        Container,
        SizedBox,
        StatelessWidget,
        Widget;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, ReadContext;
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/signup/signup_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/snackbar.dart';

class SendOTPLoading extends StatelessWidget {
  const SendOTPLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          current is SendOTPLoadingState ||
          current is OTPSentSuccessState ||
          current is OTPSentErrorState,
      buildWhen: (previous, current) =>
          current is SendOTPLoadingState ||
          current is OTPSentSuccessState ||
          current is OTPSentErrorState,
      listener: (_, state) {
        if (state is OTPSentSuccessState) {
          if (state.isFromStepOne) {
            for (var ctrl in context.read<SignupCubit>().codeControllers) {
              ctrl.clear();
            }
            context.pushNamed(
              Routes.signupOTPScreen,
              arguments: context.read<SignupCubit>(),
            );
          }
        } else if (state is OTPSentErrorState) {
          defaultErrorSnackBar(
            context: context,
            message: state.errMsg,
          );
        }
      },
      builder: (context, state) {
        if (state is SendOTPLoadingState) {
          return Container(
            width: AppConstants.screenWidth(context),
            height: AppConstants.screenHeight(context),
            color: AppColors.black.withOpacity(0.16),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
