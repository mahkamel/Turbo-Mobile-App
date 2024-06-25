import 'package:flutter/material.dart';

import '../../../../blocs/search/search_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_buttons.dart';
import 'filter/car_brand_filter.dart';
import 'filter/car_types_filter.dart';
import 'filter/car_year_filter.dart';
import 'filter/unlimited_km_checkbox.dart';

class FilterCars extends StatelessWidget {
  const FilterCars({
    super.key,
    required this.searchCubitRead,
  });

  final SearchCubit searchCubitRead;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Car Types",
          style: AppFonts.inter18HeaderBlack700,
        ),
        CarTypesFilter(searchCubitRead: searchCubitRead),
        CarBrandFilterHeader(searchCubitRead: searchCubitRead),
        SelectedCarBrandFilter(searchCubitRead: searchCubitRead),
        const SizedBox(
          height: 24,
        ),
        CarYearFilterHeader(searchCubitRead: searchCubitRead),
        SelectedCarYearsFilter(searchCubitRead: searchCubitRead),
        const SizedBox(
          height: 24,
        ),
        Text(
          "Additional Services",
          style: AppFonts.inter18HeaderBlack700,
        ),
        const SizedBox(
          height: 4,
        ),
        const UnlimitedKMCheckbox(),
        const Spacer(),
        SizedBox(
          height: 48,
          width: AppConstants.screenWidth(context),
          child: Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  searchCubitRead.resetSearch();
                },
                child: SizedBox(
                  height: 48,
                  width: 85,
                  child: Center(
                    child: Text(
                      "Reset all",
                      textAlign: TextAlign.center,
                      style: AppFonts.inter14HeaderBlack400.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DefaultButton(
                  marginTop: 0,
                  height: 48,
                  function: () {
                    searchCubitRead.applyFilter();
                  },
                  borderRadius: 8,
                  color: AppColors.white,
                  textColor: AppColors.primaryRed,
                  fontWeight: FontWeight.w600,
                  border: Border.all(color: AppColors.primaryRed),
                  text: "View Results",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}




