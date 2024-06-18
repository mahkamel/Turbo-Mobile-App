import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';

part 'car_details_state.dart';
part 'car_details_cubit.freezed.dart';

class CarDetailsCubit extends Cubit<CarDetailsState> {
  final CarRepository _carRepository;
  CarDetailsCubit(this._carRepository) : super(const CarDetailsState.initial());
}
