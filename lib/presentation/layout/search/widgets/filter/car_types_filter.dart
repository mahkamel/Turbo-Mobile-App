import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/helpers/dropdown_keys.dart';
import '../../../../../core/services/networking/repositories/car_repository.dart';
import '../icon_with_subtext.dart';

class CarTypesFilter extends StatelessWidget {
  const CarTypesFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        if (priceRangeKey.currentState != null) {
          if (priceRangeKey.currentState!.isOpen) {
            priceRangeKey.currentState!.closeBottomSheet();
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12.0,
          bottom: 24.0,
        ),
        child: BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (previous, current) =>
              current is GetSearchCarsTypesErrorState ||
              current is GetSearchCarsTypesLoadingState ||
              current is GetSearchCarsTypesSuccessState ||
              current is TypesSelectionState ||
              current is FilterResetState,
          builder: (context, state) {
            return state is GetSearchCarsTypesLoadingState ? const Center(child: CircularProgressIndicator(),):
            Wrap(
              runSpacing: 12,
              spacing: 8,
              children: List.generate(
                context.watch<CarRepository>().carTypes.length,
                (index) => GestureDetector(
                  onTap: () {
                    if (priceRangeKey.currentState != null) {
                      if (priceRangeKey.currentState!.isOpen) {
                        priceRangeKey.currentState!.closeBottomSheet();
                      }
                    }
                    searchCubitRead.carTypesSelection(index);
                  },
                  child: IconWithSubtext(
                    isSelected: context
                                .watch<CarRepository>()
                                .carTypes[index]
                                .isSelected,
                    subtext: context.watch<CarRepository>().carTypes[index].typeName,
                    iconPath: 'assets/images/icons/classA.svg',
                  )
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
