import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

import '../../../../../core/services/networking/repositories/auth_repository.dart';

class ProfileName extends StatelessWidget {
  const ProfileName({super.key});

  @override
    Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is EditProfileSuccessState,
      builder: (context, state) {
        var blocRead = context.read<ProfileCubit>();
        var customerName = context.watch<AuthRepository>().customer.customerName;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: AuthTextFieldWithHeader(
            onTap: () {},
            suffixIcon: const Icon(Icons.edit, color: AppColors.gold,),
            isRequiredFiled: false,
            header: "Name",
            hintText: customerName,
            isWithValidation: false,
            textInputType: TextInputType.name,
            textEditingController: blocRead.profileName,
            validation: TextFieldValidation.normal,
            onTapOutside: () {
            },
            onChange: (value) {
            },
            onSubmit: (value) {
            },
          ),
        );
      },
    );
  }
}