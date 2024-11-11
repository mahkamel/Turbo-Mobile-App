import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../../core/services/networking/repositories/auth_repository.dart';
import '../../../../../core/services/networking/repositories/cities_districts_repository.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';

class FilterHeader extends StatelessWidget {
  const FilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 28,
        bottom: 28,
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_sharp,
                color: AppColors.gold,
                size: 22,
              ),
              Text(
                "yourLocation".getLocale(context: context),
                style: AppFonts.ibm24HeaderBlue600
                    .copyWith(color: AppColors.lightBlack, fontSize: 22),
              ),
            ],
          ),
          Text(
            '  ${context.read<CitiesDistrictsRepository>().cities[context.watch<AuthRepository>().selectedCityIndex].cityName}, ${context.read<CitiesDistrictsRepository>().cities[context.watch<AuthRepository>().selectedCityIndex].branches[context.watch<AuthRepository>().selectedBranchIndex].branchName}',
            style: AppFonts.ibm18HeaderBlue600.copyWith(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
