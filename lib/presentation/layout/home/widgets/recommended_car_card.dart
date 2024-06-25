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
          horizontal: isFromFilter ? 16 : 12,
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
                bottom: 2.0,
              ),
              child: _buildBrandAndYearRow(),
            ),
            Text(
              car.carName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.inter16Black500,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text.rich(
                TextSpan(
                  text: "${car.carDailyPrice} SAR",
                  style: AppFonts.inter16Black500.copyWith(
                      color: AppColors.primaryRed, fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: "/day",
                      style: AppFonts.inter14Black400
                          .copyWith(color: AppColors.grey400, fontSize: 16),
                    ),
                  ],
                ),
              ),
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
            child: CachedNetworkImage(
              imageUrl: getCompleteFileUrl(
                car.carBrand.first.path,
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            car.carBrand.first.display,
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
      child: Container(
        width: double.infinity,
        height: 124,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.black800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CachedNetworkImage(
          imageUrl: car.carImg,
          fit: BoxFit.cover,
          placeholder: (context, url) => const SizedBox(
            height: 40,
            width: 40,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
