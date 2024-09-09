import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/presentation/auth/requests/widgets/otp_timer.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/custom_text_fields.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/snackbar.dart';
import '../../login_screen/widgets/auth_rich_text.dart';

class SignupOtpScreen extends StatefulWidget {
  const SignupOtpScreen({super.key});

  @override
  State<SignupOtpScreen> createState() => _SignupOtpScreenState();
}

class _SignupOtpScreenState extends State<SignupOtpScreen> {
  Timer? otpTimer;
  int secondsRemaining = 120;
  String formattedTime = "2:00";
  void startTimer() {
    secondsRemaining = 120;
    formattedTime = "2:00";
    if (secondsRemaining != 120) {
      if (otpTimer != null) {
        otpTimer!.cancel();
      }
    }
    otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsRemaining--;
      final minutes = secondsRemaining ~/ 60;
      final seconds = secondsRemaining % 60;
      setState(() {
        formattedTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
      });

      if (secondsRemaining <= 0) {
        setState(() {
          if (otpTimer != null) {
            otpTimer!.cancel();
          }
        });
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (otpTimer != null) {
      otpTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.screenWidth(context),
      height: AppConstants.screenHeight(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 32.0,
              bottom: 15.0,
            ),
            child: Text(
              "Enter the 6-digit code sent to ${context.read<SignupCubit>().phoneNumber}",
              style: AppFonts.ibm16LightBlack400,
              textAlign: TextAlign.center,
            ),
          ),
           BlocBuilder<SignupCubit, SignupState>(
            buildWhen: (previous, current) {
              return current is SendOTPLoadingState ||
                  current is TimerFinishedState ||
                  (current is TimerState && current.remainingTime == "1:59") ||
                  current is OTPSentSuccessState ||
                  current is OTPSentErrorState;
            },
            builder: (context, state) {
              return state is SendOTPLoadingState
                  ? const CircularProgressIndicator()
                  : secondsRemaining == 0
                      ? AuthRichText(
                        text: "Didn’t get a code?",
                        buttonText: "Send again",
                        buttonStyle: AppFonts.ibm16Gold600.copyWith(fontWeight: FontWeight.w700),
                        alignmentDirectional: AlignmentDirectional.center,
                        onTap: () async {
                          await context.read<SignupCubit>().sendOTP().then(
                            (value) {
                              if (value) {
                                startTimer();
                              }
                            },
                          );
                        },
                      )
                      : const SizedBox();
            },
          ),
          const SizedBox(
            height: 50,
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
                          context.read<SignupCubit>().codeFocusNode[index + 1],
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
          const SizedBox(height: 30,),
          OTPTimer(formattedTime: formattedTime,),
          const Spacer(),
          BlocConsumer<SignupCubit, SignupState>(
            listenWhen: (previous, current) =>
                current is VerifyOTPLoadingState ||
                current is OTPVerifySuccessState ||
                current is OTPVerifyErrorState,
            listener: (_, state) {
              if (state is OTPVerifySuccessState) {
                if (secondsRemaining != 120) {
                  if (otpTimer != null) {
                    otpTimer!.cancel();
                  }
                }
                if (context.read<SignupCubit>().requestedCarId.isNotEmpty) {
                  context.read<SignupCubit>().changeStepIndicator(2);
                } else {
                  Navigator.of(context).pushReplacementNamed(
                    Routes.layoutScreen,
                  );
                }
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
                marginBottom: 20,
              );
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
