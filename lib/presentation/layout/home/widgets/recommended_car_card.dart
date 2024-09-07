import 'package:cached_network_image/cached_network_image.dart';
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
            _carImage(),
            Padding(
              padding: const EdgeInsets.only(
                right: 21.0,
                left: 18,
                top: 7,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        car.model.modelName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.ibm16PrimaryBlue400,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        car.carYear,
                        style: AppFonts.ibm11Grey400,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBrandAndYearRow(),
                        Text.rich(
                          TextSpan(
                            text: "SAR".getLocale(context: context),
                            style: AppFonts.ibm11Grey400,
                            children: [
                              TextSpan(
                                text: " ${car.carDailyPrice}",
                                style: AppFonts.ibm24HeaderBlue600
                                    .copyWith(color: AppColors.gold),
                              ),
                              TextSpan(
                                  text:
                                      "/${"dayCapital".getLocale(context: context)}",
                                  style: AppFonts.ibm11Grey400),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandAndYearRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedNetworkImage(
          height: 27,
          imageUrl: getCompleteFileUrl(
            car.brand.brandPath,
          ),
          errorWidget: (context, error, stackTrace) => const SizedBox(),
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            car.brand.brandName,
            style: AppFonts.ibm12SubTextGrey600
                .copyWith(color: AppColors.lightBlack),
          ),
        ),
      ],
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
