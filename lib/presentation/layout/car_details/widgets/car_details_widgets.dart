import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../blocs/car_details/car_details_cubit.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({
    super.key,
    required this.price,
    required this.period,
  });

  final num price;
  final String period;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      constraints: const BoxConstraints(
        maxWidth: 200,
      ),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(
          4,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$price SAR",
              style: AppFonts.sfPro16Black500,
            ),
            Text(
              "/$period",
              style: AppFonts.sfPro14Grey400,
            ),
          ],
        ),
      ),
    );
  }
}

class CarInfoItem extends StatelessWidget {
  const CarInfoItem({
    super.key,
    required this.title,
    required this.info,
    required this.iconPath,
  });

  final String title;
  final String info;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.carDetailsGrey,
          ),
          child: Image.asset(iconPath),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          "$title: ",
          style: AppFonts.sfPro14Grey400.copyWith(fontSize: 16),
        ),
        Text(
          info,
          style: AppFonts.sfPro16Black500,
        ),
      ],
    );
  }
}

class CarPricesRow extends StatelessWidget {
  const CarPricesRow({
    super.key,
    required this.blocWatch,
  });

  final CarDetailsCubit blocWatch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PriceCard(
            price: blocWatch.carDetailsData.carDailyPrice,
            period: "day",
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: PriceCard(
            price: blocWatch.carDetailsData.carWeaklyPrice,
            period: "weak",
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: PriceCard(
            price: blocWatch.carDetailsData.carMothlyPrice,
            period: "month",
          ),
        ),
      ],
    );
  }
}

class CarNameWithBrandImg extends StatelessWidget {
  const CarNameWithBrandImg({
    super.key,
    required this.carName,
    required this.brandImgUrl,
  });

  final String carName;
  final String brandImgUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              carName,
              style: AppFonts.sfPro22HeaderBlack700,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 8.0,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.white,
              child: CachedNetworkImage(
                imageUrl: getCompleteFileUrl(
                  brandImgUrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
