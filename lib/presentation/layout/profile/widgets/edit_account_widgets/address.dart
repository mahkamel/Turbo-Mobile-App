import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:turbo/core/widgets/text_field_with_header.dart';

class ProfileAddress extends StatelessWidget {
  const ProfileAddress({super.key});

  @override
   @override
    Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is CheckProfileAddressValidationState,
      builder: (context, state) {
        var blocRead = context.read<ProfileCubit>();
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: AuthTextFieldWithHeader(
            suffixIcon: const Icon(Icons.edit, color: AppColors.gold,),
            onTap: () {},
            isRequiredFiled: false,
            header: "Address",
            hintText: "Enter Address",
            isWithValidation: true,
            textInputType: TextInputType.name,
            validationText: blocRead.profileAddress.text.isEmpty
                ? "Please Enter Address"
                : "Please Enter Valid Address.",
            textEditingController: blocRead.profileAddress,
            validation: context.watch<ProfileCubit>().profileAddressValidation,
            onTapOutside: () {
              blocRead.checkProfileAddressValidation();
            },
            onChange: (value) {
              if (value.isEmpty ||
                  blocRead.profileAddressValidation != TextFieldValidation.normal) {
                blocRead.checkProfileAddressValidation();
              }
            },
            onSubmit: (value) {
              blocRead.checkProfileAddressValidation();
            },
          ),
        );
      },
    );
  }
}