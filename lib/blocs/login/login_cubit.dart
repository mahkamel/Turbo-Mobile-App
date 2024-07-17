import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/services/networking/repositories/payment_repository.dart';

import '../../core/helpers/app_regex.dart';
import '../../core/helpers/enums.dart';
import '../../core/services/local/storage_service.dart';
import '../../core/services/local/token_service.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final PaymentRepository _paymentRepository;
  LoginCubit(this._authRepository, this._paymentRepository)
      : super(const LoginState.initial());

  TextEditingController emailController = TextEditingController();
  TextFieldValidation emailValidation = TextFieldValidation.normal;

  TextEditingController passwordController = TextEditingController();
  TextFieldValidation passwordValidation = TextFieldValidation.normal;

  String phoneNumber = "";
  String country = "";
  String countryIsoCode = "";
  String dialCode = "";
  TextFieldValidation phoneValidation = TextFieldValidation.normal;

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

  void checkEmailValidationState() {
    if ((emailController.text.isNotEmpty ||
            emailValidation == TextFieldValidation.notValid) &&
        AppRegex.isEmailValid(emailController.text)) {
      emailValidation = TextFieldValidation.valid;
      emit(
        LoginState.checkEmail(
          email: emailController.text,
          validation: emailValidation,
        ),
      );
    } else {
      emailValidation = TextFieldValidation.notValid;
      emit(
        LoginState.checkEmail(
          email: emailController.text,
          validation: emailValidation,
        ),
      );
    }
  }

  void checkPasswordValidation() {
    if (passwordController.text.isEmpty) {
      passwordValidation = TextFieldValidation.notValid;
    } else {
      passwordValidation = TextFieldValidation.valid;
    }
    emit(
      LoginState.checkLoginPassword(
        password: passwordController.text,
        validation: passwordValidation,
      ),
    );
  }

  void onLoginButtonClicked() async {
    checkEmailValidationState();
    checkPasswordValidation();
    if (emailValidation == TextFieldValidation.valid &&
        passwordValidation == TextFieldValidation.valid) {
      emit(const LoginState.loginLoading());
      try {
        final res = await _authRepository.customerLogin(
          email: emailController.text,
          password: passwordController.text,
        );
        res.fold((errMsg) {
          emit(LoginState.loginError(errMsg));
        }, (customer) async {
          _authRepository.customer = customer;
          UserTokenService.saveUserToken(customer.token);
          await _authRepository.setNotificationToken(AppConstants.fcmToken,customer.token);
          await _authRepository.getNotifications();
          await _paymentRepository.getSavedPaymentMethods();
          StorageService.saveData(
            "customerData",
            json.encode(customer.toJson()),
          );
          emit(
            const LoginState.loginSuccess(),
          );
        });
      } catch (e) {
        emit(LoginState.loginError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    return super.close();
  }
}
