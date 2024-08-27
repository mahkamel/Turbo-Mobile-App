import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

class ProfileEmail extends StatelessWidget {
  const ProfileEmail({super.key});

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<ProfileCubit>();
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: AuthTextFieldWithHeader(
            header: "Email",
            isRequiredFiled: false,
            hintText: "Please Enter Email",
            isEnabled: false,
            isWithValidation: true,
            textInputType: TextInputType.emailAddress,
            textEditingController: blocRead.profileEmail,
            validation: TextFieldValidation.normal,
            onChange: (value){},
            onSubmit: (value){},
          ),
        );
  }
}