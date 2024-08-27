part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;

  const factory ProfileState.checkCardToSaveHolderName(
      TextFieldValidation validation) = CheckCardToSaveHolderNameState;
  const factory ProfileState.checkCardToSaveNumber(
      TextFieldValidation validation) = CheckCardToSaveNumberState;
  const factory ProfileState.checkCardToSaveExpiryDate(
      TextFieldValidation validation) = CheckCardToSaveExpiryDateState;
  const factory ProfileState.checkCardToSaveCVV(
      TextFieldValidation validation) = CheckCardToSaveCVVState;

  const factory ProfileState.addNewCardLoading() = AddNewCardLoadingState;
  const factory ProfileState.addNewCardSuccess() = AddNewCardSuccessState;
  const factory ProfileState.addNewCardError(String errMsg) =
      AddNewCardErrorState;
  const factory ProfileState.getAllSavedCardsLoading() =
      GetAllSavedCardsLoadingState;
  const factory ProfileState.getAllSavedCardsSuccess(int numOfCards) =
      GetAllSavedCardsSuccessState;
  const factory ProfileState.getAllSavedCardsError(String errMsg) =
      GetAllSavedCardsErrorState;

  const factory ProfileState.changeEditingCardsValue(bool isEditing) =
      ChangeEditSavedCardsValueState;
  const factory ProfileState.changeSelectCardToBeDeletedValue(
      int index, bool value) = ChangeSelectCardToBeDeletedState;

  const factory ProfileState.deleteSavedCardsLoading() =
      DeleteSavedCardsLoadingState;
  const factory ProfileState.deleteSavedCardsSuccess(String cardId) =
      DeleteSavedCardsSuccessState;
  const factory ProfileState.deleteSavedCardsError(String errMsg) =
      DeleteSavedCardsErrorState;

  const factory ProfileState.checkProfileAddress({
    required String address,
    required TextFieldValidation validation,
  }) = CheckProfileAddressValidationState;

  const factory ProfileState.checkProfileName({
    required String name,
    required TextFieldValidation validation,
  }) = CheckProfileNameValidationState;


  const factory ProfileState.logoutLoading() =
  LogoutLoadingState;
  const factory ProfileState.logoutSuccess() =
  LogoutSuccessState;
  const factory ProfileState.logoutError(String errMsg) =
  LogoutErrorState;
}
