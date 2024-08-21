import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';
import 'package:turbo/main_paths.dart';
import 'package:turbo/presentation/auth/login_screen/login_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            AuthTextFieldWithHeader(
              header: "Email",
              hintText: "Enter Email Address",
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
              widgetPadding: const EdgeInsetsDirectional.symmetric(vertical: 25, horizontal: 16),
            ),
            const Spacer(),
            DefaultButton(
                function: () {
                },
                text: "Continue",
                marginRight: 16,
                marginLeft: 16,
                marginBottom: 30,
              )
          ],
        ),
      )),
    );
  }
}
