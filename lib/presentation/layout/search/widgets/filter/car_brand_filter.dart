import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/helpers/dropdown_keys.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/default_buttons.dart';
import '../../../home/widgets/car_brands_list.dart';
import '../car_brands_bottom_sheet.dart';
import '../delete_icon.dart';

class SelectedCarBrandFilter extends StatelessWidget {
  const SelectedCarBrandFilter({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) =>
      current is BrandsSelectionState ||
          current is FilterResetState,
      builder: (context, state) {
        var searchCubitWatch = context.watch<SearchCubit>();
        return Padding(
          padding: EdgeInsets.only(
            top: searchCubitWatch.selectedBrands.isNotEmpty
                ? 4.0
                : 0.0,
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              searchCubitWatch.selectedBrands.length,
                  (index) => InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  if (priceRangeKey.currentState != null) {
                    if (priceRangeKey.currentState!.isOpen) {
                      priceRangeKey.currentState!.closeBottomSheet();
                    }
                  }
                  searchCubitRead.unSelectTheCarBrand(
                    searchCubitRead.selectedBrands[index],
                  );
                },
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BrandLogoCircle(
                          logoPath: searchCubitWatch
                              .selectedBrands[index].path,
                          size: 50,
                        ),
                      ),
                      const DeleteIcon(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CarBrandFilterHeader extends StatelessWidget {
  const CarBrandFilterHeader({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "carBrand".getLocale(context: context),
          style: AppFonts.inter18HeaderBlack700,
        ),
        DefaultButton(
          height: 30,
          width: 72,
          text: "browse".getLocale(context: context),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          function: () {
            if (priceRangeKey.currentState != null) {
              if (priceRangeKey.currentState!.isOpen) {
                priceRangeKey.currentState!.closeBottomSheet();
              }
            }
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (bsContext) => BlocProvider.value(
                value: searchCubitRead..getCarsBrands(),
                child: const CarBrandsBottomSheet(),
              ),
            );
          },
          textColor: AppColors.primaryRed,
          border: Border.all(color: AppColors.primaryRed),
          color: AppColors.white,
        ),
      ],
    );
  }
}
