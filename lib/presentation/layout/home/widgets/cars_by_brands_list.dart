import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';

import 'cars_by_types_listview.dart';

class CarsByBrandsList extends StatelessWidget {
  const CarsByBrandsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is GetCarsByBrandErrorState ||
          current is GetCarsByBrandLoadingState ||
          current is GetCarsBrandsLoadingState ||
          current is GetCarsByBrandSuccessState,
      builder: (context, state) {
        var blocWatch = context.watch<HomeCubit>();
        var blocRead = context.read<HomeCubit>();
        return state is GetCarsByBrandLoadingState ||
                state is GetCarsBrandsLoadingState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : blocWatch.carsByBrand.isEmpty
                ? const Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 16.0,
                      end: 16.0,
                      top: 48,
                    ),
                    child: Text(
                      "Based on your current selection, there are no available vehicles in our inventory at this time.",
                      textAlign: TextAlign.center,
                    ),
                  )
                : Expanded(
                    child: CarsByTypesListview(
                      carsByBrand: blocWatch.carsByBrand,
                    ),
                  );
      },
    );
  }
}
