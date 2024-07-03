part of 'payment_cubit.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;
  const factory PaymentState.changeSaveCreditCard(bool isCardSaved) =
  ChangeSaveCreditCardState;

  const factory PaymentState.checkCardHolderName(
      TextFieldValidation validation) = CheckCardHolderNameState;
  const factory PaymentState.checkCardNumber(
      TextFieldValidation validation) = CheckCardNumberState;
  const factory PaymentState.checkExpiryDate(
      TextFieldValidation validation) = CheckExpiryDateState;
  const factory PaymentState.checkCVV(TextFieldValidation validation) =
  CheckCVVState;

  const factory PaymentState.submitPaymentFormLoading() =
  SubmitPaymentFormLoadingState;
  const factory PaymentState.submitPaymentFormSuccess(
      final String requestId) = SubmitPaymentFormSuccessState;
  const factory PaymentState.submitPaymentFormError(String errMsg) =
  SubmitPaymentFormErrorState;

  const factory PaymentState.selectedSavedCard(String cardId) =
  SelectedSavedCardState;

  const factory PaymentState.changeCardTypeToggle(int index) =
  ChangeCardTypeToggleState;

  const factory PaymentState.checkBillingFirstName(TextFieldValidation validation) =
  CheckingBillingFirstNameValidation;

  const factory PaymentState.checkBillingLastName(TextFieldValidation validation) =
  CheckingBillingLastNameValidation;

  const factory PaymentState.checkBillingAddress(TextFieldValidation validation) =
  CheckingBillingAddressValidation;

  const factory PaymentState.checkBillingCity(TextFieldValidation validation) =
  CheckingBillingCityValidation;

  const factory PaymentState.checkBillingPostalCode(TextFieldValidation validation) =
  CheckingBillingPostalCodeValidation;



}
