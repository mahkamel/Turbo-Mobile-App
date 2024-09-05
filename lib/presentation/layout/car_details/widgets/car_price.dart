import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/car_details/car_details_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class CarPricesHeader extends StatelessWidget {
  const CarPricesHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(2),
            // margin: const EdgeInsets.only(right: 4),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.gold),
            child: const Icon(
              Icons.attach_money_rounded,
              color: AppColors.white,
              size: 18,
            )),
        const SizedBox(
          width: 10,
        ),
        Text(
          "prices".getLocale(context: context),
          style: AppFonts.ibm18HeaderBlue600.copyWith(
            color: AppColors.lightBlack,
          ),
        ),
      ],
    );
  }
}

class CarPricesRow extends StatelessWidget {
  const CarPricesRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<CarDetailsCubit>();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
      width: (AppConstants.screenWidth(context) - 48) / 3,
      padding: const EdgeInsetsDirectional.all(10),
      constraints: const BoxConstraints(
        maxWidth: 140,
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
            style: AppFonts.ibm16PrimaryHeader400
                .copyWith(fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Text(
              textAlign: TextAlign.center,
              "${price.toStringAsFixed(2)} SAR/day",
              style:
              AppFonts.ibm11Grey400.copyWith(color: AppColors.lightBlack),
            ),
          ),
        ],
      ),
    );
  }
}

