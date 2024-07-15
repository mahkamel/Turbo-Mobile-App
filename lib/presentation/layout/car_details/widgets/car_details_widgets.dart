import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/car_details/car_details_cubit.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class PriceCard extends StatelessWidget {
  const  PriceCard({
    super.key,
    required this.price,
    required this.period,
  });

  final num price;
  final String period;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${period == "day" ? "Daily" : period == "week" ? "Weekly" : "Monthly"} ",
          style: AppFonts.inter16Black500.copyWith(fontSize: 15),
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
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
                  "${price.toStringAsFixed(2)} ",
                  style: AppFonts.inter16Black500,
                ),
                Text(
                  "SAR",
                  style: AppFonts.inter14Grey400.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
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
          style: AppFonts.inter14Grey400.copyWith(fontSize: 16),
        ),
        Text(
          info,
          style: AppFonts.inter16Black500,
        ),
      ],
    );
  }
}

class CarPricesRow extends StatelessWidget {
  const CarPricesRow({
    super.key,
    required this.blocRead,
  });

  final CarDetailsCubit blocRead;

  @override
  Widget build(BuildContext context) {
    print("carr dailyy  ${blocRead.carDetailsData.carDailyPrice}");
    return Row(
      children: [
        Expanded(
          child: PriceCard(
            price: blocRead.carDetailsData.carDailyPrice,
            period: "daySmall".getLocale(),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: PriceCard(
            price: blocRead.carDetailsData.carWeaklyPrice,
            period: "weekSmall".getLocale(),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: PriceCard(
            price: blocRead.carDetailsData.carMothlyPrice,
            period: "monthSmall".getLocale(),
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
      padding: const EdgeInsetsDirectional.only(
        start: 16.0,
        end: 16.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              carName,
              style: AppFonts.inter20HeaderBlack700,
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
