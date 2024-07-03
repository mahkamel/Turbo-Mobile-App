import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';

import '../../core/services/local/cache_helper.dart';
import '../../core/services/networking/repositories/auth_repository.dart';
import '../../models/car_brand_model.dart';
import '../../models/get_cars_by_brands.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  final CarRepository _carRepository;
  final CitiesDistrictsRepository _citiesDistrictsRepository;
  HomeCubit(
    this._authRepository,
    this._carRepository,
    this._citiesDistrictsRepository,
  ) : super(const HomeState.initial());

  int selectedBrandIndex = -1;

  Map<String, List<Car>> carsByBrand = {};
  List<CarBrand> carBrands = [];

  void changeSelectedBrandIndex(int newIndex) {
    selectedBrandIndex = newIndex;
    emit(HomeState.changeSelectedBrandIndex(selectedBrandIndex));
  }

  void getCarsBrandsByBranchId() async {
    emit(const HomeState.getCarsBrandsLoading());
    try {
      if (_carRepository.carBrands.isEmpty) {
        final res =
            await _carRepository.getCarBrands(_authRepository.selectedBranchId);
        res.fold(
          (errMsg) {
            AppConstants.isFirstGettingCarBrand = false;
            emit(HomeState.getCarsBrandsError(errMsg));
          },
          (brands) {
            carBrands = brands;
            AppConstants.isFirstGettingCarBrand = false;
            emit(const HomeState.getCarsBrandsSuccess());
          },
        );
      } else {
        carBrands = _carRepository.carBrands;
        AppConstants.isFirstGettingCarBrand = false;
        emit(const HomeState.getCarsBrandsSuccess());
      }
    } catch (e) {
      AppConstants.isFirstGettingCarBrand = false;
      emit(HomeState.getCarsBrandsError(e.toString()));
    }
  }

  void getCarsBasedOnBrand({String? brandId}) async {
    carsByBrand.clear();
    emit(const HomeState.getCarsByBrandLoading());
    try {
      final res = await _carRepository.getCarsByBrand(
        branchId: _authRepository.selectedBranchId,
        brandId: brandId,
      );
      res.fold(
        (errMsg) {
          AppConstants.isFirstTimeGettingCarRec = false;
          emit(HomeState.getCarsByBrandError(errMsg));
        },
        (cars) {
          carsByBrand = cars;
          AppConstants.isFirstTimeGettingCarRec = false;
          emit(HomeState.getCarsByBrandSuccess(brandId));
        },
      );
    } catch (e) {
      AppConstants.isFirstTimeGettingCarRec = false;
      emit(HomeState.getCarsByBrandError(e.toString()));
    }
  }

  void getCities() async {
    emit(const HomeState.getCitiesLoading());
    try {
      if (_citiesDistrictsRepository.cities.isNotEmpty) {
        emit(const HomeState.getCitiesSuccess());
        getCachedSelectedCityIndex();
        getCarsBrandsByBranchId();
        getCarsBasedOnBrand();
      } else {
        final res = await _citiesDistrictsRepository.getCities();
        res.fold(
          (errMsg) => emit(HomeState.getCitiesError(errMsg)),
          (cities) {
            getCachedSelectedCityIndex();
            if (_authRepository.selectedBranchId.isEmpty) {
              _authRepository.selectedBranchId =
                  cities[_authRepository.selectedCityIndex]
                      .branches[_authRepository.selectedBranchIndex]
                      .id;
            }
            getCarsBrandsByBranchId();
            getCarsBasedOnBrand();
            emit(const HomeState.getCitiesSuccess());
          },
        );
      }
    } catch (e) {
      emit(HomeState.getCitiesError(e.toString()));
    }
  }

  void getCachedSelectedCityIndex() async {
    String? cachedCityId = await CacheHelper.getData(key: "SelectedCityId");
    String? cachedBranchId = await CacheHelper.getData(key: "SelectedBranchId");
    if (cachedCityId != null) {
      _authRepository.selectedCityIndex =
          _citiesDistrictsRepository.cities.indexWhere(
        (element) {
          return element.id == cachedCityId;
        },
      );
      if (cachedBranchId != null) {
        int index = _citiesDistrictsRepository
            .cities[_authRepository.selectedCityIndex].branches
            .indexWhere(
          (element) => element.id == cachedBranchId,
        );
        if (index != -1) {
          _authRepository.selectedBranchIndex = index;
          _authRepository.selectedBranchId = _citiesDistrictsRepository
              .cities[_authRepository.selectedCityIndex]
              .branches[_authRepository.selectedBranchIndex]
              .id;
        }
      }
    }
  }

  void changeSelectedCityIndex(int index) {
    _authRepository.selectedCityIndex = index;
    String id =
        _citiesDistrictsRepository.cities[_authRepository.selectedCityIndex].id;
    _authRepository.setSelectedCityIdToCache(id);
    emit(HomeState.changeSelectedCityIndex(index));
  }

  void changeSelectedBranchIndex(int index) {
    _authRepository.selectedBranchIndex = index;
    _authRepository.selectedBranchId = _citiesDistrictsRepository
        .cities[_authRepository.selectedCityIndex].branches[index].id;
    print("iddddd ${_authRepository.selectedBranchId}");
    _authRepository
        .setSelectedBranchIdToCache(_authRepository.selectedBranchId);
  }
}
