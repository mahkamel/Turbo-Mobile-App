import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext, WatchContext;
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/login/login_cubit.dart';
import '../../../../core/helpers/enums.dart';
import '../../../../core/widgets/text_field_with_header.dart';

class LoginPassword extends StatelessWidget {
  const LoginPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<LoginCubit>();
    return AuthTextFieldWithHeader(
      header: "password".getLocale(context: context),
      hintText: "enterPassword".getLocale(context: context),
      isPassword: true,
      isWithValidation: true,
      textInputType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textEditingController: blocRead.passwordController,
      validation: context.watch<LoginCubit>().passwordValidation,
      onChange: (value) {
        if (value.isEmpty ||
            blocRead.passwordValidation != TextFieldValidation.normal) {
          blocRead.checkPasswordValidation();
        }
      },
      onSubmit: (value) {
        blocRead.checkPasswordValidation();
      },
      onTapOutside: () {
        blocRead.checkPasswordValidation();
      },
    );
  }
}
