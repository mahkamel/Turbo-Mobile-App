import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/dropdown_keys.dart';
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
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(),
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {
            if (clientTypeKey.currentState != null) {
              if (clientTypeKey.currentState!.isOpen) {
                clientTypeKey.currentState!.closeBottomSheet();
              }
            }
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SignupNameField(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0),
                child: SignupEmailField(),
              ),
              SignupAddressField(),
              ChoosePhoneNumber(),
              SignupCitizenStatusDropdown(),
              PasswordSectionHeader(),
              SignupPasswordField(),
              SizedBox(
                height: 12,
              ),
              SignupConfirmPasswordField(),
              SignupSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordSectionHeader extends StatelessWidget {
  const PasswordSectionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class SignupSubmitButton extends StatelessWidget {
  const SignupSubmitButton({
    // required this.clientTypeKey,
    super.key,
  });
  // final GlobalKey<CustomDropdownState> clientTypeKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          current is OTPSentSuccessState ||
          current is OTPSentErrorState ||
          current is SubmitCustomerInfoErrorState,
      listener: (context, state) {
        var blocRead = context.read<SignupCubit>();

        if (state is OTPSentSuccessState) {
          blocRead.changeStepIndicator(1);
        } else if (state is SubmitCustomerInfoErrorState) {
          defaultErrorSnackBar(context: context, message: state.errMsg);
        } else if (state is OTPSentErrorState) {
          defaultErrorSnackBar(context: context, message: state.errMsg);
        }
      },
      buildWhen: (previous, current) =>
          current is SendOTPLoadingState ||
          current is OTPSentSuccessState ||
          current is OTPSentErrorState ||
          current is SubmitCustomerInfoErrorState ||
          current is SubmitCustomerInfoLoadingState,
      builder: (context, state) {
        var blocRead = context.read<SignupCubit>();

        return DefaultButton(
          loading: state is SubmitCustomerInfoLoadingState ||
              state is SendOTPLoadingState,
          marginRight: 16,
          marginLeft: 16,
          marginTop: 24,
          marginBottom: 24,
          text: "Submit",
          function: () {
            if (clientTypeKey.currentState != null) {
              if (clientTypeKey.currentState!.isOpen) {
                clientTypeKey.currentState!.closeBottomSheet();
              }
            }
            if (state is! SendOTPLoadingState) {
              blocRead.submitCustomerInfo();
            }
          },
        );
      },
    );
  }
}

class SignupConfirmPasswordField extends StatelessWidget {
  const SignupConfirmPasswordField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) =>
          current is CheckConfirmPasswordValidationState,
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
          header: "Confirm Password",
          isRequiredFiled: true,
          hintText: "Re-Enter Password",
          isPassword: true,
          isWithValidation: true,
          textInputType: TextInputType.text,
          validationText: "Passwords do not match.",
          textInputAction: TextInputAction.done,
          textEditingController: blocRead.confirmPasswordController,
          validation: context.watch<SignupCubit>().confirmPasswordValidation,
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
    );
  }
}

class SignupPasswordField extends StatelessWidget {
  const SignupPasswordField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => current is CheckPasswordValidationState,
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
          header: "Password",
          isRequiredFiled: true,
          hintText: blocRead.customerNameController.text.isEmpty
              ? "Please Enter Password"
              : "Please Enter Valid Password",
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
    );
  }
}

class SignupCitizenStatusDropdown extends StatelessWidget {
  const SignupCitizenStatusDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: const Key("SACitizenRepaint"),
      child: BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) => current is ChangeSACitizenIndexState,
        builder: (context, state) {
          var blocRead = context.read<SignupCubit>();

          var blocWatch = context.watch<SignupCubit>();
          return WidgetWithHeader(
            key: const Key("SACitizen"),
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
    );
  }
}

class SignupAddressField extends StatelessWidget {
  const SignupAddressField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => current is CheckAddressValidationState,
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
          header: "Address",
          hintText: blocRead.customerAddressController.text.isEmpty
              ? "Please Enter Address"
              : "Please Enter Valid Address",
          isRequiredFiled: true,
          isWithValidation: true,
          textInputType: TextInputType.text,
          validationText: "Please Enter Valid Address.",
          textEditingController: blocRead.customerAddressController,
          validation: context.watch<SignupCubit>().customerAddressValidation,
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
    );
  }
}

class SignupEmailField extends StatelessWidget {
  const SignupEmailField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => current is CheckEmailValidationState,
      builder: (context, state) {
        var blocRead = context.read<SignupCubit>();

        return AuthTextFieldWithHeader(
          header: "Email",
          isRequiredFiled: true,
          hintText: blocRead.customerNameController.text.isEmpty
              ? "Please Enter Email"
              : "Please Enter Valid Email.",
          isWithValidation: true,
          textInputType: TextInputType.emailAddress,
          validationText: "Please Enter Valid Email",
          textEditingController: blocRead.customerEmailController,
          validation: context.watch<SignupCubit>().customerEmailValidation,
          onTap: () {
            if (clientTypeKey.currentState != null) {
              if (clientTypeKey.currentState!.isOpen) {
                clientTypeKey.currentState!.closeBottomSheet();
              }
            }
          },
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
    );
  }
}

class SignupNameField extends StatelessWidget {
  const SignupNameField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => current is CheckNameValidationState,
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
          isRequiredFiled: true,
          header: "Name",
          hintText: "Enter Name",
          isWithValidation: true,
          textInputType: TextInputType.name,
          validationText: blocRead.customerNameController.text.isEmpty
              ? "Please Enter Name"
              : "Please Enter Valid Name.",
          textEditingController: blocRead.customerNameController,
          validation: context.watch<SignupCubit>().customerNameValidation,
          onTapOutside: () {
            blocRead.checkUserNameValidation();
          },
          onChange: (value) {
            if (value.isEmpty ||
                blocRead.customerNameValidation != TextFieldValidation.normal) {
              blocRead.checkUserNameValidation();
            }
          },
          onSubmit: (value) {
            blocRead.checkUserNameValidation();
          },
        );
      },
    );
  }
}
