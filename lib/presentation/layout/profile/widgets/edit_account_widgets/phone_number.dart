import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

class ProfilePhoneNumber extends StatelessWidget {
  const ProfilePhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
     var blocRead = context.read<ProfileCubit>();
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: AuthTextFieldWithHeader(
            header: "Phone Number",
            isRequiredFiled: false,
            hintText: "Please Enter Phone Number",
            isEnabled: false,
            isWithValidation: true,
            textInputType: TextInputType.phone,
            textEditingController: blocRead.profilePhoneNumber,
            validation: TextFieldValidation.normal,
            onChange: (value){},
            onSubmit: (value){},
          ),
        );
  }
}