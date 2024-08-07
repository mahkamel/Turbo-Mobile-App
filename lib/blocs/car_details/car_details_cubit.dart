import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/models/car_details_model.dart';

import '../../core/services/networking/repositories/auth_repository.dart';

part 'car_details_state.dart';
part 'car_details_cubit.freezed.dart';

class CarDetailsCubit extends Cubit<CarDetailsState> {
  final CarRepository _carRepository;
  final AuthRepository _authRepository;
  CarDetailsCubit(this._carRepository, this._authRepository)
      : super(const CarDetailsState.initial());
  CarDetailsData carDetailsData = CarDetailsData.empty();

  void getCarDetails(String carId) async {
    carDetailsData = CarDetailsData.empty();
    emit(CarDetailsState.getCarsDetailsLoading(carId));
    if (AppConstants.vat == -1) {
      final vatRes = await _carRepository.getVat();
      vatRes.fold((errMsg) => CarDetailsState.getCarsDetailsError(errMsg),
          (r) async {
        final res = await _carRepository.getCarDetails(carId);
        res.fold(
          (errMsg) => emit(CarDetailsState.getCarsDetailsError(errMsg)),
          (carDetails) {
            carDetailsData = carDetails;
            emit(CarDetailsState.getCarsDetailsSuccess(carId));
            if (AppConstants.driverFees == -1) {
              _carRepository.getDriverFees();
            }
          },
        );
      });
    } else {
      final res = await _carRepository.getCarDetails(carId);
      res.fold(
        (errMsg) => emit(CarDetailsState.getCarsDetailsError(errMsg)),
        (carDetails) {
          carDetailsData = carDetails;

          emit(CarDetailsState.getCarsDetailsSuccess(carId));
        },
      );
    }
  }

  Future<void> refreshCustomerData() async {
    emit(const CarDetailsState.refreshCustomerDataLoading());
    try {
      final res = await _authRepository.refreshCustomerData();
      res.fold(
        (errMsg) {
          emit(CarDetailsState.refreshCustomerDataError(errMsg));
        },
        (_) {
          emit(const CarDetailsState.refreshCustomerDataSuccess());
        },
      );
    } catch (e) {
      emit(CarDetailsState.refreshCustomerDataError(e.toString()));
    }
  }
}
