import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';

import '../../core/services/networking/repositories/auth_repository.dart';
import '../../models/car_brand_model.dart';
import '../../models/get_cars_by_brands.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  final CarRepository _carRepository;
  HomeCubit(
    this._authRepository,
    this._carRepository,
  ) : super(const HomeState.initial());

  int selectedBrandIndex = -1;

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
            emit(HomeState.getCarsBrandsError(errMsg));
          },
          (brands) {
            carBrands = brands;
            emit(const HomeState.getCarsBrandsSuccess());
          },
        );
      } else {
        carBrands = _carRepository.carBrands;
        emit(const HomeState.getCarsBrandsSuccess());
      }
    } catch (e) {
      emit(HomeState.getCarsBrandsError(e.toString()));
    }
  }

  void getCarsBasedOnBrand({String? brandId}) async {
    carsByBrand.clear();
    emit(const HomeState.getCarsByBrandLoading());
    try {
      final res = await _carRepository.getCarsByBrand(brandId: brandId);
      res.fold(
        (errMsg) => emit(HomeState.getCarsByBrandError(errMsg)),
        (cars) {
          carsByBrand = cars;
          emit(HomeState.getCarsByBrandSuccess(brandId));
        },
      );
    } catch (e) {
      emit(HomeState.getCarsByBrandError(e.toString()));
    }
  }
}
