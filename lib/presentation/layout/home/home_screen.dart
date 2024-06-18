import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/screens_arguments.dart';
import 'package:turbo/presentation/layout/home/widgets/car_brands_list.dart';
import 'package:turbo/presentation/layout/home/widgets/home_header.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.only(
            top: 20.0,
            start: 16,
            end: 16,
          ),
          child: HomeHeader(),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 30.0,
            bottom: 8.0,
            start: 16,
          ),
          child: Text(
            "Brands",
            style: AppFonts.sfPro18HeaderBlack700,
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.only(
            start: 16,
          ),
          child: CarBrandsList(),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 16,
            bottom: 8,
            start: 16,
          ),
          child: Text(
            "Recommended Cars",
            style: AppFonts.sfPro18HeaderBlack700,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 16,
          ),
          child: Text(
            "Sedan",
            style: AppFonts.sfPro16TypeGreyHeader600,
          ),
        ),
        SizedBox(
          height: 234,
          child: ListView.separated(
            itemCount: 3,
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
            ),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(
              width: 16,
            ),
            itemBuilder: (context, index) => InkWell(
              highlightColor: Colors.transparent,
              onTap: () {
                context.pushNamed(
                  Routes.carDetailsScreen,
                  arguments: CardDetailsScreenArguments(
                    carId: "carId",
                    carImageUrl: "imageUrl",
                  ),
                );
              },
              child: Container(
                width: AppConstants.screenWidth(context) * 0.8,
                height: 224,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                decoration: BoxDecoration(
                  color: AppColors.carCardGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "carId",
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.black800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 10,
                            foregroundColor: AppColors.grey400,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              "Brand",
                              style: AppFonts.sfPro14Black400,
                            ),
                          ),
                          Text(
                            "Year",
                            style: AppFonts.sfPro14Black400,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Maserati 867",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.sfPro16Black500,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text.rich(
                        TextSpan(
                          text: "30 SAR",
                          style: AppFonts.sfPro16Black500.copyWith(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(
                              text: "/day",
                              style: AppFonts.sfPro14Black400.copyWith(
                                  color: AppColors.grey400, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
