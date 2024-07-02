import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/helpers/app_regex.dart';
import '../../core/helpers/enums.dart';
import '../../core/helpers/functions.dart';
import '../../core/services/networking/repositories/payment_repository.dart';
import '../../models/saved_card.dart';

part 'payment_state.dart';
part 'payment_cubit.freezed.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;
  PaymentCubit(this._paymentRepository) : super(const PaymentState.initial());

  int cardTypeToggle = 0;

  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardExpiryDate = TextEditingController();
  TextEditingController cardCVV = TextEditingController();

  TextFieldValidation cardHolderNameValidation = TextFieldValidation.normal;
  TextFieldValidation cardNumberValidation = TextFieldValidation.normal;
  TextFieldValidation cardExpiryDateValidation = TextFieldValidation.normal;
  TextFieldValidation cardCVVValidation = TextFieldValidation.normal;

  //Billing
  TextEditingController billingFirstNameCtrl = TextEditingController();
  TextEditingController billingLastNameCtrl = TextEditingController();
  TextEditingController billingCityCtrl = TextEditingController();
  TextEditingController billingAddressCtrl = TextEditingController();
  TextEditingController billingPostalCodeCtrl = TextEditingController();

  TextFieldValidation billingFirstNameValidation = TextFieldValidation.normal;
  TextFieldValidation billingLastNameValidation = TextFieldValidation.normal;
  TextFieldValidation billingCityValidation = TextFieldValidation.normal;
  TextFieldValidation billingAddressValidation = TextFieldValidation.normal;
  TextFieldValidation billingPostalCodeValidation = TextFieldValidation.normal;

  bool isSaveCardInfo = false;

  bool isSecondInvoiceSelected = true;
  bool isFirstTimeToUnCheckInvoice = true;

  String? selectedSavedCardId;

  void clearPaymentFormData() {
    cardHolderName.clear();
    cardNumber.clear();
    cardExpiryDate.clear();
    cardCVV.clear();

    cardHolderNameValidation = TextFieldValidation.normal;
    cardNumberValidation = TextFieldValidation.normal;
    cardExpiryDateValidation = TextFieldValidation.normal;
    cardCVVValidation = TextFieldValidation.normal;
  }

  void changeCardTypeToggleValue(int index) {
    cardTypeToggle = index;
    emit(PaymentState.changeCardTypeToggle(index));
    if (cardNumber.text.isNotEmpty) {
      checkCardNumberValidation();
    }
  }

  void checkCardHolderNameValidation() {
    if (cardHolderName.text.isNotEmpty) {
      cardHolderNameValidation = TextFieldValidation.valid;
    } else {
      cardHolderNameValidation = TextFieldValidation.notValid;
    }
    emit(PaymentState.checkCardHolderName(cardHolderNameValidation));
  }

  void checkCardNumberValidation() {
    if (cardNumber.text.isNotEmpty && cardNumber.text.contains("*")) {
      cardNumberValidation = TextFieldValidation.valid;
    } else if (cardNumber.text.isNotEmpty &&
        AppRegex.isValidCardNumber(
          cardNumber.text,
          cardTypeToggle == 0
              ? "visa"
              : cardTypeToggle == 1
                  ? "mastercard"
                  : "amex",
        )) {
      cardNumberValidation = TextFieldValidation.valid;
    } else {
      cardNumberValidation = TextFieldValidation.notValid;
    }
    emit(PaymentState.checkCardNumber(cardNumberValidation));
  }

  void checkExpiryDateValidation() {
    if (cardExpiryDate.text.isEmpty) {
      cardExpiryDateValidation = TextFieldValidation.notValid;
    } else {
      if (validateExpiryDate(cardExpiryDate.text)) {
        cardExpiryDateValidation = TextFieldValidation.valid;
      } else {
        cardExpiryDateValidation = TextFieldValidation.notValid;
      }
    }
    emit(PaymentState.checkExpiryDate(cardExpiryDateValidation));
  }

  void checkCVVValidation() {
    if (cardCVV.text.isNotEmpty && cardCVV.text.length == 3) {
      cardCVVValidation = TextFieldValidation.valid;
    } else {
      cardCVVValidation = TextFieldValidation.notValid;
    }
    emit(PaymentState.checkCVV(cardCVVValidation));
  }

  void changeSaveCardValue(bool value) {
    isSaveCardInfo = value;
    emit(PaymentState.changeSaveCreditCard(isSaveCardInfo));
  }

  void onSavedCardSelected(SavedCard card) {
    selectedSavedCardId = card.id;
    cardHolderName.text = card.visaCardName;
    cardNumber.text = "**** **** **** ${card.visaCardNumber}";
    cardExpiryDate.text =
        "${card.visaCardExpiryMonth}/${card.visaCardExpiryYear}";
    cardCVV.clear();
    cardCVVValidation = TextFieldValidation.normal;
    checkCardHolderNameValidation();
    checkCardNumberValidation();
    checkExpiryDateValidation();
    emit(PaymentState.selectedSavedCard(card.id));
  }

  void onRemoveSelectedCard() {
    selectedSavedCardId = null;
    clearPaymentFormData();
    emit(const PaymentState.selectedSavedCard(""));
  }

  void payCarRequest() async {
    // final res = await _paymentRepository.carRequestPayment();
  }
}
