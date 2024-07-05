import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/widgets/snackbar.dart';

import '../../../../blocs/search/search_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/dropdown_keys.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/custom_dropdown.dart';
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
            "Car Types",
            style: AppFonts.inter18HeaderBlack700,
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
                textColor: AppColors.primaryRed,
                fontWeight: FontWeight.w600,
                border: Border.all(color: AppColors.primaryRed),
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
          headerStyle: AppFonts.inter18HeaderBlack700,
          widget: CustomDropdown<int>(
            onTap: () {

            },
            border: Border.all(
              color: AppColors.black.withOpacity(0.5),
            ),
            paddingLeft: 0,
            key: priceRangeKey,
            paddingRight: 0,
            index: blocWatch.selectedFilterPriceRange,
            showText: false,
            listOfValues: const [
              "1-500",
              "500-1000",
              "1000-2000",
              "More than 2000",
            ],
            text: "Select Price Range",
            isCheckedBox: false,
            onChange: (_, int index) {
              blocRead.changePriceRangeIndex(index);
            },
            items: [
              "1-500",
              "500-1000",
              "1000-2000",
              "More than 2000",
            ]
                .map((element) => element)
                .toList()
                .asMap()
                .entries
                .map(
                  (item) => CustomDropdownItem(
                    key: UniqueKey(),
                    value: item.key,
                    child: Text(
                      item.value,
                      style: AppFonts.inter15Black400,
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
