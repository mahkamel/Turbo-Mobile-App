import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

class ProfileName extends StatelessWidget {
  const ProfileName({super.key});

  @override
    Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is CheckProfileNameValidationState,
      builder: (context, state) {
        var blocRead = context.read<ProfileCubit>();
        // blocRead.profileName.text = context.read<AuthRepository>().customer.customerName;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: AuthTextFieldWithHeader(
            onTap: () {},
            suffixIcon: const Icon(Icons.edit, color: AppColors.gold,),
            isRequiredFiled: false,
            header: "Name",
            hintText: "Enter Name",
            isWithValidation: true,
            textInputType: TextInputType.name,
            validationText: blocRead.profileName.text.isEmpty
                ? "Please Enter Name"
                : "Please Enter Valid Name.",
            textEditingController: blocRead.profileName,
            validation: context.watch<ProfileCubit>().profileNameValidation,
            onTapOutside: () {
              blocRead.checkProfileNameValidation();
            },
            onChange: (value) {
              if (value.isEmpty ||
                  blocRead.profileNameValidation != TextFieldValidation.normal) {
                blocRead.checkProfileNameValidation();
              }
            },
            onSubmit: (value) {
              blocRead.checkProfileNameValidation();
            },
          ),
        );
      },
    );
  }
}