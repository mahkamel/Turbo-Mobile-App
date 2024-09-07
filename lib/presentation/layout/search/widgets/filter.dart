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
          const HeaderWithIcon(
            title: "Car Brands",
            svgIconPath: 'assets/images/icons/car.svg',
          ),
          const CarBrandsFilter(),
          const CarYearFilterHeader(),
          const SelectedCarYearsFilter(),
          const DailyPriceDropdown(),
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
          padding: const EdgeInsetsDirectional.only(top: 20),
          header: "Price",
          headerStyle:
              AppFonts.ibm18HeaderBlue600.copyWith(color: AppColors.lightBlack),
          widget: Column(
            children: [
              RangeSlider(
                // height: 36,
                // color: AppColors.green,
                values: RangeValues(
                  blocWatch.minDailyPrice,
                  blocWatch.maxDailyPrice,
                ),

                activeColor: AppColors.green,
                labels: RangeLabels(
                  blocWatch.minDailyPrice.toStringAsFixed(2),
                  blocWatch.maxDailyPrice == 2500
                      ? "+2500"
                      : blocWatch.maxDailyPrice.toStringAsFixed(2),
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
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 4.0, end: 0),
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

// String mapTypeToIcon() {

// }

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
