import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/core/services/networking/repositories/payment_repository.dart';
import 'package:turbo/main_paths.dart';

import '../../core/helpers/app_regex.dart';
import '../../core/helpers/enums.dart';
import '../../models/request_model.dart';
import '../../models/saved_card.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final PaymentRepository _paymentRepository;
  final AuthRepository _authRepository;
  final CarRepository _carRepository;
  ProfileCubit(
    this._paymentRepository,
    this._authRepository,
    this._carRepository,
  ) : super(const ProfileState.initial());

  bool isEditingSavedCards = false;

  List<String> savedCardsIdsToBeDeleted = [];

  List<RequestModel> requestsHistory = [];

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

  void checkExpiryDateValidation({bool isFromEdit = false}) {
    if (cardExpiryDate.text.isEmpty) {
      cardExpiryDateValidation = TextFieldValidation.notValid;
    } else {
      if (validateExpiryDate(cardExpiryDate.text)) {
        cardExpiryDateValidation = TextFieldValidation.valid;
      } else {
        cardExpiryDateValidation = TextFieldValidation.notValid;
      }
    }
    if (isFromEdit) {
      cardExpiryDateValidation = TextFieldValidation.valid;
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
          visaCardType:
              AppRegex.detectCardType(cardNumber.text.removeWhiteSpaces())!,
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

  void setDefaultCard(String cardId, int index) async {
    emit(ProfileState.setDefaultCardLoading(cardId));
    try {
      final res = await _paymentRepository.setDefaultCard(cardId);
      res.fold((errMsg) {
        emit(ProfileState.setDefaultCardError(errMsg));
      }, (msg) async {
        savedPaymentCards[index].isCardDefault = true;
        for (int i = 0; i < savedPaymentCards.length; i++) {
          if (i != index) {
            savedPaymentCards[i].isCardDefault = false;
          }
        }
        _paymentRepository.defaultCard = savedPaymentCards[index];
        emit(ProfileState.setDefaultCardSuccess(msg));
      });
    } catch (e) {
      emit(ProfileState.setDefaultCardError(e.toString()));
    }
  }

  void editPaymentCard(int index) async {
    if (cardHolderName.text.isNotEmpty || cardExpiryDate.text.isNotEmpty) {
      String? name =
          cardHolderName.text.isNotEmpty ? cardHolderName.text : null;
      String? expMonth = cardExpiryDate.text.isNotEmpty
          ? cardExpiryDate.text.split('/')[0]
          : null;
      String? expYear = cardExpiryDate.text.isNotEmpty
          ? cardExpiryDate.text.split('/')[1]
          : null;

      emit(const ProfileState.editPaymentCardLoading());
      try {
        final res = await _paymentRepository.editPaymentCard(
            savedPaymentCards[index].id, name, expMonth, expYear);
        res.fold((errMsg) {
          emit(ProfileState.editPaymentCardError(errMsg));
        }, (msg) async {
          clearPaymentFormData();
          await getAllSavedPaymentMethods(isForceToRefresh: true);
          emit(ProfileState.editPaymentCardSuccess(msg));
        });
      } catch (e) {
        emit(ProfileState.editPaymentCardError(e.toString()));
      }
    } else {
      emit(const ProfileState.editPaymentCardEmpty());
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
      final res = await _paymentRepository.deleteSavedPaymentMethods(cardId);
      res.fold((errMsg) {
        emit(ProfileState.deleteSavedCardsError(errMsg));
      }, (_) {
        _paymentRepository.savedPaymentCards
            .removeWhere((element) => element.id == cardId);
        savedPaymentCards = _paymentRepository.savedPaymentCards;

        emit(ProfileState.deleteSavedCardsSuccess(cardId));
      });
    } catch (e) {
      emit(ProfileState.deleteSavedCardsError(e.toString()));
    }
  }

  void logout() async {
    emit(const ProfileState.logoutLoading());
    try {
      _paymentRepository.savedPaymentCards.clear();
      await _authRepository.disableNotificationToken(AppConstants.fcmToken);
      await _authRepository.clearCustomerData();

      emit(const ProfileState.logoutSuccess());
    } catch (e) {
      emit(ProfileState.logoutError(e.toString()));
    }
  }

  void editProfile() async {
    emit(const ProfileState.editProfileLoading());
    try {
      final Either<String, String> res;
      if (profileName.text.isNotEmpty || profileAddress.text.isNotEmpty) {
        String? name = profileName.text.isNotEmpty ? profileName.text : null;
        String? address =
            profileAddress.text.isNotEmpty ? profileAddress.text : null;
        if (profileImage == null) {
          res = await _authRepository.editCustomer(
              customerName: name, customerAddress: address);
        } else {
          res = await _authRepository.editCustomer(
              customerName: name,
              customerAddress: address,
              image: profileImage);
        }
        res.fold((errMsg) {
          emit(ProfileState.editProfileError(errMsg));
        }, (success) {
          emit(ProfileState.editProfileSuccess(success));
          profileName.text = '';
          profileAddress.text = '';
        });
      } else {
        if (profileImage != null) {
          res = await _authRepository.editCustomer(
              image: profileImage,
              customerName: _authRepository.customer.customerName);
          res.fold((errMsg) {
            emit(ProfileState.editProfileError(errMsg));
          }, (success) {
            emit(ProfileState.editProfileSuccess(success));
          });
        } else {
          emit(const ProfileState.editProfileEmpty());
        }
      }
    } catch (e) {
      emit(ProfileState.editProfileError(e.toString()));
    }
  }

  void updateProfileImage(File image) {
    profileImage = image;
    emit(ProfileState.imagePicked(image.path)); // Emit a state for image change
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
    } catch (e) {
      emit(ProfileState.deleteProfileError(e.toString()));
    }
  }

  void getCustomerHistoryRequests() async {
    requestsHistory = [];
    emit(const ProfileState.getAllRequestsHistoryLoading());
    try {
      final res = await _carRepository.getAllRequests();
      res.fold(
        (errMsg) {
          emit(ProfileState.getAllRequestsHistoryError(errMsg));
        },
        (userRequests) {
          requestsHistory = userRequests;

          requestsHistory.removeWhere((element) =>
              element.requestTo.isAfter(DateTime.now()) ||
              element.requestStatus == 0 ||
              element.requestStatus == 4);
          emit(const ProfileState.getAllRequestsHistorySuccess());
        },
      );
    } catch (e) {
      emit(ProfileState.getAllRequestsHistoryError(e.toString()));
    }
  }
}
