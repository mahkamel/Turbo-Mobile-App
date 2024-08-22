import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

class Confirmpassword extends StatelessWidget {
  const Confirmpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldWithHeader(
      onTap: () {},
      header: "Confirm Password",
      isRequiredFiled: true,
      hintText: "Re-Enter Password",
      isPassword: true,
      isWithValidation: true,
      textInputType: TextInputType.text,
      validationText: "Passwords do not match.",
      textInputAction: TextInputAction.next,
      textEditingController: context.read<LoginCubit>().confirmPasswordController,
      validation: context.watch<LoginCubit>().confirmPasswordValidation,
      onChange: (value) {
        if (value.isEmpty ||
          context.read<LoginCubit>().confirmPasswordValidation != TextFieldValidation.normal) {
          context.read<LoginCubit>().checkConfirmPasswordValidation();
        }
      },
      onSubmit: (value) {
        context.read<LoginCubit>().checkConfirmPasswordValidation();
      },
      onTapOutside: () {
        context.read<LoginCubit>().checkConfirmPasswordValidation();
      },
    );
  }
}
