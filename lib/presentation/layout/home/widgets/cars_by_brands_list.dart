import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';

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
        return state is GetCarsByBrandLoadingState ||
                state is GetCarsBrandsLoadingState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : blocWatch.carsByBrand.isEmpty
                ?  Padding(
                    padding:const EdgeInsetsDirectional.only(
                      start: 16.0,
                      end: 16.0,
                      top: 48,
                    ),
                    child: Text(
                      "noCarsBasedOnBrand".getLocale(),
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
