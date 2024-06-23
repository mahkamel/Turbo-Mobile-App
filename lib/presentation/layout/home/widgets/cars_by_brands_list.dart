import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/presentation/layout/home/widgets/recommended_car_card.dart';

import '../../../../core/theming/fonts.dart';
import '../../../../models/get_cars_by_brands.dart';

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
          current is GetCarsByBrandSuccessState,
      builder: (context, state) {
        var blocWatch = context.watch<HomeCubit>();
        var blocRead = context.read<HomeCubit>();
        return state is GetCarsByBrandLoadingState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : blocWatch.carsByBrand.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 48),
                    child: Text(
                      "Based on your current selection, there are no available vehicles in our inventory at this time.",
                      textAlign: TextAlign.center,
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: blocWatch.carsByBrand.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      itemBuilder: (context, typeIndex) {
                        String carType =
                            blocWatch.carsByBrand.keys.toList()[typeIndex];
                        List<Car> cars =
                            blocWatch.carsByBrand.values.toList()[typeIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 16,
                              ),
                              child: Text(
                                carType,
                                style: AppFonts.sfPro16TypeGreyHeader600,
                              ),
                            ),
                            SizedBox(
                              height: 232,
                              child: ListView.separated(
                                itemCount: cars.length,
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 8,
                                ),
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 16,
                                ),
                                itemBuilder: (context, index) =>
                                    RecommendedCarCard(
                                  car: cars[index],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
      },
    );
  }
}
