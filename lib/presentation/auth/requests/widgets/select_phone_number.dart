import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';

import '../../../../core/helpers/dropdown_keys.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class ChoosePhoneNumber extends StatelessWidget {
  const ChoosePhoneNumber({
    super.key,
  });
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
        padding: const EdgeInsets.only(
          top: 18,
          left: 20.0,
          right: 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: "Phone Number",
                  style: AppFonts.ibm15LightBlack600,
                  children: [
                    TextSpan(
                      text: "*",
                      style: AppFonts.ibm15LightBlack600
                    ),
                  ]),
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 76,
              child: InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  if (clientTypeKey.currentState != null) {
                    if (clientTypeKey.currentState!.isOpen) {
                      clientTypeKey.currentState!.closeBottomSheet();
                    }
                  }
                },
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
                    labelStyle: AppFonts.ibm14LightBlack400,
                    hintText: "Enter your phone number",
                    hintStyle: AppFonts.ibm15subTextGrey400,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppColors.black.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
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
                    dialCode: blocRead.dialCode.isNotEmpty
                        ? blocRead.dialCode
                        : "+966",
                    isoCode: blocRead.countryIsoCode.isNotEmpty
                        ? blocRead.countryIsoCode
                        : "SA",
                    phoneNumber: blocRead.phoneNumber.isNotEmpty
                        ? blocRead.phoneNumber
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
