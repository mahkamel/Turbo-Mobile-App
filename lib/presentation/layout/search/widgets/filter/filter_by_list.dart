import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/helpers/dropdown_keys.dart';
import '../../../../../core/services/networking/repositories/car_repository.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';

class CarCategoriesFilter extends StatelessWidget {
  const CarCategoriesFilter({super.key});
   @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 24.0,
      ),
      child: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) =>
            current is GetCarsCategoriesLoadingState ||
            current is GetCarsCategoriesSuccessState ||
            current is GetCarsCategoriesErrorState ||
            current is CategoriesSelectionState ||
            current is FilterResetState,
        builder: (context, state) {
          return state is GetCarsCategoriesLoadingState ? const Center(child: CircularProgressIndicator(),):
          Wrap(
            runSpacing: 12,
            spacing: 8,
            children: List.generate(
              context.watch<CarRepository>().carCategories.length,
              (index) => GestureDetector(
                onTap: () {
                  if (priceRangeKey.currentState != null) {
                    if (priceRangeKey.currentState!.isOpen) {
                      priceRangeKey.currentState!.closeBottomSheet();
                    }
                  }
                  searchCubitRead.carCategoriesSelection(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context
                              .watch<CarRepository>()
                              .carCategories[index]
                              .isSelected
                          ? AppColors.black
                          : AppColors.white,
                      border: Border.all(color: AppColors.black)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    context.watch<CarRepository>().carCategories[index].categoryName,
                    style: AppFonts.inter14HeaderBlack400.copyWith(
                      fontWeight: context
                              .watch<CarRepository>()
                              .carCategories[index]
                              .isSelected
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: context
                              .watch<CarRepository>()
                              .carCategories[index]
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