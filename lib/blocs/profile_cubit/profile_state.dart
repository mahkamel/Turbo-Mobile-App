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

  const factory ProfileState.editProfileLoading() =
  EditProfileLoadingState;
  const factory ProfileState.editProfileSuccess(String success) =
  EditProfileSuccessState;
  const factory ProfileState.editProfileError(String errMsg) =
  EditProfileErrorState;
  const factory ProfileState.editProfileEmpty() =
  EditProfileEmptyState;

  const factory ProfileState.deleteProfileLoading() =
  DeleteProfileLoadingState;
  const factory ProfileState.deleteProfileSuccess(String success) =
  DeleteProfileSuccessState;
  const factory ProfileState.deleteProfileError(String errMsg) =
  DeleteProfileErrorState;

  const factory ProfileState.setDefaultCardLoading(String id) =
  SetDefaultCardLoadingState;
  const factory ProfileState.setDefaultCardSuccess(String success) =
  SetDefaultCardSuccessState;
  const factory ProfileState.setDefaultCardError(String errMsg) =
  SetDefaultCardErrorState;

  const factory ProfileState.editPaymentCardLoading() =
  EditPaymentCardLoadingState;
  const factory ProfileState.editPaymentCardSuccess(String success) =
  EditPaymentCardSuccessState;
  const factory ProfileState.editPaymentCardError(String errMsg) =
  EditPaymentCardErrorState;
  const factory ProfileState.editPaymentCardEmpty() =
  EditPaymentCardEmptyState;

  const factory ProfileState.imagePicked(String imagePath) = ProfileImagePickedState;
}
