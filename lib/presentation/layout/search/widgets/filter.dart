import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/car_brand_header.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/filter_by_list.dart';
import '../../../../blocs/search/search_cubit.dart';
import '../../../../core/helpers/enums.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/custom_text_fields.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/widget_with_header.dart';
import '../../car_details/widgets/car_info.dart';
import 'filter/car_brand_filter.dart';
import 'filter/car_types_filter.dart';
import 'filter/car_year_filter.dart';

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

class ResetBtn extends StatelessWidget {
  const ResetBtn({super.key});

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return DefaultButton(
      marginBottom: 59,
      width: 102,
      height: 42,
      function: () {
        searchCubitRead.resetSearch();
      },
      borderRadius: 20,
      color: AppColors.white,
      textColor: AppColors.gold,
      fontWeight: FontWeight.w600,
      border: Border.all(color: AppColors.gold),
      text: "Reset All",
    );
  }
}

class FilterResultsBtn extends StatelessWidget {
  const FilterResultsBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return BlocListener<SearchCubit, SearchState>(
      listenWhen: (previous, current) => current is GetFilteredCarsErrorState,
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
          searchCubitRead.applyFilter();
        },
        borderRadius: 20,
        color: AppColors.primaryBlue,
        textColor: AppColors.white,
        border: Border.all(color: AppColors.primaryBlue),
        text: "View Results",
      ),
    );
  }
}

class DailyPriceSlider extends StatelessWidget {
  const DailyPriceSlider({
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
          padding: const EdgeInsetsDirectional.only(top: 20),
          header: "Price",
          headerStyle:
              AppFonts.ibm18HeaderBlue600.copyWith(color: AppColors.lightBlack),
          widget: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  valueIndicatorColor: AppColors.green,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20.0),
                ),
                child: RangeSlider(
                  values: RangeValues(
                    blocWatch.minDailyPrice,
                    blocWatch.maxDailyPrice,
                  ),
                  activeColor: AppColors.green,
                  labels: RangeLabels(
                    '${blocWatch.minDailyPrice.toStringAsFixed(2)} SAR',
                    blocWatch.maxDailyPrice == 2500
                        ? "+2500 SAR"
                        : '${blocWatch.maxDailyPrice.toStringAsFixed(2)} SAR',
                  ),
                  divisions: 10,
                  inactiveColor: AppColors.unSelectedRange,
                  min: 1,
                  max: 2500,
                  onChanged: (value) {
                    blocRead.changePriceRangeIndex(
                      min: value.start,
                      max: value.end,
                    );
                  },
                ),
              ),
              const PriceBox(),
            ],
          ),
        );
      },
    );
  }
}

class PriceBox extends StatelessWidget {
  const PriceBox({super.key});

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<SearchCubit>();
    blocRead.minPriceController.text = '${blocRead.minDailyPrice}';
    blocRead.maxPriceController.text = '${blocRead.maxDailyPrice}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        children: [
          CustomTextField(
              width: (AppConstants.screenWidth(context) - 66) / 2,
              validationState: TextFieldValidation.normal,
              textInputAction: TextInputAction.done,
              textInputType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: true,
              ),
              hint: "Min Price",
              icon: const Padding(
                padding: EdgeInsets.only(top: 14.0),
                child: Text("SAR"),
              ),
              onChange: (value) {},
              onTapOutside: (value) {
                blocRead.validateMinPrice();
              },
              inputFormatters: [
                DecimalInputFormatter(),
              ],
              textEditingController: blocRead.minPriceController,
              radius: 3,
              onSubmit: (value) {
                blocRead.validateMinPrice();
              }),
          const SizedBox(
            height: 2,
            width: 26,
            child: Divider(
              indent: 6,
              endIndent: 6,
              color: AppColors.grey,
              thickness: 2,
            ),
          ),
          CustomTextField(
              width: (AppConstants.screenWidth(context) - 66) / 2,
              radius: 3,
              validationState: TextFieldValidation.normal,
              textInputAction: TextInputAction.done,
              textInputType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: true,
              ),
              hint: "Max Price",
              inputFormatters: [
                DecimalInputFormatter(),
              ],
              icon: const Padding(
                padding: EdgeInsets.only(top: 14.0),
                child: Text("SAR"),
              ),
              onChange: (value) {},
              onTapOutside: (value) {
                blocRead.validateMaxPrice();
              },
              textEditingController: blocRead.maxPriceController,
              onSubmit: (value) {
                blocRead.validateMaxPrice();
              }),
        ],
      ),
    );
  }
}
