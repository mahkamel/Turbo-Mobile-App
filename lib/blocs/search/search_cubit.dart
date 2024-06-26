import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/services/networking/repositories/car_repository.dart';
import '../../models/car_brand_model.dart';
import '../../models/get_cars_by_brands.dart';

part 'search_state.dart';
part 'search_cubit.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  final CarRepository _carRepository;
  SearchCubit(this._carRepository) : super(const SearchState.initial());

  TextEditingController brandSearchController = TextEditingController();

  List<CarBrand> searchedBrands = [];
  List<CarBrand> selectedBrands = [];

  Set<String> selectedCarYears = {};

  bool isWithUnlimitedKM = false;

  Map<String, List<Car>> filteredCars = {};

  bool isFilteredRes = false;

  init() {
    filteredCars = _carRepository.filteredCars;
    if (_carRepository.filteredCars.isNotEmpty) {
      isFilteredRes = true;
      emit(const SearchState.getFilteredCarsSuccess());
    }
  }

  void unSelectAllBrands() {
    for (var brand in _carRepository.carBrands) {
      brand.isSelected = false;
    }
    for (var brand in selectedBrands) {
      brand.isSelected = false;
    }
    for (var type in _carRepository.carTypes) {
      type.isSelected = false;
    }
  }

  void carYearsSelection(String year) {
    selectedCarYears.add(year);
    emit(SearchState.yearSelectionState(year, true));
  }

  void unSelectCarYear(String year) {
    selectedCarYears.remove(year);
    emit(SearchState.yearSelectionState(year, false));
  }

  void getCarsBrands() async {
    emit(const SearchState.getCarsBrandsLoading());
    try {
      if (_carRepository.carBrands.isEmpty) {
        await _carRepository.getCarBrands();
      }
      emit(const SearchState.getCarsBrandsSuccess());
    } catch (e) {
      emit(SearchState.getCarsBrandsError(e.toString()));
    }
  }

  void getCarsTypes() async {
    emit(const SearchState.getCarsTypesLoading());
    try {
      if (_carRepository.carTypes.isEmpty) {
        await _carRepository.getCarTypes();
      }
      emit(const SearchState.getCarsTypesSuccess());
    } catch (e) {
      emit(SearchState.getCarsTypesError(e.toString()));
    }
  }

  void onBrandsSearchedValueChanged() {
    searchedBrands.clear();
    if (brandSearchController.text.isNotEmpty) {
      searchedBrands.addAll(
        _carRepository.carBrands.where(
          (brand) => brand.display
              .toLowerCase()
              .contains(brandSearchController.text.toLowerCase()),
        ),
      );
    }
    emit(SearchState.brandsSearchState(brandSearchController.text));
  }

  void onSelectAndDisSelectBrands(CarBrand brand) {
    if (selectedBrands.contains(brand)) {
      brand.isSelected = false;
      selectedBrands.removeWhere(
        (element) => element.id == brand.id,
      );
    } else {
      brand.isSelected = true;
      selectedBrands.add(brand);
    }
    emit(SearchState.brandsSelectionState(brand.id, brand.isSelected));
  }

  void unSelectTheCarBrand(CarBrand brand) {
    brand.isSelected = false;
    selectedBrands.removeWhere(
      (element) => element.id == brand.id,
    );
    emit(SearchState.brandsSelectionState(brand.id, brand.isSelected));
  }

  void changeIsWithUnlimitedKMValue(bool value) {
    isWithUnlimitedKM = value;
    emit(SearchState.changeIsWithUnlimitedKMValue(isWithUnlimitedKM));
  }

  void carTypesSelection(int index) {
    _carRepository.carTypes[index].isSelected =
        !_carRepository.carTypes[index].isSelected;
    emit(
      SearchState.typesSelectionState(
        _carRepository.carTypes[index].typeName,
        _carRepository.carTypes[index].isSelected,
      ),
    );
  }

  void applyFilter() async {
    isFilteredRes = false;
    try {
      emit(const SearchState.getFilteredCarsLoading());
      List<String> selectedTypesId = [];
      List<String> selectedBrandsId = [];
      for (var type in _carRepository.carTypes) {
        if (type.isSelected) {
          selectedTypesId.add(type.id);
        }
      }
      for (var brand in selectedBrands) {
        selectedBrandsId.add(brand.id);
      }
      final res = await _carRepository.carsFilter(
        carYears: List<String>.from(selectedCarYears),
        carTypes: selectedTypesId,
        carBrands: selectedBrandsId,
        isWithUnlimited: isWithUnlimitedKM,
      );
      res.fold(
        (l) {},
        (res) {
          filteredCars = res;
          isFilteredRes = true;
          emit(const SearchState.getFilteredCarsSuccess());
        },
      );
    } catch (e) {
      emit(SearchState.getFilteredCarsError(e.toString()));
    }
  }

  void resetSearch() {
    unSelectAllBrands();
    selectedBrands.clear();
    selectedCarYears = {};

    isWithUnlimitedKM = false;

    brandSearchController.clear();
    emit(const SearchState.filterReset());
  }

  void clearFilterResults() {
    isFilteredRes = false;
    filteredCars.clear();
    emit(const SearchState.clearFilterResults());
  }

  @override
  Future<void> close() {
    brandSearchController.dispose();
    return super.close();
  }
}
