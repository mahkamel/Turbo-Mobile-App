import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/presentation/layout/home/widgets/home_header.dart';

import '../../../core/theming/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> carCat = [
      "Class A",
      "Class B",
      "Class C",
    ];
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 20.0,
        start: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 40,
            width: AppConstants.screenWidth(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.black,
                    )),
                child: Center(
                  child: Text(
                    carCat[index],
                    style: AppFonts.sfPro16Black500.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                width: 16,
              ),
              itemCount: carCat.length,
            ),
          )
        ],
      ),
    );
  }
}
