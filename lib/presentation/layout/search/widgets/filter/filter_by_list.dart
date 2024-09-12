import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/services/networking/repositories/car_repository.dart';
import '../icon_with_subtext.dart';

class CarCategoriesFilter extends StatelessWidget {
  const CarCategoriesFilter({super.key});
  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20.0,
      ),
      child: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) =>
            current is GetCarsCategoriesLoadingState ||
            current is GetCarsCategoriesSuccessState ||
            current is GetCarsCategoriesErrorState ||
            current is CategoriesSelectionState ||
            current is FilterResetState,
        builder: (context, state) {
          return state is GetCarsCategoriesLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Wrap(
                  runSpacing: 14,
                  spacing: 10,
                  children: List.generate(
                    context.watch<CarRepository>().carCategories.length,
                    (index) => GestureDetector(
                        onTap: () {
                          searchCubitRead.carCategoriesSelection(index);
                        },
                        child: IconWithSubtext(
                          maxWidth: 80,
                          isSelected: context
                              .watch<CarRepository>()
                              .carCategories[index]
                              .isSelected,
                          innerText: context
                              .watch<CarRepository>()
                              .carCategories[index]
                              .categoryName,
                          subtext: context
                              .watch<CarRepository>()
                              .carCategories[index]
                              .categoryName,
                        )),
                  ),
                );
        },
      ),
    );
  }
}
