import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/car_details/car_details_cubit.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../models/car_details_model.dart';

class AvailableColorsHeader extends StatelessWidget {
  const AvailableColorsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.gold),
            child: const Icon(
              Icons.color_lens,
              color: AppColors.white,
              size: 18,
            )),
        const SizedBox(
          width: 10,
        ),
        Text(
          "available Colors".getLocale(context: context),
          style: AppFonts.ibm18HeaderBlue600.copyWith(
            color: AppColors.lightBlack,
          ),
        ),
      ],
    );
  }
}

class CarColorsList extends StatelessWidget {
  const CarColorsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<CarColor> colors =
        context.read<CarDetailsCubit>().carDetailsData.carColor;

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 29.0,
        end: 16.0,
        bottom: 30,
        top: 10,
      ),
      child: Wrap(
        spacing: 5,
        children: [
          ...List.generate(
              colors.length,
              (index) => Container(
                    height: 23,
                    width: 23,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors[index].color,
                        border: Border.all(color: AppColors.black, width: 0.2)),
                  ))
        ],
      ),
    );
  }
}
