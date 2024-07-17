part of 'search_cubit.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;

  const factory SearchState.getCarsBrandsLoading() =
      GetSearchCarsBrandsLoadingState;
  const factory SearchState.getCarsBrandsSuccess() =
      GetSearchCarsBrandsSuccessState;
  const factory SearchState.getCarsBrandsError(final String errMsg) =
      GetSearchCarsBrandsErrorState;

  const factory SearchState.getCarsTypesLoading() =
      GetSearchCarsTypesLoadingState;
  const factory SearchState.getCarsTypesSuccess() =
      GetSearchCarsTypesSuccessState;
  const factory SearchState.getCarsTypesError(final String errMsg) =
      GetSearchCarsTypesErrorState;

  const factory SearchState.brandsSearchState(final String text) =
      BrandsSearchState;
  const factory SearchState.brandsSelectionState(
      final String text, bool isSelected) = BrandsSelectionState;

  const factory SearchState.changeIsWithUnlimitedKMValue(final bool value) =
      ChangeIsWithUnlimitedKMValueState;

  const factory SearchState.yearSelectionState(
      final String year, bool isSelected) = YearSelectionState;

  const factory SearchState.typesSelectionState(
      final String type, bool isSelected) = TypesSelectionState;

  const factory SearchState.changeSelectedPriceRangeIndex(
    final double min,
    final double max,
  ) = ChangeSelectedPriceRangeIndexState;

  const factory SearchState.filterReset() = FilterResetState;

  const factory SearchState.clearFilterResults() = ClearFilterResultsState;

  const factory SearchState.getFilteredCarsLoading() =
      GetFilteredCarsLoadingState;
  const factory SearchState.getFilteredCarsSuccess() =
      GetFilteredCarsSuccessState;
  const factory SearchState.getFilteredCarsError(final String errMsg) =
      GetFilteredCarsErrorState;
}
