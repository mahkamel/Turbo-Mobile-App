import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/main_paths.dart';
import 'package:turbo/presentation/auth/forget_password/widgets/email.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

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
              header: "Reset Password",
              onBackPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "forgetPasswordBody".getLocale(context: context),
                style: AppFonts.ibm16SubTextGrey400,
              ),
            ),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) =>
                  current is CheckLoginEmailValidationState,
              builder: (context, state) {
                return const Email();
              },
            ),
            const Spacer(),
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if(state is ForgetPasswordErrorState) {
                   defaultErrorSnackBar(
                      context: context,
                      message: state.errMsg,
                    );
                } else if(state is ForgetPasswordSuccessState) {
                    Navigator.of(context).pushReplacementNamed(
                    Routes.otpForgetPasswordScreen,
                    arguments: context.read<LoginCubit>());
                }
              },
              builder: (context, state) {
                var blocRead = context.read<LoginCubit>();
                return DefaultButton(
                  function: () {
                    blocRead.forgetPassword();
                  },
                  loading: state is ForgetPasswordLoadingState,
                  text: "Continue",
                  marginRight: 16,
                  marginLeft: 16,
                  marginBottom: 30,
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
