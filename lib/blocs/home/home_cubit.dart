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

  int selectedCategoryIndex = 0;

  Map<String, List<Car>> carsByBrand = {};
  List<CarBrand> carBrands = [];

  void getCarsBrands() async {
    print("gettt brands");
    emit(const HomeState.getCarsBrandsLoading());
    try {
      final res = await _carRepository.getCarBrands();
      res.fold(
        (errMsg) => emit(HomeState.getCarsBrandsError(errMsg)),
        (brands) {
          print("branndssss ${brands.length}");
          carBrands = brands;
          emit(const HomeState.getCarsBrandsSuccess());
        },
      );
    } catch (e) {
      emit(HomeState.getCarsBrandsError(e.toString()));
    }
  }

  void getCarsBasedOnBrand() async {
    print("caaaaarrrr");
    emit(const HomeState.getCarsByBrandLoading());
    try {
      final res = await _carRepository.getCarsByBrand();
      res.fold(
        (errMsg) => emit(HomeState.getCarsByBrandError(errMsg)),
        (r) {
          carsByBrand = r.cars.carTypes;
          print("caaaaaa ${carsByBrand.length} -- $carsByBrand");
          emit(const HomeState.getCarsByBrandSuccess());
        },
      );
    } catch (e) {
      emit(HomeState.getCarsByBrandError(e.toString()));
    }
  }
}
