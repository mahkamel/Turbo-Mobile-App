import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/services/networking/repositories/payment_repository.dart';
import 'package:turbo/main_paths.dart';

import '../../core/helpers/app_regex.dart';
import '../../core/helpers/enums.dart';
import '../../core/helpers/functions.dart';
import '../../models/saved_card.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final PaymentRepository _paymentRepository;
  final AuthRepository _authRepository;
  ProfileCubit(this._paymentRepository, this._authRepository)
      : super(const ProfileState.initial());

  bool isEditingSavedCards = false;

  List<String> savedCardsIdsToBeDeleted = [];

  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardExpiryDate = TextEditingController();
  TextEditingController cardCVV = TextEditingController();
  TextEditingController profileName = TextEditingController();
  TextEditingController profileEmail = TextEditingController();
  TextEditingController profileAddress = TextEditingController();
  TextEditingController profilePhoneNumber = TextEditingController();
  TextEditingController profileNationalIdNumber = TextEditingController();
  TextFieldValidation cardHolderNameValidation = TextFieldValidation.normal;
  TextFieldValidation cardNumberValidation = TextFieldValidation.normal;
  TextFieldValidation cardExpiryDateValidation = TextFieldValidation.normal;
  TextFieldValidation cardCVVValidation = TextFieldValidation.normal;

  File? profileImage; 
  
  List<SavedCard> savedPaymentCards = [];
  void savedCardsInit() {
    savedCardsIdsToBeDeleted.clear();
    isEditingSavedCards = false;
    for (var card in savedPaymentCards) {
      card.isSelected = false;
    }

    clearPaymentFormData();
  }

  Future<void> getAllSavedPaymentMethods(
      {bool isForceToRefresh = false}) async {
    emit(const ProfileState.getAllSavedCardsLoading());
    if (isForceToRefresh || _paymentRepository.savedPaymentCards.isEmpty) {
      try {
        final res = await _paymentRepository.getSavedPaymentMethods();
        res.fold((errMsg) {
          emit(ProfileState.getAllSavedCardsError(errMsg));
        }, (allCards) {
          savedPaymentCards = allCards;
          emit(ProfileState.getAllSavedCardsSuccess(savedPaymentCards.length));
        });
      } catch (e) {
        emit(ProfileState.getAllSavedCardsError(e.toString()));
      }
    } else {
      try {
        savedPaymentCards = _paymentRepository.savedPaymentCards;
        emit(ProfileState.getAllSavedCardsSuccess(savedPaymentCards.length));
      } catch (e) {
        emit(ProfileState.getAllSavedCardsError(e.toString()));
      }
    }
  }

  void checkCardHolderNameValidation() {
    if (cardHolderName.text.isNotEmpty) {
      cardHolderNameValidation = TextFieldValidation.valid;
    } else {
      cardHolderNameValidation = TextFieldValidation.notValid;
    }
    emit(ProfileState.checkCardToSaveHolderName(cardHolderNameValidation));
  }

  void checkCardNumberValidation() {
    if (cardNumber.text.isNotEmpty &&
        !cardNumber.text.contains("*") &&
        AppRegex.isValidCardNumber(cardNumber.text)) {
      cardNumberValidation = TextFieldValidation.valid;
    } else {
      cardNumberValidation = TextFieldValidation.notValid;
    }
    emit(ProfileState.checkCardToSaveNumber(cardNumberValidation));
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
    emit(ProfileState.checkCardToSaveExpiryDate(cardExpiryDateValidation));
  }

  void checkCVVValidation() {
    if (cardCVV.text.isNotEmpty && cardCVV.text.length == 3) {
      cardCVVValidation = TextFieldValidation.valid;
    } else {
      cardCVVValidation = TextFieldValidation.notValid;
    }
    emit(ProfileState.checkCardToSaveCVV(cardCVVValidation));
  }

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

  void addNewPaymentCard() async {
    checkCardHolderNameValidation();
    checkCardNumberValidation();
    checkExpiryDateValidation();
    checkCVVValidation();
    if (cardHolderName.text.isNotEmpty &&
        cardHolderNameValidation == TextFieldValidation.valid &&
        cardNumber.text.isNotEmpty &&
        cardNumberValidation == TextFieldValidation.valid &&
        cardExpiryDate.text.isNotEmpty &&
        cardExpiryDateValidation == TextFieldValidation.valid &&
        cardCVV.text.isNotEmpty &&
        cardCVVValidation == TextFieldValidation.valid) {
      emit(const ProfileState.addNewCardLoading());
      try {
        final res = await _paymentRepository.addNewCard(
          visaCardName: cardHolderName.text,
          visaCardNumber: cardNumber.text.removeWhiteSpaces(),
          visaCardExpiryMonth: cardExpiryDate.text.split('/')[0],
          visaCardExpiryYear: cardExpiryDate.text.split('/')[1],
        );
        res.fold((errMsg) {
          emit(ProfileState.addNewCardError(errMsg));
        }, (_) async {
          clearPaymentFormData();
          await getAllSavedPaymentMethods(isForceToRefresh: true);
          emit(const ProfileState.addNewCardSuccess());
        });
      } catch (e) {
        emit(ProfileState.addNewCardError(e.toString()));
      }
    }
  }

  void changeIsEditingSavedCardsValue() {
    isEditingSavedCards = !isEditingSavedCards;
    if (!isEditingSavedCards) {
      savedCardsIdsToBeDeleted.clear();
      for (var card in savedPaymentCards) {
        card.isSelected = false;
      }
    }
    emit(ProfileState.changeEditingCardsValue(isEditingSavedCards));
  }

  void changeSelectCardToDeleteValue(int index) {
    savedPaymentCards[index].isSelected = !savedPaymentCards[index].isSelected;
    if (savedPaymentCards[index].isSelected) {
      savedCardsIdsToBeDeleted.add(savedPaymentCards[index].id);
    } else {
      savedCardsIdsToBeDeleted
          .removeWhere((element) => element == savedPaymentCards[index].id);
    }
    emit(ProfileState.changeSelectCardToBeDeletedValue(
        index, savedPaymentCards[index].isSelected));
  }

  void deleteCardFromSaved(String cardId) async {
    emit(const ProfileState.deleteSavedCardsLoading());
      try {
        final res =
            await _paymentRepository.deleteSavedPaymentMethods(cardId);
        res.fold((errMsg) {
          emit(ProfileState.deleteSavedCardsError(errMsg));
        }, (_) {
          savedPaymentCards.removeWhere((element) => element.id == cardId);
          _paymentRepository.savedPaymentCards
              .removeWhere((element) => element.id == cardId);
          emit(ProfileState.deleteSavedCardsSuccess(cardId));
        });
      } catch (e) {
        emit(ProfileState.deleteSavedCardsError(e.toString()));
      }
    
    getAllSavedPaymentMethods(isForceToRefresh: true);
  }

  void logout() async {
    emit(const ProfileState.logoutLoading());
    try {
      await _authRepository.disableNotificationToken(AppConstants.fcmToken);
      await _authRepository.clearCustomerData();
      _paymentRepository.savedPaymentCards.clear();

      emit(const ProfileState.logoutSuccess());
    } catch (e) {
      emit(ProfileState.logoutError(e.toString()));
    }
  }

  void editProfile() async {
    emit(const ProfileState.editProfileLoading());
    try{
      final Either<String, String> res;
      if(profileName.text.isNotEmpty || profileAddress.text.isNotEmpty) {
        String? name = profileName.text.isNotEmpty ? profileName.text :
            null;
        String? address = profileAddress.text.isNotEmpty ? profileAddress.text :
            null;
        if(profileImage == null) {
          res = await _authRepository.editCustomer(customerName: name, customerAddress: address);
        } else {
          res = await _authRepository.editCustomer(customerName: name, customerAddress: address, image: profileImage);
        }
        res.fold((errMsg) {
          emit(ProfileState.editProfileError(errMsg));
        }, (success) {
          emit(ProfileState.editProfileSuccess(success));
          profileName.text = '';
          profileAddress.text = '';
        });
      } else {
        emit(const ProfileState.editProfileEmpty());
      }
    }
    catch(e) {
      emit(ProfileState.editProfileError(e.toString()));
    }
  }
  void deleteProfile() async {
    emit(const ProfileState.deleteProfileLoading());
    try {
      final res = await _authRepository.deleteCustomer();
      res.fold((errMsg) {
        emit(ProfileState.deleteProfileError(errMsg));
      }, (msg) {
        emit(ProfileState.deleteProfileSuccess(msg));
      });
    } catch(e) {
      emit(ProfileState.deleteProfileError(e.toString()));
    }
  }
}

