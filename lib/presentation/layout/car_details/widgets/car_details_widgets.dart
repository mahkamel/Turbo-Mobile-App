import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';

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
      height: 95,
      width: AppConstants.screenWidth(context) * 0.25,
      // margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsetsDirectional.all(10),
      constraints: const BoxConstraints(
        maxWidth: 110,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.divider),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${period == "day" ? "Daily" : period == "week" ? "Weekly" : "Monthly"} ",
            style: AppFonts.ibm16PrimaryHeader400.copyWith(fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Text(
              textAlign: TextAlign.center,
              "${price.toStringAsFixed(2)} SAR/day",
              style: AppFonts.ibm11Grey400.copyWith(color: AppColors.lightBlack),
            ),
          ),
        ],
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
          height: 42,
          width: 42,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(offset: const Offset(0, 1), blurRadius: 3, spreadRadius: 0, color: AppColors.black.withOpacity(0.3))
            ]
          ),
          child: SvgPicture.asset(iconPath,),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$title ",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.ibm12SubTextGrey600.copyWith(color: AppColors.lightBlack),
              ),
              Text(
                info,
                style: AppFonts.ibm11Grey400.copyWith(color: AppColors.lightBlack),
              ),
            ],
          ),
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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        PriceCard(
          price: blocRead.carDetailsData.carDailyPrice,
          period: "daySmall".getLocale(context: context),
        ),
        PriceCard(
          price: blocRead.carDetailsData.carWeaklyPrice,
          period: "weekSmall".getLocale(context: context),
        ),
        PriceCard(
          price: blocRead.carDetailsData.carMothlyPrice,
          period: "monthSmall".getLocale(context: context),
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
        start: 11.0,
        end: 16.0,
        bottom: 11.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              carName,
              style: AppFonts.ibm24HeaderBlue600,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 8.0,
            ),
            child: CachedNetworkImage(
              width: 40,
              height: 60,
              imageUrl: getCompleteFileUrl(
                brandImgUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
