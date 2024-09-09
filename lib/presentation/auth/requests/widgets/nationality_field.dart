import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/signup/signup_cubit.dart';
import '../../../../core/helpers/dropdown_keys.dart';
import '../../../../core/helpers/enums.dart';
import '../../../../core/widgets/text_field_with_header.dart';

class Nationality extends StatelessWidget {
  const Nationality({super.key});

   @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => current is CheckNationalityValidationState,
      builder: (context, state) {
        var blocRead = context.read<SignupCubit>();

        return AuthTextFieldWithHeader(
          onTap: () {
            if (clientTypeKey.currentState != null) {
              if (clientTypeKey.currentState!.isOpen) {
                clientTypeKey.currentState!.closeBottomSheet();
              }
            }
          },
          widgetPadding: const EdgeInsetsDirectional.only(
            start: 18,
            end: 18,
            bottom: 18
          ),
          isRequiredFiled: true,
          header: "Nationality",
          hintText: "Enter Your Nationality",
          isWithValidation: true,
          textInputType: TextInputType.name,
          validationText: blocRead.customerNameController.text.isEmpty
              ? "Please Enter Nationality"
              : "Please Enter Valid Nationality.",
          textEditingController: blocRead.customerNationalityController,
          validation: context.watch<SignupCubit>().customerNationalityValidation,
          onTapOutside: () {
            blocRead.checkUserNationalityValidation();
          },
          onChange: (value) {
            if (value.isEmpty ||
                blocRead.customerNationalityValidation != TextFieldValidation.normal) {
              blocRead.checkUserNationalityValidation();
            }
          },
          onSubmit: (value) {
            blocRead.checkUserNationalityValidation();
          },
        );
      },
    );
  }
}