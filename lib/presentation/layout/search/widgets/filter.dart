import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_slider/flutter_multi_slider.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/car_brand_header.dart';
import 'package:turbo/presentation/layout/search/widgets/filter/filter_by_list.dart';
import '../../../../blocs/search/search_cubit.dart';
import '../../../../core/helpers/dropdown_keys.dart';
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
                DailyPriceDropdown(),
                ResetBtn(),
                FilterResultsBtn(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
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
        if (priceRangeKey.currentState != null) {
          if (priceRangeKey.currentState!.isOpen) {
            priceRangeKey.currentState!.closeBottomSheet();
          }
        }
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
        borderRadius: 20,
        color: AppColors.primaryBlue,
        textColor: AppColors.white,
        border: Border.all(color: AppColors.primaryBlue),
        text: "View Results",
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
                    '\$${blocWatch.minDailyPrice.toStringAsFixed(2)}',
                    blocWatch.maxDailyPrice == 2500
                        ? "\$+2500"
                        : '\$${blocWatch.maxDailyPrice.toStringAsFixed(2)}',
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
          codeTextField(
              width: 145,
              maxNumbers: 8,
              isMoney: true,
              context: context,
              onChange: (value) {},
              onTapOutside: (value) {
                blocRead.validateMinPrice();
              },
              controller: blocRead.minPriceController,
              node: FocusNode(),
              onSubmit: (value) {
                blocRead.validateMinPrice();
              }),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 2,
            width: 13,
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle, color: AppColors.grey),
          ),
          codeTextField(
              width: 145,
              context: context,
              maxNumbers: 8,
              onChange: (value) {},
              isMoney: true,
              onTapOutside: (value) {
                blocRead.validateMaxPrice();
              },
              controller: blocRead.maxPriceController,
              node: FocusNode(),
              onSubmit: (value) {
                blocRead.validateMaxPrice();
              }),
        ],
      ),
    );
  }
}

class CustomIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green // Set your desired color
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Start from the top left
    path.moveTo(0, size.height * 0.5);

    // Draw lines to form the desired shape (similar to SVG path)
    path.lineTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.5, 0); // Pointy part in the middle
    path.lineTo(size.width * 0.75, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5);

    // Complete the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomIndicatorOptions extends IndicatorOptions {
  final CustomPainter? customPainter;

  CustomIndicatorOptions({
    super.draw,
    double size = 40.0,
    String Function(double value)? formatter,
    this.customPainter,
  }) : super();
}
