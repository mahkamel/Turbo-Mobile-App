import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';

import '../../../../../core/helpers/enums.dart';
import '../../../../../core/widgets/text_field_with_header.dart';

class ProfileNationalId extends StatelessWidget {
  const ProfileNationalId({super.key});

  @override
  Widget build(BuildContext context) {
     var blocRead = context.read<ProfileCubit>();
        return AuthTextFieldWithHeader(
          header: "National ID",
          isRequiredFiled: false,
          hintText: "Please Enter National ID",
          isEnabled: false,
          isWithValidation: true,
          textInputType: TextInputType.number,
          textEditingController: blocRead.profileNationalIdNumber,
          validation: TextFieldValidation.normal,
          onChange: (value){},
          onSubmit: (value){},
        );
  }
}