import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/services/networking/repositories/auth_repository.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  HomeCubit(this._authRepository) : super(const HomeState.initial());

  int selectedCategoryIndex = 0;

  void getCurrentUserLocation() async {
    await _authRepository.getCurrentUserLocation();
    emit(
      HomeState.getCurrentUserLocation(
        _authRepository.currentAddress ?? "",
      ),
    );
  }

  void changeCategoryIndex(int newIndex){
    emit(
      HomeState.getCurrentUserLocation(
        _authRepository.currentAddress ?? "",
      ),
    );
  }
}
