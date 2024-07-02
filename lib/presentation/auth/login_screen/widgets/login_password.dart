import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/login/login_cubit.dart';
import '../../../../core/helpers/enums.dart';
import '../../../../core/widgets/text_field_with_header.dart';

class LoginPassword extends StatelessWidget {
  const LoginPassword({
    super.key,
    required this.blocRead,
  });

  final LoginCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldWithHeader(
      header: "password".getLocale(),
      hintText: "enterPassword".getLocale(),
      isPassword: true,
      isWithValidation: true,
      textInputType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textEditingController: TextEditingController(),
      validation: TextFieldValidation.valid,
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
