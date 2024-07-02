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
import 'package:turbo/presentation/auth/login_screen/widgets/login_phone_number.dart';

import '../../../core/routing/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    required this.requestedCarId,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
  });
  final String requestedCarId;
  final num dailyPrice;
  final num weeklyPrice;
  final num monthlyPrice;

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<LoginCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: AppConstants.screenHeight(context),
          width: AppConstants.screenWidth(context),
          child: Column(
            children: [
              DefaultHeader(
                header: "login".getLocale(),
                textAlignment: AlignmentDirectional.center,
              ),
              LoginPhoneNumber(blocRead: blocRead),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (previous, current) =>
                    current is CheckLoginPasswordValidationState,
                builder: (context, state) {
                  return LoginPassword(blocRead: blocRead);
                },
              ),
              const ForgetPasswordButton(),
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginErrorState) {
                    defaultErrorSnackBar(
                      context: context,
                      message: state.errMsg,
                    );
                  }
                },
                builder: (context, state) {
                  return DefaultButton(
                    loading: state is LoginLoadingState,
                    function: () {
                      blocRead.onLoginPressed();
                    },
                    text: "login".getLocale(),
                    marginTop: 24,
                    marginLeft: 20,
                    marginRight: 20,
                    marginBottom: 18,
                  );
                },
              ),
              AuthRichText(
                text: "dontHaveAccount".getLocale(),
                buttonText: "signUp".getLocale(),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    Routes.signupScreen,
                    arguments: SignupScreenArguments(
                      carId: requestedCarId,
                      isFromLogin: true,
                      dailyPrice: dailyPrice,
                      weeklyPrice: weeklyPrice,
                      monthlyPrice: monthlyPrice,
                    ),
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
