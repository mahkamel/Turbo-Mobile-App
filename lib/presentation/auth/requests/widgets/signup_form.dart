import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/auth/requests/widgets/select_phone_number.dart';

import '../../../../blocs/signup/signup_cubit.dart';
import '../../../../core/helpers/enums.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/text_field_with_header.dart';
import '../../../../core/widgets/widget_with_header.dart';

class InfoStepForm extends StatelessWidget {
  const InfoStepForm({
    super.key,
    required this.clientTypeKey,
  });
  final GlobalKey<CustomDropdownState> clientTypeKey;
  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<SignupCubit>();
    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: () {
          if (clientTypeKey.currentState != null) {
            if (clientTypeKey.currentState!.isOpen) {
              clientTypeKey.currentState!.closeBottomSheet();
            }
          }
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            BlocBuilder<SignupCubit, SignupState>(
              buildWhen: (previous, current) =>
                  current is CheckNameValidationState,
              builder: (context, state) {
                return AuthTextFieldWithHeader(
                  onTap: () {
                    if (clientTypeKey.currentState != null) {
                      if (clientTypeKey.currentState!.isOpen) {
                        clientTypeKey.currentState!.closeBottomSheet();
                      }
                    }
                  },
                  header: "Name",
                  hintText: "Enter Name",
                  isWithValidation: true,
                  textInputType: TextInputType.name,
                  validationText: "Invalid Name.",
                  textEditingController: blocRead.customerNameController,
                  validation:
                      context.watch<SignupCubit>().customerNameValidation,
                  onTapOutside: () {
                    blocRead.checkUserNameValidation();
                  },
                  onChange: (value) {
                    if (value.isEmpty ||
                        blocRead.customerNameValidation !=
                            TextFieldValidation.normal) {
                      blocRead.checkUserNameValidation();
                    }
                  },
                  onSubmit: (value) {
                    blocRead.checkUserNameValidation();
                  },
                );
              },
            ),
            const SizedBox(
              height: 18,
            ),
            BlocBuilder<SignupCubit, SignupState>(
              buildWhen: (previous, current) =>
                  current is CheckEmailValidationState,
              builder: (context, state) {
                return AuthTextFieldWithHeader(
                  header: "Email",
                  hintText: "Enter Email",
                  isWithValidation: true,
                  textInputType: TextInputType.emailAddress,
                  validationText: "Invalid Email Address.",
                  textEditingController: blocRead.customerEmailController,
                  validation:
                      context.watch<SignupCubit>().customerEmailValidation,
                  onTapOutside: () {
                    blocRead.checkEmailValidationState();
                  },
                  onChange: (value) {
                    if (value.isEmpty ||
                        blocRead.customerEmailValidation !=
                            TextFieldValidation.normal) {
                      blocRead.checkEmailValidationState();
                    }
                  },
                  onSubmit: (value) {
                    blocRead.checkEmailValidationState();
                  },
                );
              },
            ),
            const SizedBox(
              height: 18,
            ),
            BlocBuilder<SignupCubit, SignupState>(
              buildWhen: (previous, current) =>
                  current is CheckEmailValidationState,
              builder: (context, state) {
                return AuthTextFieldWithHeader(
                  onTap: () {
                    if (clientTypeKey.currentState != null) {
                      if (clientTypeKey.currentState!.isOpen) {
                        clientTypeKey.currentState!.closeBottomSheet();
                      }
                    }
                  },
                  header: "Address",
                  hintText: "Enter Address",
                  isWithValidation: true,
                  textInputType: TextInputType.emailAddress,
                  validationText: "Invalid Address Address.",
                  textEditingController: blocRead.customerAddressController,
                  validation:
                      context.watch<SignupCubit>().customerAddressValidation,
                  onTapOutside: () {
                    blocRead.checkAddressValidation();
                  },
                  onChange: (value) {
                    if (value.isEmpty ||
                        blocRead.customerAddressValidation !=
                            TextFieldValidation.normal) {
                      blocRead.checkAddressValidation();
                    }
                  },
                  onSubmit: (value) {
                    blocRead.checkAddressValidation();
                  },
                );
              },
            ),
            ChoosePhoneNumber(
              clientTypeKey: clientTypeKey,
            ),
            BlocBuilder<SignupCubit, SignupState>(
              buildWhen: (previous, current) =>
                  current is CheckEmailValidationState,
              builder: (context, state) {
                var blocWatch = context.watch<SignupCubit>();
                return WidgetWithHeader(
                  header: "Are You a Saudi Arabian Citizen?",
                  widget: CustomDropdown<int>(
                    onTap: () {},
                    border: Border.all(
                      color: AppColors.black.withOpacity(0.5),
                    ),
                    paddingLeft: 0,
                    key: clientTypeKey,
                    paddingRight: 0,
                    index: blocWatch.saCitizenSelectedIndex,
                    showText: false,
                    listOfValues: const [
                      "Saudi Citizen",
                      "Non-Saudi Resident",
                    ],
                    text: "Select City",
                    isCheckedBox: false,
                    onChange: (_, int index) {
                      blocRead.changeSACitizenIndexValue(index);
                    },
                    items: [
                      "Saudi Citizen",
                      "Non-Saudi Resident",
                    ]
                        .map((element) => element)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (item) => CustomDropdownItem(
                            key: UniqueKey(),
                            value: item.key,
                            child: Text(
                              item.value,
                              style: AppFonts.inter15Black400,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 14,
                  top: 16,
                  bottom: 8,
                ),
                child: Text(
                  "Please set your password to use when login",
                  style: AppFonts.inter14Black400,
                ),
              ),
            ),
            BlocBuilder<SignupCubit, SignupState>(
              buildWhen: (previous, current) =>
                  current is CheckPasswordValidationState,
              builder: (context, state) {
                return AuthTextFieldWithHeader(
                  onTap: () {
                    if (clientTypeKey.currentState != null) {
                      if (clientTypeKey.currentState!.isOpen) {
                        clientTypeKey.currentState!.closeBottomSheet();
                      }
                    }
                  },
                  header: "Password",
                  hintText: "Enter Password",
                  isPassword: true,
                  isWithValidation: true,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validationText:
                      "Password must be 6+ characters long and include at least 1 special character.",
                  textEditingController: blocRead.passwordController,
                  validation: context.watch<SignupCubit>().passwordValidation,
                  onChange: (value) {
                    if (value.isEmpty ||
                        blocRead.confirmPasswordValidation !=
                            TextFieldValidation.normal) {
                      blocRead.checkPasswordValidation();
                    }
                  },
                  onSubmit: (value) {
                    blocRead.checkPasswordValidation();
                  },
                  onTapOutside: () {
                    blocRead.checkPasswordValidation();
                  },
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            BlocBuilder<SignupCubit, SignupState>(
              buildWhen: (previous, current) =>
                  current is CheckConfirmPasswordValidationState,
              builder: (context, state) {
                return AuthTextFieldWithHeader(
                  onTap: () {
                    if (clientTypeKey.currentState != null) {
                      if (clientTypeKey.currentState!.isOpen) {
                        clientTypeKey.currentState!.closeBottomSheet();
                      }
                    }
                  },
                  header: "Confirm Password",
                  hintText: "Re-Enter Password",
                  isPassword: true,
                  isWithValidation: true,
                  textInputType: TextInputType.text,
                  validationText: "Passwords do not match.",
                  textInputAction: TextInputAction.done,
                  textEditingController: blocRead.confirmPasswordController,
                  validation:
                      context.watch<SignupCubit>().confirmPasswordValidation,
                  onChange: (value) {
                    if (value.isEmpty ||
                        blocRead.confirmPasswordValidation !=
                            TextFieldValidation.normal) {
                      blocRead.checkPasswordValidation();
                    }
                  },
                  onSubmit: (value) {
                    blocRead.checkPasswordValidation();
                  },
                  onTapOutside: () {
                    blocRead.checkPasswordValidation();
                  },
                );
              },
            ),
            BlocConsumer<SignupCubit, SignupState>(
              listenWhen: (previous, current) =>
                  current is SubmitCustomerInfoSuccessState ||
                  current is SubmitCustomerInfoErrorState,
              listener: (context, state) {
                if (state is SubmitCustomerInfoSuccessState) {
                  blocRead.changeStepIndicator(1);
                } else if (state is SubmitCustomerInfoErrorState) {
                  defaultErrorSnackBar(context: context, message: state.errMsg);
                }
              },
              buildWhen: (previous, current) =>
                  current is SubmitCustomerInfoLoadingState ||
                  current is SubmitCustomerInfoSuccessState ||
                  current is SubmitCustomerInfoErrorState,
              builder: (context, state) {
                return DefaultButton(
                  loading: state is SubmitCustomerInfoLoadingState,
                  marginRight: 16,
                  marginLeft: 16,
                  marginTop: 24,
                  marginBottom: 24,
                  text: "Submit",
                  function: () {
                    blocRead.submitCustomerInfo();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
