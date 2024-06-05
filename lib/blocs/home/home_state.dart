part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.getCurrentUserLocation(final String address) = GetCurrentUserLocationState;
  const factory HomeState.changeSelectedCategoryIndex(final int index) = ChangeSelectedCategoryIndexState;

}
