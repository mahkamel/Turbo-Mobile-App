import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
  bool isFirstTimeGettingCarRec = true;
  bool isFirstGettingCarBrand = true;

  Map<String, List<Car>> carsByBrand = {};
  List<CarBrand> carBrands = [];

  void changeSelectedBrandIndex(int newIndex) {
    selectedBrandIndex = newIndex;
    emit(HomeState.changeSelectedBrandIndex(selectedBrandIndex));
  }

  void getCarsBrands() async {
    emit(const HomeState.getCarsBrandsLoading());
    try {
      if (_carRepository.carBrands.isEmpty) {
        final res = await _carRepository.getCarBrands();
        res.fold(
          (errMsg) {
            isFirstGettingCarBrand = false;
            emit(HomeState.getCarsBrandsError(errMsg));
          },
          (brands) {
            carBrands = brands;
            isFirstGettingCarBrand = false;
            emit(const HomeState.getCarsBrandsSuccess());
          },
        );
      } else {
        carBrands = _carRepository.carBrands;
        isFirstGettingCarBrand = false;
        emit(const HomeState.getCarsBrandsSuccess());
      }
    } catch (e) {
      isFirstGettingCarBrand = false;
      emit(HomeState.getCarsBrandsError(e.toString()));
    }
  }

  void getCarsBasedOnBrand({String? brandId}) async {
    carsByBrand.clear();
    emit(const HomeState.getCarsByBrandLoading());
    try {
      final res = await _carRepository.getCarsByBrand(brandId: brandId);
      res.fold(
        (errMsg) {
          isFirstTimeGettingCarRec = false;
          emit(HomeState.getCarsByBrandError(errMsg));
        },
        (cars) {
          carsByBrand = cars;
          isFirstTimeGettingCarRec = false;
          emit(HomeState.getCarsByBrandSuccess(brandId));
        },
      );
    } catch (e) {
      isFirstTimeGettingCarRec = false;
      emit(HomeState.getCarsByBrandError(e.toString()));
    }
  }

  void getCities() async {
    emit(const HomeState.getCitiesLoading());
    try {
      if (_citiesDistrictsRepository.cities.isNotEmpty) {
        emit(const HomeState.getCitiesSuccess());
        getCachedSelectedCityIndex();
      } else {
        final res = await _citiesDistrictsRepository.getCities();
        res.fold(
          (errMsg) => emit(HomeState.getCitiesError(errMsg)),
          (r) {
            getCachedSelectedCityIndex();
            emit(const HomeState.getCitiesSuccess());
          },
        );
      }
    } catch (e) {
      emit(HomeState.getCitiesError(e.toString()));
    }
  }

  void getCachedSelectedCityIndex() async {
    String? cachedId = await CacheHelper.getData(key: "SelectedCityId");
    if (cachedId != null) {
      _authRepository.selectedCityIndex =
          _citiesDistrictsRepository.cities.indexWhere(
        (element) => element.id == cachedId,
      );
    }
  }

  void changeSelectedCityIndex(int index) {
    _authRepository.selectedCityIndex = index;
    String id =
        _citiesDistrictsRepository.cities[_authRepository.selectedCityIndex].id;
    _authRepository.setSelectedCityIdToCache(id);
    emit(HomeState.changeSelectedCityIndex(index));
  }
}
