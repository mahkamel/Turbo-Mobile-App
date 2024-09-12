import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/helpers/constants.dart';
import '../../../../../core/helpers/enums.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/custom_text_fields.dart';
import '../../../../../core/widgets/widget_with_header.dart';

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
