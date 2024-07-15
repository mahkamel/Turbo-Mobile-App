import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';
import 'package:turbo/models/notifications_model.dart';

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

  List<CarData> carsByBrand = [];
  List<CarBrand> carBrands = [];
  List<UserNotificationModel> notifications = [];

  bool isFirstGettingCarBrand = true;

  void changeSelectedBrandIndex(int newIndex) {
    selectedBrandIndex = newIndex;
    emit(HomeState.changeSelectedBrandIndex(selectedBrandIndex));
  }

  void getCarsBrandsByBranchId() async {
    isFirstGettingCarBrand = true;
    emit(const HomeState.getCarsBrandsLoading());
    try {
      if (_carRepository.carBrands.isEmpty) {
        final res =
            await _carRepository.getCarBrands(_authRepository.selectedBranchId);
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
        getCarsBrandsByBranchId();
        getCarsBasedOnBrand();
      } else {
        final res = await _citiesDistrictsRepository.getCities();
        res.fold(
          (errMsg) => emit(HomeState.getCitiesError(errMsg)),
          (cities) async {
            await getCachedCityAndBranch();
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

  Future<void> getCachedCityAndBranch() async {
    String? cachedCityId = await CacheHelper.getData(key: "SelectedCityId");
    String? cachedBranchId = await CacheHelper.getData(key: "SelectedBranchId");
    if (cachedCityId != null) {
      _authRepository.selectedCityIndex =
          _citiesDistrictsRepository.cities.indexWhere(
        (element) {
          return element.id == cachedCityId;
        },
      );
      if (_authRepository.selectedCityIndex == -1) {
        _authRepository.selectedCityIndex = 0;
      }

      _authRepository.selectedCityId = _citiesDistrictsRepository
          .cities[_authRepository.selectedCityIndex].id;
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
    } else {
      _authRepository.selectedBranchId = _citiesDistrictsRepository
          .cities[_authRepository.selectedCityIndex]
          .branches[_authRepository.selectedBranchIndex]
          .id;
    }
  }

  void changeSelectedCityIndex(int index) {
    _authRepository.selectedCityIndex = index;
    String id =
        _citiesDistrictsRepository.cities[_authRepository.selectedCityIndex].id;
    _authRepository.setSelectedCityIdToCache(id);
    _authRepository.selectedCityId = id;
    emit(HomeState.changeSelectedCityIndex(index));
  }

  void changeSelectedBranchIndex(int index) {
    _authRepository.selectedBranchIndex = index;
    _authRepository.selectedBranchId = _citiesDistrictsRepository
        .cities[_authRepository.selectedCityIndex].branches[index].id;
    _authRepository
        .setSelectedBranchIdToCache(_authRepository.selectedBranchId);
  }

  void getNotifications() async {
    try {
      final res = await _authRepository.getNotifications();
      res.fold(
        (errMsg) {
          emit(HomeState.getNotificationsError(errMsg));
        },
        (userNotifications) {
          notifications = userNotifications;
          emit(HomeState.getNotificationsSuccess());
        },
      );
    } catch (e) {
      emit(HomeState.getNotificationsError(e.toString()));
    }
  }
}
