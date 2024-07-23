import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:turbo/blocs/localization/cubit/localization_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/login/login_cubit.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class LoginPhoneNumber extends StatelessWidget {
  const LoginPhoneNumber({
    super.key,
    required this.blocRead,
  });

  final LoginCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 18.0,
        end: 18.0,
        top: 38.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "phoneNumber".getLocale(),
            style: AppFonts.inter16Black500,
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
                  country: "", // TODO
                );
              },
              onInputValidated: (value) {
                blocRead.checkPhoneValidation(value);
              },
              locale:
                  context.read<LocalizationCubit>().state.locale.languageCode,
              inputDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                labelStyle: AppFonts.inter12Black400,
                hintText: "enterUrPhoneNumber".getLocale(),
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
    );
  }
}
