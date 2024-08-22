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
  
  TextEditingController confirmPasswordController = TextEditingController();
  TextFieldValidation confirmPasswordValidation = TextFieldValidation.normal;
  
  String phoneNumber = "";
  String country = "";
  String countryIsoCode = "";
  String dialCode = "";
  String otpVerificationId = '';
  bool isEmailVerified = false;
  TextFieldValidation phoneValidation = TextFieldValidation.normal;
  
  List<TextEditingController> codeControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<FocusNode> codeFocusNode = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  void clearCodeControllers() {
    for (var controller in codeControllers) {
      controller.clear();
    }
  }

  bool _areAllControllersFilled(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

    void checkConfirmPasswordValidation() {
    if (confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text == passwordController.text) {
      confirmPasswordValidation = TextFieldValidation.valid;
      emit(
        LoginState.checkConfirmPassword(
          confirmPassword: confirmPasswordController.text,
          validation: confirmPasswordValidation,
        ),
      );
    } else {
      confirmPasswordValidation = TextFieldValidation.notValid;
      emit(
        LoginState.checkConfirmPassword(
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
    print("here");
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

  Future<bool> forgetPassword() async{
    bool isOtpSent = false;
    checkEmailValidationState();
    if(emailValidation == TextFieldValidation.valid) {
      emit(const LoginState.forgetPasswordLoading());
      try {
        await _authRepository.forgetPassword(email: emailController.text).then((value) {
          value.fold((err) {
            otpVerificationId = '';
            emit(LoginState.forgetPasswordFailed(errMsg: err));
          },(value) {
            clearCodeControllers();
            isOtpSent = true;
            otpVerificationId = value;
            emit(LoginState.forgetPasswordSuccessfully(otp: otpVerificationId));
          });
        }).catchError((e){
          otpVerificationId = '';
          emit(LoginState.forgetPasswordFailed(errMsg: e.toString()));
        });
      } catch (err) {
        emit(LoginState.forgetPasswordFailed(errMsg: err.toString()));
      }
    }
    return isOtpSent;
  }

  void checkOTP() {
    if (_areAllControllersFilled(codeControllers)) {
      verifyOTP();
    }
  }

  Future<void> verifyOTP() async {
    emit(const LoginState.checkOtpLoading());
    String otp = codeControllers[0].text +
        codeControllers[1].text +
        codeControllers[2].text +
        codeControllers[3].text +
        codeControllers[4].text +
        codeControllers[5].text;
    await _authRepository.checkOTP(
      email: emailController.text,
      otp: otp,
    ).then((value) {
      isEmailVerified = false;
      value.fold(
        (errMsg) => emit(
          const LoginState.checkOtpFailed(
            errMsg: "OTP is wrong, please try again!",
          ),
        ),
        (msg) {
        isEmailVerified = true;
          emit(
            LoginState.checkOtpSuccess(
              success: msg,
            ),
          );
        },
      );
    }).catchError((err) {
      isEmailVerified = false;
      emit(
        LoginState.checkOtpFailed(
          errMsg: err.toString(),
        ),
      );
    });
  }

  Future<void> changePassword() async {
    emit(const LoginState.changePasswordLoading());
    if(passwordValidation == TextFieldValidation.valid &&
        confirmPasswordValidation == TextFieldValidation.valid) {
      await _authRepository
          .changePassword(id: "123", newPassword: passwordController.text)
          .then((value) {
        value.fold((errMsg) {
          emit(LoginState.changePasswordFailed(errMsg: errMsg));
        }, (msg) {
          emit(LoginState.changePasswordSuccess(msg: msg));
        });
      }).catchError((err) {
        emit(LoginState.changePasswordFailed(errMsg: err.toString()));
      });
    }
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
