import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/custom_dropdown.dart';

class ChoosePhoneNumber extends StatelessWidget {
  const ChoosePhoneNumber({
    super.key,
    required this.clientTypeKey,
  });
  final GlobalKey<CustomDropdownState> clientTypeKey;
  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<SignupCubit>();
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        if (clientTypeKey.currentState != null) {
          if (clientTypeKey.currentState!.isOpen) {
            clientTypeKey.currentState!.closeBottomSheet();
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 18.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Phone Number",
              style: AppFonts.inter16Black400,
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 76,
              child: InternationalPhoneNumberInput(
                spaceBetweenSelectorAndTextField: 0,
                onInputChanged: (value) {
                  blocRead.onPhoneNumberChange(
                    phoneNumber: value.phoneNumber ?? "",
                    dialCode: value.dialCode ?? "",
                    isoCode: value.isoCode,
                    country: value.countryName ?? "",
                  );
                },
                onInputValidated: (value) {
                  blocRead.checkPhoneValidation(value);
                },
                inputDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  labelStyle: AppFonts.inter12Black400,
                  hintText: "Enter your phone number",
                  hintStyle: AppFonts.inter12Black400,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: AppColors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: AppColors.black,
                    ),
                  ),
                ),
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  useBottomSheetSafeArea: true,
                ),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                initialValue: PhoneNumber(
                  dialCode: "+966",
                  isoCode: "SA",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
