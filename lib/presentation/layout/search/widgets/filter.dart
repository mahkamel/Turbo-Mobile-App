import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_slider/flutter_multi_slider.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/filter_by_list.dart';

import '../../../../blocs/search/search_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/dropdown_keys.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/widget_with_header.dart';
import 'filter/car_brand_filter.dart';
import 'filter/car_types_filter.dart';
import 'filter/car_year_filter.dart';

class FilterCars extends StatelessWidget {
  const FilterCars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        if (priceRangeKey.currentState != null) {
          if (priceRangeKey.currentState!.isOpen) {
            priceRangeKey.currentState!.closeBottomSheet();
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Car Categories",
            style: AppFonts.ibm18HeaderBlue600,
          ),
          const CarCategoriesFilter(),
          Text(
            "Car Types",
            style: AppFonts.ibm18HeaderBlue600,
          ),
          const CarTypesFilter(),
          const CarBrandFilterHeader(),
          const SelectedCarBrandFilter(),
          const SizedBox(
            height: 24,
          ),
          const CarYearFilterHeader(),
          const SelectedCarYearsFilter(),
          const DailyPriceDropdown(),
          // Text(
          //   "Additional Services",
          //   style: AppFonts.inter18HeaderBlack700,
          // ),
          // const SizedBox(
          //   height: 4,
          // ),
          // const UnlimitedKMCheckbox(),
          const Spacer(),
          const FilterButtonsRow(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class FilterButtonsRow extends StatelessWidget {
  const FilterButtonsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return SizedBox(
      height: 48,
      width: AppConstants.screenWidth(context),
      child: Row(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            onTap: () {
              if (priceRangeKey.currentState != null) {
                if (priceRangeKey.currentState!.isOpen) {
                  priceRangeKey.currentState!.closeBottomSheet();
                }
              }
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
            child: BlocListener<SearchCubit, SearchState>(
              listenWhen: (previous, current) =>
                  current is GetFilteredCarsErrorState,
              listener: (context, state) {
                if (state is GetFilteredCarsErrorState) {
                  defaultErrorSnackBar(
                    context: context,
                    message: state.errMsg,
                  );
                }
              },
              child: DefaultButton(
                marginTop: 0,
                height: 48,
                function: () {
                  if (priceRangeKey.currentState != null) {
                    if (priceRangeKey.currentState!.isOpen) {
                      priceRangeKey.currentState!.closeBottomSheet();
                    }
                  }
                  searchCubitRead.applyFilter();
                },
                borderRadius: 8,
                color: AppColors.white,
                textColor: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
                border: Border.all(color: AppColors.primaryBlue),
                text: "View Results",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyPriceDropdown extends StatelessWidget {
  const DailyPriceDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) =>
          current is ChangeSelectedPriceRangeIndexState,
      builder: (context, state) {
        var blocRead = context.read<SearchCubit>();
        var blocWatch = context.watch<SearchCubit>();
        return WidgetWithHeader(
          padding: const EdgeInsetsDirectional.only(top: 24),
          header: "Daily Price",
          headerStyle: AppFonts.ibm18HeaderBlue600,
          widget: Column(
            children: [
              MultiSlider(
                height: 36,
                divisions: 10,
                horizontalPadding: 8,
                indicator: (value) {
                  return const IndicatorOptions(draw: false);
                },
                selectedIndicator: (value) {
                  return IndicatorOptions(
                    formatter: (value) {
                      if (value == 2500) {
                        return "+2500";
                      } else {
                        return value.toStringAsFixed(0);
                      }
                    },
                  );
                },
                values: [
                  blocWatch.minDailyPrice,
                  blocWatch.maxDailyPrice,
                ],
                min: 1,
                max: 2500,
                onChanged: (value) {
                  blocRead.changePriceRangeIndex(min: value[0], max: value[1]);
                },
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 4.0 , end: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("1"),
                    Text("+2500"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
