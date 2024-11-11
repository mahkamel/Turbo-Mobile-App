import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';

import '../../core/services/networking/repositories/car_repository.dart';
import '../../models/car_brand_model.dart';
import '../../models/get_cars_by_brands.dart';

part 'search_state.dart';
part 'search_cubit.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  final CarRepository _carRepository;
  final AuthRepository _authRepository;
  SearchCubit(this._carRepository, this._authRepository)
      : super(const SearchState.initial());

  TextEditingController brandSearchController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  List<CarBrand> searchedBrands = [];
  List<CarBrand> selectedBrands = [];

  Set<int> selectedCarYears = {};

  bool isWithUnlimitedKM = false;

  List<CarData> filteredCars = [];

  bool isFilteredRes = false;
  bool isGettingFilterResults = false;

  int selectedFilterPriceRange = -1;

  double minDailyPrice = 1;
  double maxDailyPrice = 2500;

  init() {
    filteredCars = _carRepository.filteredCars;
    if (_carRepository.filteredCars.isNotEmpty) {
      isFilteredRes = true;

      emit(const SearchState.getFilteredCarsSuccess());
    }
    getCarsTypes();
    getCarsCategories();
    getCarsBrands();
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

  void carYearsSelection(int year) {
    selectedCarYears.add(year);
    emit(SearchState.yearSelectionState(year, true));
  }

  void unSelectCarYear(int year) {
    selectedCarYears.remove(year);
    emit(SearchState.yearSelectionState(year, false));
  }

  void getCarsBrands() async {
    emit(const SearchState.getCarsBrandsLoading());
    try {
      if (_carRepository.carBrands.isEmpty) {
        await _carRepository.getCarBrands(_authRepository.selectedBranchId);
      }
      emit(const SearchState.getCarsBrandsSuccess());
    } catch (e) {
      emit(SearchState.getCarsBrandsError(e.toString()));
    }
  }

  void getCarsCategories() async {
    emit(const SearchState.getCarsCategoriesLoading());
    try {
      if(_carRepository.carCategories.isEmpty) {
        await _carRepository.getAllCategories();
      }
      emit(const SearchState.getCarsCategoriesSuccess());
    } catch (e) { 
      emit(SearchState.getCarsCategoriesError(e.toString()));
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

  void carCategoriesSelection(int index) {
    _carRepository.carCategories[index].isSelected =
        !_carRepository.carCategories[index].isSelected;
    emit(
      SearchState.categoriesSelectionState(
        _carRepository.carCategories[index].categoryName,
        _carRepository.carCategories[index].isSelected,
      ),
    );
  }

  void validateMinPrice() {
    if(minPriceController.text.isEmpty) {
      minPriceController.text = '1';
      changePriceRangeIndex(min: 1, max: maxDailyPrice);
    }
    double value = double.parse(minPriceController.text);
    if(value < 1) {
      minPriceController.text = '1';
      changePriceRangeIndex(min: 1, max: maxDailyPrice);
    }
    else if(value > maxDailyPrice) {
      minPriceController.text = maxDailyPrice.toString();
      changePriceRangeIndex(min: maxDailyPrice, max: maxDailyPrice);
    } 
    else {
      changePriceRangeIndex(min: value, max: maxDailyPrice);
    }
  }

  void validateMaxPrice() {
    if(maxPriceController.text.isEmpty) {
      maxPriceController.text = '2500';
      changePriceRangeIndex(min: minDailyPrice, max: 2500);
    }
    double value = double.parse(maxPriceController.text);
    double minPrice = double.parse(minPriceController.text);
    if(value < minPrice) {
      maxPriceController.text = minPriceController.text;
      changePriceRangeIndex(min: minPrice, max: minPrice);
    } else {
      changePriceRangeIndex(min: minDailyPrice, max: value);
    }
  }

  void changePriceRangeIndex({
    required double min,
    required double max,
  }) {
    minDailyPrice = min;
    maxDailyPrice = max;
    minPriceController.text = '$min';
    maxPriceController.text = '$max';
    emit(SearchState.changeSelectedPriceRangeIndex(
        minDailyPrice, maxDailyPrice));
  }

  void applyFilter() async {
    List<String> selectedTypesId = [];
    List<String> selectedBrandsId = [];
    List<String> selectedCategoriesId = [];
    for (var type in _carRepository.carTypes) {
      if (type.isSelected) {
        selectedTypesId.add(type.id);
      }
    }
    for (var type in _carRepository.carCategories) {
      if (type.isSelected) {
        selectedCategoriesId.add(type.id);
      }
    }
    for (var brand in selectedBrands) {
      selectedBrandsId.add(brand.id);
    }

    isFilteredRes = false;
    isGettingFilterResults = true;
    try {
      emit(const SearchState.getFilteredCarsLoading());
      final res = await _carRepository.carsFilter(
        carYears: List<String>.from(selectedCarYears),
        carTypes: selectedTypesId,
        carBrands: selectedBrandsId,
        carCategories: selectedCategoriesId,
        // isWithUnlimited: isWithUnlimitedKM,
        branchId: _authRepository.selectedBranchId,
        priceFrom: minDailyPrice,
        priceTo: maxDailyPrice == 2500 ? null : maxDailyPrice,
      );
      res.fold(
        (errMsg) {
          filteredCars = [];
          isGettingFilterResults = false;
          emit(SearchState.getFilteredCarsError(errMsg));
        },
        (res) {
          filteredCars = res;
          isFilteredRes = true;
          isGettingFilterResults = false;
          emit(const SearchState.getFilteredCarsSuccess());
        },
      );
    } catch (e) {
      isGettingFilterResults = false;
      emit(SearchState.getFilteredCarsError(e.toString()));
    }
  }

  void resetSearch() {
    unSelectAllBrands();
    selectedBrands.clear();
    selectedCarYears = {};
    for(var cat in _carRepository.carCategories){
      cat.isSelected = false;
    }

    isWithUnlimitedKM = false;
    changePriceRangeIndex(min: 1, max: 2500);
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

int? getFromPriceRange(int index) {
  if (index == 0) {
    return 1;
  } else if (index == 1) {
    return 500;
  } else if (index == 2) {
    return 1000;
  } else if (index == 3) {
    return 2000;
  }
  return null;
}

int? getToPriceRange(int index) {
  if (index == 0) {
    return 500;
  } else if (index == 1) {
    return 1000;
  } else if (index == 2) {
    return 2000;
  }
  return null;
}
