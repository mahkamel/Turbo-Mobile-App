import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

import '../../../../../core/services/networking/repositories/auth_repository.dart';

class ProfileAddress extends StatelessWidget {
  const ProfileAddress({super.key});

  @override
   @override
    Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is EditProfileSuccessState,
      builder: (context, state) {
        var blocRead = context.read<ProfileCubit>();
        var customerAddress = context.watch<AuthRepository>().customer.customerAddress;
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: AuthTextFieldWithHeader(
            suffixIcon: const Icon(Icons.edit, color: AppColors.gold,),
            onTap: () {},
            isRequiredFiled: false,
            header: "Address",
            hintText: customerAddress,
            isWithValidation: false,
            textInputType: TextInputType.name,
            textEditingController: blocRead.profileAddress,
            validation: TextFieldValidation.normal,
            onTapOutside: () {},
            onChange: (value) {},
            onSubmit: (value) {},
          ),
        );
      },
    );
  }
}