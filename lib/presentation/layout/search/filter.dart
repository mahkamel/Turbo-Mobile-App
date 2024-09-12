import 'package:flutter/material.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/car_brand_header.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/filter_actions_buttons.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/filter_by_list.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/prices_filter.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';
import '../car_details/widgets/car_info.dart';
import 'widgets/filter/car_brand_filter.dart';
import 'widgets/filter/car_types_filter.dart';
import 'widgets/filter/car_year_filter.dart';

class FilterCars extends StatelessWidget {
  const FilterCars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWithIcon(
                title: "Car Categories",
                svgIconPath: 'assets/images/icons/car.svg',
              ),
              const CarCategoriesFilter(),
              Text(
                "Car Types",
                style: AppFonts.ibm18HeaderBlue600
                    .copyWith(color: AppColors.lightBlack),
              ),
              const CarTypesFilter(),
              const CarBrandHeader(),
            ],
          ),
        ),
        const CarBrandsFilter(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarYearFilterHeader(),
              SelectedCarYearsFilter(),
              DailyPriceSlider(),
              ResetBtn(),
              FilterResultsBtn(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
