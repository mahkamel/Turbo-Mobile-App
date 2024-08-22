import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/login/login_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

class Email extends StatelessWidget {
  const Email({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldWithHeader(
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
      widgetPadding:
          const EdgeInsetsDirectional.symmetric(vertical: 25, horizontal: 16),
    );
  }
}
