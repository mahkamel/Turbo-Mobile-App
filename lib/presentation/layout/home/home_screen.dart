import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/presentation/layout/home/widgets/car_brands_list.dart';
import 'package:turbo/presentation/layout/home/widgets/cars_by_brands_list.dart';
import 'package:turbo/presentation/layout/home/widgets/home_header.dart';

import '../../../core/theming/fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.only(
            top: 20.0,
            start: 16,
            end: 16,
          ),
          child: HomeHeader(),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 20.0,
            bottom: 8.0,
            start: 16,
          ),
          child: Text(
            "brands".getLocale(),
            style: AppFonts.inter18HeaderBlack700,
          ),
        ),
        const BrandsList(),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 16,
            bottom: 8,
            start: 16,
          ),
          child: Text(
            "recommendedCars".getLocale(),
            style: AppFonts.inter18HeaderBlack700,
          ),
        ),
        const CarsByBrandsList(),
      ],
    );
  }
}
