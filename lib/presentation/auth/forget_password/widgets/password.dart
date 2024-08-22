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
        hintText: context.read<LoginCubit>().passwordController.text.isEmpty
              ? "Please Enter Password"
              : "Please Enter Valid Password",
        isPassword: true,
        isWithValidation: true,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validationText:
            "Password must be 6+ characters long and include at least 1 special character.",
        textEditingController: context.read<LoginCubit>().passwordController,
        validation: context.watch<LoginCubit>().passwordValidation,
        onChange: (value) {
          if (value.isEmpty ||
          context.read<LoginCubit>().passwordValidation != TextFieldValidation.normal) {
          context.read<LoginCubit>().checkPasswordValidation();
        }
        },
        onSubmit: (value) {
          context.read<LoginCubit>().checkPasswordValidation();
        },
        onTapOutside: () {
          context.read<LoginCubit>().checkPasswordValidation();
        },
      ),
    );
  }
}
