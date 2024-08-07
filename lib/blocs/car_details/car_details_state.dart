part of 'car_details_cubit.dart';

@freezed
class CarDetailsState with _$CarDetailsState {
  const factory CarDetailsState.initial() = _Initial;

  const factory CarDetailsState.getCarsDetailsLoading(final String carId) =
      GetCarsDetailsLoadingState;
  const factory CarDetailsState.getCarsDetailsSuccess(final String carId) =
      GetCarsDetailsSuccessState;
  const factory CarDetailsState.getCarsDetailsError(final String errMsg) =
      GetCarsDetailsErrorState;

  const factory CarDetailsState.refreshCustomerDataLoading() =
      RefreshCustomerDataLoadingState;
  const factory CarDetailsState.refreshCustomerDataSuccess() =
      RefreshCustomerDataSuccessState;
  const factory CarDetailsState.refreshCustomerDataError(final String errMsg) =
      RefreshCustomerDataErrorState;
}
