import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/models/get_cars_by_brands.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/routing/screens_arguments.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import 'car_image.dart';

class RecommendedCarCard extends StatelessWidget {
  const RecommendedCarCard({
    super.key,
    required this.car,
    required this.isFromFilter,
  });

  final Car car;
  final bool isFromFilter;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        context.pushNamed(
          Routes.carDetailsScreen,
          arguments: CardDetailsScreenArguments(
            car: car,
          ),
        );
      },
      child: Container(
        width: isFromFilter
            ? AppConstants.screenWidth(context) - 32
            : AppConstants.screenWidth(context) * 0.8,
        // padding: EdgeInsets.symmetric(
        //   vertical: 8,
        //   horizontal: isFromFilter ? 14 : 12,
        // ),
        margin: const EdgeInsets.only(bottom: 4),
        constraints: !isFromFilter
            ? const BoxConstraints(
                maxWidth: 300,
              )
            : null,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                _carImage(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildBrandAndYearRow(),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(right: 21.0, left: 18, top: 7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.model.modelName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.ibm16PrimaryHeader400,
                          ),
                          Text(
                            car.carYear,
                            style: AppFonts.ibm11Grey400,
                          ),
                        ],
                      ),
                      Text.rich(
                      TextSpan(
                        text:
                            "SAR".getLocale(context: context),
                        style: AppFonts.ibm11Grey400,
                        children: [
                          TextSpan(
                            text: " ${car.carDailyPrice}",
                            style: AppFonts.ibm15LightBlack400.copyWith(
                            fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: "/${"dayCapital".getLocale(context: context)}",
                            style: AppFonts.ibm11Grey400
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                  const Divider(color: AppColors.divider,),
                ],
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "available Colors".getLocale(context: context),
                    style: AppFonts.ibm11Grey400.copyWith(
                      color: AppColors.secondary
                    ),
                  ),
                  const SizedBox(height: 6,),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: car.color,
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandAndYearRow() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX:2, sigmaY:2),
        child: Container(
          height: 27,
          // width: 75,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10 , vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.typeGreyHeader.withOpacity(0.5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                getCompleteFileUrl(
                  car.brand.brandPath,
                ),
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  car.brand.brandName,
                  style: AppFonts.ibm10White600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Hero _carImage() {
    return Hero(
      tag: car.carId,
      child: CarImage(
        carImgPath: car.media.mediaMediumImageUrl,
      ),
    );
  }
}
