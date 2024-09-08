import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../../blocs/search/search_cubit.dart';
import '../../../../../core/helpers/dropdown_keys.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/default_buttons.dart';
import '../../../car_details/widgets/car_info.dart';
import 'car_brands_bottom_sheet.dart';

class CarBrandHeader extends StatelessWidget {
  const CarBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var searchCubitRead = context.read<SearchCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const HeaderWithIcon(
          title: "Car Brands",
          svgIconPath: 'assets/images/icons/car.svg',
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
          textColor: AppColors.primaryBlue,
          border: Border.all(color: AppColors.primaryBlue),
          color: AppColors.white,
        ),
      ],
    );
  }
}
