import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/custom_text_fields.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/snackbar.dart';
import '../../login_screen/widgets/auth_rich_text.dart';

class SignupOtpScreen extends StatelessWidget {
  const SignupOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return SizedBox(
        width: AppConstants.screenWidth(context),
        height: AppConstants.screenHeight(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 32.0,
                bottom: 39.0,
              ),
              child: Text(
                "Please enter the code from the sms we sent you",
                style: AppFonts.inter14Black400,
                textAlign: TextAlign.center,
              ),
            ),
            BlocBuilder<SignupCubit, SignupState>(
              buildWhen: (previous, current) {
                return current is TimerState;
              },
              builder: (context, state) {
                return Text(
                  (state is TimerState) ? state.remainingTime : "2:00",
                  style: AppFonts.inter16Black500,
                );
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...List.generate(6, (index) {
                  return codeTextField(
                    context: context,
                    onChange: (value) {
                      if (value.length == 1) {
                        if (index < 5) {
                          FocusScope.of(context).requestFocus(
                            context
                                .read<SignupCubit>()
                                .codeFocusNode[index + 1],
                          );
                        } else {
                          context
                              .read<SignupCubit>()
                              .codeFocusNode[index]
                              .unfocus();
                        }
                      }
                      context.read<SignupCubit>().checkOTP();
                    },
                    controller:
                        context.read<SignupCubit>().codeControllers[index],
                    node: context.read<SignupCubit>().codeFocusNode[index],
                  );
                }),
              ],
            ),
            const Spacer(),
            BlocConsumer<SignupCubit, SignupState>(
              listenWhen: (previous, current) =>
                  current is VerifyOTPLoadingState ||
                  current is OTPVerifySuccessState ||
                  current is OTPVerifyErrorState,
              listener: (_, state) {
                if (state is OTPVerifySuccessState) {
                  if (context.read<SignupCubit>().secondsRemaining != 120) {
                    if(  context.read<SignupCubit>().otpTimer  != null) {
                      context.read<SignupCubit>().otpTimer!.cancel();
                    }
                  }
                    if (context.read<SignupCubit>().requestedCarId.isNotEmpty) {
                      context.read<SignupCubit>().changeStepIndicator(2);
                    } else {
                      Navigator.of(context).pushReplacementNamed(
                        Routes.layoutScreen,
                      );
                    }
                  // context.pushReplacementNamed(
                  //   Routes.,
                  //   arguments: context.read<SignupCubit>(),
                  // );
                } else if (state is OTPVerifyErrorState) {
                  defaultErrorSnackBar(
                    context: context,
                    message: state.errMsg,
                  );
                }
              },
              buildWhen: (previous, current) =>
                  current is VerifyOTPLoadingState ||
                  current is OTPVerifySuccessState ||
                  current is OTPVerifyErrorState,
              builder: (context, state) {
                return DefaultButton(
                  function: () {
                    context.read<SignupCubit>().verifyOTP();
                  },
                  loading: state is VerifyOTPLoadingState,
                  text: "Verify",
                  marginRight: 41,
                  marginLeft: 41,
                  // marginBottom: 20,
                );
              },
            ),
            BlocBuilder<SignupCubit, SignupState>(
              buildWhen: (previous, current) {
                return current is SendOTPLoadingState ||
                    current is TimerFinishedState ||
                    (current is TimerState &&
                        current.remainingTime == "1:59");
              },
              builder: (context, state) {
                return state is SendOTPLoadingState
                    ? const CircularProgressIndicator()
                    : context.watch<SignupCubit>().secondsRemaining == 0
                        ? AuthRichText(
                            text: "I didn’t receive the code! ",
                            buttonText: "Resend",
                            onTap: () {
                              context.read<SignupCubit>().sendOTP();
                            },
                          )
                        : const SizedBox();
              },
            ),
            // const SizedBox(
            //   height: 56,
            // ),
          ],
        ),
    );
  }
}