import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';

import '../../core/helpers/app_regex.dart';
import '../../core/helpers/enums.dart';
import '../../core/helpers/functions.dart';
import '../../core/services/networking/repositories/payment_repository.dart';
import '../../models/saved_card.dart';

part 'payment_state.dart';
part 'payment_cubit.freezed.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;
  final AuthRepository _authRepository;
  PaymentCubit(
    this._paymentRepository,
    this._authRepository,
  ) : super(const PaymentState.initial());

  int selectedCardToggleIndex = 0;

  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardExpiryDate = TextEditingController();
  TextEditingController cardCVV = TextEditingController();

  TextFieldValidation cardHolderNameValidation = TextFieldValidation.normal;
  TextFieldValidation cardNumberValidation = TextFieldValidation.normal;
  TextFieldValidation cardExpiryDateValidation = TextFieldValidation.normal;
  TextFieldValidation cardCVVValidation = TextFieldValidation.normal;

  TextEditingController billingPostalCodeCtrl = TextEditingController();

  TextFieldValidation billingAddressValidation = TextFieldValidation.normal;
  TextFieldValidation billingPostalCodeValidation = TextFieldValidation.normal;

  bool isSaveCardInfo = false;

  bool isSecondInvoiceSelected = true;
  bool isFirstTimeToUnCheckInvoice = true;

  String? selectedSavedCardId;
  SavedCard? selectedCard;

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

  void init() {
    if (_paymentRepository.defaultCard != null) {
      onSavedCardSelected(_paymentRepository.defaultCard!);
    } else if (_paymentRepository.savedPaymentCards.isNotEmpty) {
      onSavedCardSelected(_paymentRepository.savedPaymentCards.first);
    }
  }

  void changeCardTypeToggleValue(int index) {
    if (selectedCardToggleIndex != index) {
      clearPaymentFormData();
    }
    selectedCardToggleIndex = index;
    emit(PaymentState.changeCardTypeToggle(index));
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
    } else if (cardNumber.text.isNotEmpty) {
      if (cardNumber.text.isNotEmpty &&
          !cardNumber.text.contains("*") &&
          AppRegex.isValidCardNumber(cardNumber.text)) {
        cardNumberValidation = TextFieldValidation.valid;
      } else {
        cardNumberValidation = TextFieldValidation.notValid;
      }
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
    selectedCard = card;
    selectedSavedCardId = card.id;
    emit(PaymentState.selectedSavedCard(card.id));
    clearPaymentFormData();
  }

  void onRemoveSelectedCard() {
    selectedSavedCardId = null;
    clearPaymentFormData();
    emit(const PaymentState.selectedSavedCard(""));
  }

  void checkBillingPostalCodeValidation() {
    if (billingPostalCodeCtrl.text.isEmpty) {
      billingPostalCodeValidation = TextFieldValidation.notValid;
    } else {
      billingPostalCodeValidation = TextFieldValidation.valid;
    }
    emit(PaymentState.checkBillingPostalCode(billingPostalCodeValidation));
  }

  void payCarRequest({
    required String carRequestId,
    required num amount,
  }) async {
    checkCardHolderNameValidation();
    checkCardNumberValidation();
    checkExpiryDateValidation();
    checkCVVValidation();
    if (((cardHolderName.text.isNotEmpty &&
                cardHolderNameValidation == TextFieldValidation.valid &&
                cardNumber.text.isNotEmpty &&
                cardNumberValidation == TextFieldValidation.valid &&
                cardExpiryDate.text.isNotEmpty &&
                cardExpiryDateValidation == TextFieldValidation.valid) ||
            selectedCard != null) &&
        cardCVV.text.isNotEmpty &&
        cardCVVValidation == TextFieldValidation.valid) {
      emit(const PaymentState.submitPaymentFormLoading());
      try {
        final res = await _paymentRepository.carRequestPayment(
          requestId: carRequestId,
          paymentAmount: amount,
          visaCardName: (selectedCard != null && selectedCardToggleIndex == 0)
              ? selectedCard!.visaCardName
              : cardHolderName.text,
          visaCardNumber: (selectedCard != null && selectedCardToggleIndex == 0)
              ? selectedCard!.visaCardNumber
              : cardNumber.text,
          billingVisaLastNo:
              (selectedCard != null && selectedCardToggleIndex == 0)
                  ? selectedCard!.visaCardNumber
                  : getLastFourFromCardNumber(cardNumber.text),
          visaCardExpiryMonth:
              (selectedCard != null && selectedCardToggleIndex == 0)
                  ? selectedCard!.visaCardExpiryMonth
                  : cardExpiryDate.text.split('/')[0],
          visaCardExpiryYear:
              (selectedCard != null && selectedCardToggleIndex == 0)
                  ? selectedCard!.visaCardExpiryYear
                  : cardExpiryDate.text.split('/')[1],
          isToSave: isSaveCardInfo,
          billingCustomerName: _authRepository.customer.customerName,
          billingAddress: _authRepository.customer.customerAddress,
          billingPostalCode: billingPostalCodeCtrl.text,
          savedCardId: (selectedCard != null && selectedCardToggleIndex == 0)
              ? selectedSavedCardId
              : null,
        );
        res.fold(
          (errMsg) => emit(PaymentState.submitPaymentFormError(errMsg)),
          (message) {
            if (isSaveCardInfo) {
              _paymentRepository.getSavedPaymentMethods();
            }
            emit(PaymentState.submitPaymentFormSuccess(message));
          },
        );
      } catch (e) {
        emit(PaymentState.submitPaymentFormError(e.toString()));
      }
    }
  }
}

String getLastFourFromCardNumber(String cardNumber) {
  String number = cardNumber.substring(cardNumber.length - 4);
  return number;
}
