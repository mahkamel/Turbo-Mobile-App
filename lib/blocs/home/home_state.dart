part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  const factory HomeState.getCarsBrandsLoading() = GetCarsBrandsLoadingState;
  const factory HomeState.getCarsBrandsSuccess() = GetCarsBrandsSuccessState;
  const factory HomeState.getCarsBrandsError(final String errMsg) = GetCarsBrandsErrorState;

  const factory HomeState.getCarsByBrandLoading() = GetCarsByBrandLoadingState;
  const factory HomeState.getCarsByBrandSuccess(final String? brandId) = GetCarsByBrandSuccessState;
  const factory HomeState.getCarsByBrandError(final String errMsg) = GetCarsByBrandErrorState;

  const factory HomeState.changeSelectedBrandIndex(final int index) = ChangeSelectedBrandIndexState;


}
