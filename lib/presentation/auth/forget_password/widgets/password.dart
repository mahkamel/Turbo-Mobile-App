import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 15),
      child: AuthTextFieldWithHeader(
        onTap: () {},
        header: "Password",
        isRequiredFiled: true,
        hintText: context.read<LoginCubit>().newPasswordController.text.isEmpty
              ? "Please Enter Password"
              : "Please Enter Valid Password",
        isPassword: true,
        isWithValidation: true,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validationText:
            "Password must be 6+ characters long and include at least 1 special character.",
        textEditingController: context.read<LoginCubit>().newPasswordController,
        validation: context.watch<LoginCubit>().newPasswordValidation,
        onChange: (value) {
          if (value.isEmpty ||
          context.read<LoginCubit>().newPasswordValidation != TextFieldValidation.normal) {
          context.read<LoginCubit>().checkNewPasswordValidation();
        }
        },
        onSubmit: (value) {
          context.read<LoginCubit>().checkNewPasswordValidation();
        },
        onTapOutside: () {
          context.read<LoginCubit>().checkNewPasswordValidation();
        },
      ),
    );
  }
}
