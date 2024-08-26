part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  const factory HomeState.getCarsBrandsLoading() = GetCarsBrandsLoadingState;
  const factory HomeState.getCarsBrandsSuccess() = GetCarsBrandsSuccessState;
  const factory HomeState.getCarsBrandsError(final String errMsg) =
      GetCarsBrandsErrorState;

  const factory HomeState.getCarsByBrandLoading() = GetCarsByBrandLoadingState;
  const factory HomeState.getCarsByBrandSuccess(final String? brandId) =
      GetCarsByBrandSuccessState;
  const factory HomeState.getCarsByBrandError(final String errMsg) =
      GetCarsByBrandErrorState;

  const factory HomeState.changeSelectedBrandIndex(final int index) =
      ChangeSelectedBrandIndexState;

  const factory HomeState.getCitiesLoading() = GetCitiesLoadingState;
  const factory HomeState.getCitiesSuccess() = GetCitiesSuccessState;
  const factory HomeState.getCitiesError(final String errMsg) =
      GetCitiesErrorState;

  const factory HomeState.changeSelectedCityIndex(final int index) =
      ChangeSelectedCityIndexState;
  const factory HomeState.changeSelectedBranchIndex(final int index) =
      ChangeSelectedBranchIndexState;

  const factory HomeState.getNotificationsLoading() =
      GetNotificationsLoadingState;
  const factory HomeState.getNotificationsSuccess() =
      GetNotificationsSuccessState;
  const factory HomeState.getNotificationsError(final String errMsg) =
      GetNotificationsErrorState;

  const factory HomeState.setReadNotification(final String notificationId) =
      SetReadNotificationState;
  const factory HomeState.toggleBranchState(final int cityIndex) =
      ToggleBranchState;
}
