import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/presentation/layout/home/widgets/recommended_car_card.dart';

import '../../../../models/get_cars_by_brands.dart';

class CarsByTypesListview extends StatelessWidget {
  const CarsByTypesListview({
    super.key,
    required this.carsByBrand,
    this.isFromFilter = false,
  });

  final List<CarData> carsByBrand;
  final bool isFromFilter;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: carsByBrand.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 16,
      ),
      itemBuilder: (context, typeIndex) {
        String carType = carsByBrand[typeIndex].carType;
        List<Car> cars = carsByBrand[typeIndex].cars;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
              ),
              child: Text(
                carType,
                style: AppFonts.ibm16TypeGreyHeader600,
              ),
            ),
            SizedBox(
              height: 225,
              width: AppConstants.screenWidth(context),
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
    );
  }
}
