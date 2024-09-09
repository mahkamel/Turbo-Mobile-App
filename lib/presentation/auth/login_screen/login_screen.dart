import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/screens_arguments.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/auth/login_screen/widgets/auth_rich_text.dart';
import 'package:turbo/presentation/auth/login_screen/widgets/forget_pass_button.dart';
import 'package:turbo/presentation/auth/login_screen/widgets/login_password.dart';

import '../../../core/helpers/enums.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/default_dialog.dart';
import '../../../core/widgets/text_field_with_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    this.requestedCarId,
    this.dailyPrice,
    this.weeklyPrice,
    this.monthlyPrice,
  });
  final String? requestedCarId;
  final num? dailyPrice;
  final num? weeklyPrice;
  final num? monthlyPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: AppConstants.screenHeight(context),
          width: AppConstants.screenWidth(context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DefaultHeader(
                  header: "login".getLocale(context: context),
                  textAlignment: AlignmentDirectional.center,
                ),
                const SizedBox(
                  height: 48,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      current is CheckLoginEmailValidationState,
                  builder: (context, state) {
                    return const LoginEmail();
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      current is CheckLoginPasswordValidationState,
                  builder: (context, state) {
                    return const LoginPassword();
                  },
                ),
                const ForgetPasswordButton(),
                BlocConsumer<LoginCubit, LoginState>(
                  buildWhen: (previous, current) {
                    return current is ResetDialogState ||
                        current is LoginSuccessState ||
                        current is LoginErrorState ||
                        current is LoginLoadingState;
                  },
                  listenWhen: (previous, current) {
                    return current is ResetDialogState ||
                        current is LoginSuccessState ||
                        current is LoginErrorState;
                  },
                  listener: (context, state) {
                    if (state is LoginErrorState) {
                      defaultErrorSnackBar(
                        context: context,
                        message: state.errMsg,
                      );
                    } else if (state is LoginSuccessState) {
                      if (requestedCarId != null &&
                          (requestedCarId?.isNotEmpty ?? false)) {
                        Navigator.of(context).pushReplacementNamed(
                          Routes.signupScreen,
                          arguments: SignupScreenArguments(
                            carId: requestedCarId!,
                            dailyPrice: dailyPrice!,
                            weeklyPrice: weeklyPrice!,
                            monthlyPrice: monthlyPrice!,
                          ),
                        );
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.layoutScreen,
                          (route) => false,
                        );
                      }
                    } else if (state is ResetDialogState) {
                      showAdaptiveDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<LoginCubit>(),
                          child: BlocConsumer<LoginCubit, LoginState>(
                            listenWhen: (previous, current) {
                              return current is ResetCustomerErrorState ||
                                  current is ResetCustomerSuccessState;
                            },
                            listener: (context, state) {
                              if (state is ResetCustomerErrorState) {
                                defaultErrorSnackBar(
                                    context: context, message: state.errMsg);
                              } else if (state is ResetCustomerSuccessState) {
                                Navigator.of(dialogContext).pop();
                                defaultSuccessSnackBar(
                                    context: context, message: state.msg);
                              }
                            },
                            builder: (context, state) {
                              return DefaultDialog(
                                secondButtonColor: AppColors.darkRed,
                                onSecondButtonTapped: () {
                                  context.read<LoginCubit>().resetCustomer();
                                },
                                loading: state is ResetCustomerLoadingState,
                                title: "Restore Your Account",
                                secondButtonText: "Restore",
                                subTitle:
                                    "Regain access to your account with a quick restoration process.",
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    var blocRead = context.read<LoginCubit>();
                    return DefaultButton(
                      loading: state is LoginLoadingState,
                      function: () {
                        blocRead.onLoginButtonClicked();
                      },
                      text: "login".getLocale(context: context),
                      marginTop: 24,
                      marginLeft: 20,
                      marginRight: 20,
                      marginBottom: 15,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  child: AuthRichText(
                    text: "dontHaveAccount".getLocale(context: context),
                    buttonText: "signUp".getLocale(context: context),
                    onTap: () {
                      if (requestedCarId != null) {
                        Navigator.of(context).pushReplacementNamed(
                          Routes.signupScreen,
                          arguments: SignupScreenArguments(
                            carId: requestedCarId!,
                            dailyPrice: dailyPrice!,
                            weeklyPrice: weeklyPrice!,
                            monthlyPrice: monthlyPrice!,
                          ),
                        );
                      } else {
                        Navigator.of(context).pushReplacementNamed(
                          Routes.signupScreen,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginEmail extends StatelessWidget {
  const LoginEmail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldWithHeader(
      header: "Email",
      hintText: "Enter your Email",
      isWithValidation: true,
      textInputType: TextInputType.emailAddress,
      validationText: "Invalid Email Address.",
      textEditingController: context.read<LoginCubit>().emailController,
      validation: context.watch<LoginCubit>().emailValidation,
      onChange: (value) {
        if (value.isEmpty ||
            context.read<LoginCubit>().emailValidation !=
                TextFieldValidation.normal) {
          context.read<LoginCubit>().checkEmailValidationState();
        }
      },
      onSubmit: (value) {
        context.read<LoginCubit>().checkEmailValidationState();
      },
    );
  }
}
