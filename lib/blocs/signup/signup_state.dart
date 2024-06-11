part of 'signup_cubit.dart';

@freezed
class SignupState with _$SignupState {
  const factory SignupState.initial() = _Initial;

  const factory SignupState.changeIndicatorStep({
    required int currentStep,
  }) = ChangeIndicatorStepState;

  const factory SignupState.changeSACitizenIndex({
    required int saCitizenIndex,
  }) = ChangeSACitizenIndexState;

  const factory SignupState.checkName({
    required String name,
    required TextFieldValidation validation,
  }) = CheckNameValidationState;

  const factory SignupState.checkMobileNumber({
    required String mobileNumber,
    required TextFieldValidation validation,
  }) = CheckMobileValidationState;

  const factory SignupState.checkEmail({
    required String email,
    required TextFieldValidation validation,
  }) = CheckEmailValidationState;
  const factory SignupState.checkAddress({
    required String address,
    required TextFieldValidation validation,
  }) = CheckAddressValidationState;

  const factory SignupState.checkPassword({
    required String password,
    required TextFieldValidation validation,
  }) = CheckPasswordValidationState;
  const factory SignupState.checkConfirmPassword({
    required String confirmPassword,
    required TextFieldValidation validation,
  }) = CheckConfirmPasswordValidationState;

  const factory SignupState.submitSignupLoading() = SubmitSignupLoadingState;
  const factory SignupState.submitSignupSuccess() = SubmitSignupSuccessState;
  const factory SignupState.submitSignupError(final String errMsg) =
      SubmitSignupErrorState;

  //send otp
  const factory SignupState.sendOTPLoading() = SendOTPLoadingState;
  const factory SignupState.otpSentSuccessfully({
    required String phoneNumber,
    required String verificationID,
    required bool isFromStepOne,
  }) = OTPSentSuccessState;
  const factory SignupState.otpSentFailed({
    required String errMsg,
  }) = OTPSentErrorState;

  const factory SignupState.timerState({
    required String remainingTime,
    required String phoneNumber,
  }) = TimerState;
  const factory SignupState.timerFinishedState({
    required String phoneNumber,
  }) = TimerFinishedState;

  //verify otp
  const factory SignupState.verifyOTPLoading() = VerifyOTPLoadingState;
  const factory SignupState.otpVerifySuccess({
    required String smsCode,
    required String verificationID,
  }) = OTPVerifySuccessState;
  const factory SignupState.otpVerifyFailed({
    required String errMsg,
  }) = OTPVerifyErrorState;

  const factory SignupState.submitCustomerInfoLoading() =
      SubmitCustomerInfoLoadingState;
  const factory SignupState.submitCustomerInfoSuccess() =
      SubmitCustomerInfoSuccessState;
  const factory SignupState.submitCustomerInfoFailed({
    required String errMsg,
  }) = SubmitCustomerInfoErrorState;
}
