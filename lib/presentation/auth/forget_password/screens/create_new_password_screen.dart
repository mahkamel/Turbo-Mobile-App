import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';
import 'package:turbo/main_paths.dart';
import 'package:turbo/presentation/auth/forget_password/widgets/confirmPassword.dart';
import 'package:turbo/presentation/auth/forget_password/widgets/password.dart';

class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({super.key});

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
              header: "Create New Password",
              onBackPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    Routes.forgetPasswordScreen,
                    arguments: context.read<LoginCubit>());
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "createNewPasswordBody".getLocale(context: context),
                style: AppFonts.ibm16SubTextGrey400,
              ),
            ),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) =>
                  current is CheckLoginPasswordValidationState,
              builder: (context, state) {
                return const Password();
              },
            ),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) =>
                  current is CheckConfirmPasswordValidationState,
              builder: (context, state) {
                return const Confirmpassword();
              },
            ),
            const Spacer(),
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                 if(state is ChangePasswordErrorState) {
                   defaultErrorSnackBar(
                      context: context,
                      message: state.errMsg,
                    );
                } else if(state is ChangePasswordSuccessState) {
                     Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                return DefaultButton(
                  function: () {
                     context.read<LoginCubit>().changePassword();
                  },
                  text: "Reset Password",
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
