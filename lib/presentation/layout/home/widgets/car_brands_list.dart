import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/networking/repositories/car_repository.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class CarBrandsList extends StatelessWidget {
  const CarBrandsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          height: 40,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
              color: index == 0 ? AppColors.black950 : AppColors.white,
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.black950,
              )),
          child: Center(
            child: Text(
              index == 0
                  ? "All"
                  : context
                      .read<CarRepository>()
                      .carBrands[index - 1]
                      .brandName,
              style: AppFonts.sfPro16Black500.copyWith(
                color: index == 0 ? AppColors.white : AppColors.black950,
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(
          width: 16,
        ),
        itemCount: context.read<CarRepository>().carBrands.length + 1,
      ),
    );
  }
}
