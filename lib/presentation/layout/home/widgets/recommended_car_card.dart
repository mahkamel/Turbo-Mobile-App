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
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: isFromFilter ? 14 : 12,
        ),
        margin: const EdgeInsets.only(bottom: 4),
        constraints: !isFromFilter
            ? const BoxConstraints(
                maxWidth: 300,
              )
            : null,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                offset: const Offset(0, 3),
                blurRadius: 8,
                spreadRadius: 0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _carImage(),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 4.0,
              ),
              child: _buildBrandAndYearRow(),
            ),
            Text(
              car.model.modelName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.inter16Black500,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: car.color,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "${car.carDailyPrice} ${"SAR".getLocale()}",
                    style: AppFonts.inter16Black500.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: "/${"daySmall".getLocale()}",
                        style: AppFonts.inter14Black400
                            .copyWith(color: AppColors.grey400, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildBrandAndYearRow() {
    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          margin: const EdgeInsetsDirectional.only(end: 2),
          decoration: const BoxDecoration(
            color: AppColors.carCardGrey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.network(
               getCompleteFileUrl(
                car.brand.brandPath,
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            car.brand.brandName,
            style: AppFonts.inter14Black400,
          ),
        ),
        const CircleAvatar(
          backgroundColor: AppColors.grey600,
          radius: 2,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          car.carYear,
          style: AppFonts.inter14Black400,
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
