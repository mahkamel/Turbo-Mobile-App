import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/helpers/enums.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState.initial());

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

  void onLoginPressed() async {
    try {
      if (passwordController.text.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          phoneValidation == TextFieldValidation.valid) {
        emit(const LoginState.loginLoading());
        await Future.delayed(
          const Duration(seconds: 2),
          () {
            emit(const LoginState.loginSuccess());
          },
        );
      }
    } catch (e) {
      emit(LoginState.loginError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    return super.close();
  }
}
