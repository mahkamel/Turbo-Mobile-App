import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/services/networking/repositories/car_repository.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';

class CarTypesFilter extends StatelessWidget {
  const CarTypesFilter({
    super.key,
    required this.searchCubitRead,
  });

  final SearchCubit searchCubitRead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0 , bottom: 24.0,),
      child: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) =>
        current is GetSearchCarsTypesErrorState ||
            current is GetSearchCarsTypesLoadingState ||
            current is GetSearchCarsTypesSuccessState ||
            current is TypesSelectionState ||
            current is FilterResetState,
        builder: (context, state) {
          return Wrap(
            runSpacing: 12,
            spacing: 8,
            children: List.generate(
              context.watch<CarRepository>().carTypes.length,
                  (index) => GestureDetector(
                onTap: () {
                  searchCubitRead.carTypesSelection(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context
                          .watch<CarRepository>()
                          .carTypes[index]
                          .isSelected
                          ? AppColors.black
                          : AppColors.white,
                      border: Border.all(color: AppColors.black)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    context
                        .watch<CarRepository>()
                        .carTypes[index]
                        .typeName,
                    style: AppFonts.inter14HeaderBlack400.copyWith(
                      fontWeight: context
                          .watch<CarRepository>()
                          .carTypes[index]
                          .isSelected
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: context
                          .watch<CarRepository>()
                          .carTypes[index]
                          .isSelected
                          ? AppColors.white
                          : AppColors.headerBlack,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
