import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';

import '../../core/helpers/app_regex.dart';
import '../../core/helpers/enums.dart';

part 'signup_state.dart';
part 'signup_cubit.freezed.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(const SignupState.initial());

  int currentStep = 0;

  TextEditingController customerNameController = TextEditingController();
  TextFieldValidation customerNameValidation = TextFieldValidation.normal;

  TextEditingController customerEmailController = TextEditingController();
  TextFieldValidation customerEmailValidation = TextFieldValidation.normal;

  TextEditingController customerAddressController = TextEditingController();
  TextFieldValidation customerAddressValidation = TextFieldValidation.normal;

  String phoneNumber = "";
  String country = "";
  String countryIsoCode = "";
  String dialCode = "";
  TextFieldValidation phoneValidation = TextFieldValidation.normal;

  TextEditingController passwordController = TextEditingController();
  TextFieldValidation passwordValidation = TextFieldValidation.normal;

  TextEditingController confirmPasswordController = TextEditingController();
  TextFieldValidation confirmPasswordValidation = TextFieldValidation.normal;

  int saCitizenSelectedIndex = 0;

  void changeStepIndicator(int index) {
    currentStep = index;
    emit(SignupState.changeIndicatorStep(currentStep: currentStep));
  }

  void changeSACitizenIndexValue(int index) {
    saCitizenSelectedIndex = index;
    emit(SignupState.changeSACitizenIndex(
        saCitizenIndex: saCitizenSelectedIndex));
  }

  void checkUserNameValidation() {
    if (customerNameController.text.isNotEmpty) {
      customerNameValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkName(
          name: customerNameController.text,
          validation: customerNameValidation,
        ),
      );
    } else {
      customerNameValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkName(
          name: customerNameController.text,
          validation: customerNameValidation,
        ),
      );
    }
  }

  void checkEmailValidationState() {
    if ((customerEmailController.text.isNotEmpty ||
            customerEmailValidation == TextFieldValidation.notValid) &&
        AppRegex.isEmailValid(customerEmailController.text)) {
      customerEmailValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkEmail(
          email: customerEmailController.text,
          validation: customerEmailValidation,
        ),
      );
    } else {
      customerEmailValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkEmail(
          email: customerEmailController.text,
          validation: customerEmailValidation,
        ),
      );
    }
  }

  void checkAddressValidation() {
    if (customerAddressController.text.isNotEmpty) {
      customerAddressValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkAddress(
          address: customerAddressController.text,
          validation: customerAddressValidation,
        ),
      );
    } else {
      customerAddressValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkAddress(
          address: customerAddressController.text,
          validation: customerAddressValidation,
        ),
      );
    }
  }

  void checkPasswordValidation() {
    if (passwordController.text.isNotEmpty &&
        passwordController.text.length >= 6 &&
        AppRegex.hasSpecialCharacter(passwordController.text)) {
      passwordValidation = TextFieldValidation.valid;
      if (confirmPasswordController.text.isNotEmpty) {
        checkConfirmPasswordValidation();
      }
      emit(
        SignupState.checkPassword(
          password: passwordController.text,
          validation: passwordValidation,
        ),
      );
    } else {
      passwordValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkPassword(
          password: passwordController.text,
          validation: passwordValidation,
        ),
      );
    }
  }

  void checkConfirmPasswordValidation() {
    if (confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text == passwordController.text) {
      confirmPasswordValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkConfirmPassword(
          confirmPassword: confirmPasswordController.text,
          validation: confirmPasswordValidation,
        ),
      );
    } else {
      confirmPasswordValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkConfirmPassword(
          confirmPassword: confirmPasswordController.text,
          validation: confirmPasswordValidation,
        ),
      );
    }
  }

  void onPhoneNumberChange({
    required String phoneNumber,
    required String dialCode,
    required String country,
    required isoCode,
  }) {
    this.phoneNumber = phoneNumber;
    this.country = country;
    this.dialCode = dialCode;
    countryIsoCode = isoCode;
  }

  void checkPhoneValidation(bool isValid) {
    if (isValid) {
      phoneValidation = TextFieldValidation.valid;
    } else {
      phoneValidation = TextFieldValidation.notValid;
    }
  }

  void submitCustomerInfo() async {
    checkUserNameValidation();
    checkEmailValidationState();
    checkAddressValidation();
    checkPasswordValidation();
    checkConfirmPasswordValidation();
    if (isFieldValid(customerNameController, customerNameValidation) &&
        isFieldValid(customerEmailController, customerEmailValidation) &&
        isFieldValid(customerAddressController, customerAddressValidation) &&
        isFieldValid(confirmPasswordController, confirmPasswordValidation) &&
        isFieldValid(passwordController, passwordValidation) &&
        phoneNumber.isNotEmpty &&
        phoneValidation == TextFieldValidation.valid) {
      emit(const SignupState.submitCustomerInfoLoading());
      await Future.delayed(const Duration(seconds: 1));
      final res = await _authRepository.signupInfoStep(
        customerName: customerNameController.text,
        customerEmail: customerEmailController.text,
        customerAddress: customerAddressController.text,
        customerTelephone: phoneNumber,
        customerPassword: passwordController.text,
        customerCountry: country,
        customerCountryCode: countryIsoCode,
        customerType: saCitizenSelectedIndex,
      );
      res.fold(
        (errMsg) => emit(SignupState.submitCustomerInfoFailed(errMsg: errMsg)),
        (_) {
          emit(const SignupState.submitCustomerInfoSuccess());
        },
      );
    } else {
      emit(const SignupState.submitCustomerInfoFailed(
          errMsg: "Please complete all required fields"));
    }
  }

  bool isFieldValid(
    TextEditingController controller,
    TextFieldValidation validation,
  ) {
    if (controller.text.isNotEmpty && validation == TextFieldValidation.valid) {
      return true;
    } else {
      return false;
    }
  }
}
