part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;

  const factory LoginState.checkLoginPassword({
    required String password,
    required TextFieldValidation validation,
  }) = CheckLoginPasswordValidationState;

  const factory LoginState.checkConfirmPassword({
    required String confirmPassword,
    required TextFieldValidation validation,
  }) = CheckConfirmPasswordValidationState;

  const factory LoginState.checkEmail({
    required String email,
    required TextFieldValidation validation,
  }) = CheckLoginEmailValidationState;


  const factory LoginState.loginLoading() = LoginLoadingState;
  const factory LoginState.loginSuccess() = LoginSuccessState;
  const factory LoginState.loginError(final String errMsg) = LoginErrorState;

  const factory LoginState.forgetPasswordLoading() = ForgetPasswordLoadingState;
  const factory LoginState.forgetPasswordSuccessfully({
    required String otp,
  }) = ForgetPasswordSuccessState;
  const factory LoginState.forgetPasswordFailed({
    required String errMsg,
  }) = ForgetPasswordErrorState;

  const factory LoginState.checkOtpLoading() = CheckOtpLoadingState;
  const factory LoginState.checkOtpSuccess({
    required String success,
  }) = CheckOtpSuccessState;
  const factory LoginState.checkOtpFailed({
    required String errMsg,
  }) = CheckOtpErrorState;

    const factory LoginState.changePasswordLoading() = ChangePasswordLoadingState;
  const factory LoginState.changePasswordSuccess({
    required String msg,
  }) = ChangePasswordSuccessState;
  const factory LoginState.changePasswordFailed({
    required String errMsg,
  }) = ChangePasswordErrorState;
}
