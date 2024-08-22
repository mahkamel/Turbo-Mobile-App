import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/core/widgets/custom_text_fields.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/auth/login_screen/widgets/auth_rich_text.dart';

class OtpForgetPassword extends StatefulWidget {
  const OtpForgetPassword({super.key});

  @override
  State<OtpForgetPassword> createState() => _OtpForgetPasswordState();
}

class _OtpForgetPasswordState extends State<OtpForgetPassword> {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          width: AppConstants.screenWidth(context),
          height: AppConstants.screenHeight(context),
          child: Column(
            children: [
              DefaultHeader(
                header: "",
                onBackPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                      Routes.forgetPasswordScreen,
                      arguments: context.read<LoginCubit>());
                },
              ),
              RepaintBoundary(
                key: const Key("OTPTimer"),
                child: Text(
                  formattedTime,
                  style: AppFonts.inter16Black500,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  //todo
                  ...List.generate(6, (index) {
                    return codeTextField(
                        context: context,
                        onChange: (value) {
                          if (value.length == 1) {
                            if (index < 5) {
                              FocusScope.of(context).requestFocus(
                                context
                                    .read<LoginCubit>()
                                    .codeFocusNode[index + 1],
                              );
                            } else {
                              context
                                  .read<LoginCubit>()
                                  .codeFocusNode[index]
                                  .unfocus();
                            }
                          }
                          context.read<LoginCubit>().checkOTP();
                        },
                        controller:
                            context.read<LoginCubit>().codeControllers[index],
                        node: context.read<LoginCubit>().codeFocusNode[index],
                        isFromForgetPassword: true);
                  }),
                ],
              ),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (previous, current) {
                  return current is CheckOtpSuccessState ||
                    current is CheckOtpErrorState ||
                    current is CheckOtpLoadingState ||
                    current is ForgetPasswordErrorState ||
                    current is ForgetPasswordSuccessState ||
                    current is ForgetPasswordLoadingState;
                },
                builder: (context, state) {
                  return state is CheckOtpLoadingState
                      ? const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: CircularProgressIndicator(),
                        )
                      : secondsRemaining == 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: AuthRichText(
                                text: "You didn’t receive the code! ",
                                buttonText: "Resend",
                                onTap: () async {
                                  await context
                                      .read<LoginCubit>()
                                      .forgetPassword()
                                      .then(
                                    (value) {
                                      if (value) {
                                        startTimer();
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          : const SizedBox();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Check Your mail",
                      style: AppFonts.ibm24HeaderBlue600,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "We have sent a password rest instructions to your email.",
                      style: AppFonts.ibm12SubTextGrey600,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              BlocConsumer<LoginCubit, LoginState>(
                listenWhen: (previous, current) =>
                  current is CheckOtpLoadingState ||
                  current is CheckOtpSuccessState ||
                  current is CheckOtpErrorState,
                listener: (context, state) {
                  if (state is CheckOtpSuccessState) {
                    if (secondsRemaining != 120) {
                      if (otpTimer != null) {
                        otpTimer!.cancel();
                      }
                    }
                    Navigator.of(context).pushReplacementNamed(
                      Routes.createNewPasswordScreen,
                      arguments: context.read<LoginCubit>());
                  } else if (state is CheckOtpErrorState) {
                    defaultErrorSnackBar(
                      context: context,
                      message: state.errMsg,
                    );
                  }
                },
                buildWhen: (previous, current) {
                  return current is CheckOtpLoadingState ||
                  current is CheckOtpSuccessState ||
                  current is CheckOtpErrorState;
                },
                builder: (context, state) {
                  return DefaultButton(
                    function: () {
                      //todo don't forget to remove the navigation
                      // context.read<LoginCubit>().verifyOTP();
                      Navigator.of(context).pushReplacementNamed(
                      Routes.createNewPasswordScreen,
                      arguments: context.read<LoginCubit>());
                    },
                    text: "Verify",
                    marginRight: 41,
                    marginLeft: 41,
                    marginBottom: 20,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}