import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/presentation/layout/home/widgets/recommended_car_card.dart';

import '../../../../core/theming/fonts.dart';
import '../../../../models/get_cars_by_brands.dart';

class CarsByTypesListview extends StatelessWidget {
  const CarsByTypesListview({
    super.key,
    required this.carsByBrand,
    this.isFromFilter = false,
  });

  final Map<String, List<Car>> carsByBrand;
  final bool isFromFilter;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (context.read<HomeCubit>().selectedBrandIndex == -1) {
          context.read<HomeCubit>().getCarsBasedOnBrand();
        } else {
          context.read<HomeCubit>().getCarsBasedOnBrand(
              brandId: context
                  .read<HomeCubit>()
                  .carBrands[context.read<HomeCubit>().selectedBrandIndex]
                  .id);
        }
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: carsByBrand.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
        itemBuilder: (context, typeIndex) {
          String carType = carsByBrand.keys.toList()[typeIndex];
          List<Car> cars = carsByBrand.values.toList()[typeIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                ),
                child: Text(
                  carType,
                  style: AppFonts.inter16TypeGreyHeader600,
                ),
              ),
              SizedBox(
                height: 232,
                child: ListView.separated(
                  itemCount: cars.length,
                  padding: const EdgeInsetsDirectional.only(
                    start: 16,
                    end: 16,
                    top: 8,
                  ),
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 16,
                  ),
                  itemBuilder: (context, index) => RecommendedCarCard(
                    isFromFilter: cars.length == 1,
                    car: cars[index],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
