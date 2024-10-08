import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/services/networking/repositories/car_repository.dart';
import '../icon_with_subtext.dart';

class CarTypesFilter extends StatelessWidget {
  const CarTypesFilter({
    super.key,
  });

  String getCarTypeImagePath(String typeName) {
    switch(typeName) {
      case "Sidan":
        return 'assets/images/icons/sedan.svg';
      case "SUV":
        return "assets/images/icons/suv.svg";
      case "4*4":
        return 'assets/images/icons/fourByFour.svg';
      default:
        return 'assets/images/icons/sedan.svg';
    }
  }

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
                  searchCubitRead.carTypesSelection(index);
                },
                child: IconWithSubtext(
                  isSelected: context
                              .watch<CarRepository>()
                              .carTypes[index]
                              .isSelected,
                  subtext: context.watch<CarRepository>().carTypes[index].typeName,
                  iconPath: getCarTypeImagePath(context
                              .watch<CarRepository>()
                              .carTypes[index].typeName),
                )
              ),
            ),
          );
        },
      ),
    );
  }
}
