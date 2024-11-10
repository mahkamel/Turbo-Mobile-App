import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/car_details/car_details_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../models/car_items.dart';

class HeaderWithIcon extends StatelessWidget {
  final String svgIconPath;
  final String title;
  const HeaderWithIcon({
    super.key,
    required this.svgIconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(svgIconPath),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: AppFonts.ibm18HeaderBlue600.copyWith(
            color: AppColors.lightBlack,
          ),
        ),
      ],
    );
  }
}

class CarInfoDetails extends StatelessWidget {
  const CarInfoDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<CarDetailsCubit>();
    List<CarItem> carInfoItems = [
      CarItem(
        title: "Category",
        info: blocRead.carDetailsData.carCategory,
        iconPath: "assets/images/icons/car_details_icons/category.svg",
      ),
      CarItem(
        title: "Type",
        info: blocRead.carDetailsData.carType,
        iconPath: "assets/images/icons/car.svg",
      ),
      CarItem(
        title: "model".getLocale(context: context),
        info: blocRead.carDetailsData.carModel,
        iconPath: "assets/images/icons/car_details_icons/model.svg",
      ),
      CarItem(
        title: "year".getLocale(context: context),
        info: blocRead.carDetailsData.carYear,
        iconPath: "assets/images/icons/car_details_icons/year.svg",
      ),
      CarItem(
        title: "engine".getLocale(context: context),
        info: blocRead.carDetailsData.carEngine,
        iconPath: "assets/images/icons/car_details_icons/engine.svg",
      ),
      if (blocRead.carDetailsData.carPassengerNo != 0)
        CarItem(
          title: "seats".getLocale(context: context),
          info: blocRead.carDetailsData.carPassengerNo.toString(),
          iconPath: "assets/images/icons/car_details_icons/seats.svg",
        ),
      CarItem(
        title: "${"limitedKm".getLocale(context: context)} (Daily)",
        info: "${blocRead.carDetailsData.carLimitedKiloMeters}".toString(),
        iconPath: "assets/images/icons/car_details_icons/limitedKM.svg",
      ),
    ];
    return SizedBox(
      width: AppConstants.screenWidth(context),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.6,
          // crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: carInfoItems.length,
        itemBuilder: (context, index) {
          return CarInfoItem(
              title: carInfoItems[index].title,
              info: carInfoItems[index].info,
              iconPath: carInfoItems[index].iconPath);
        },
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
                BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                    spreadRadius: 0,
                    color: AppColors.black.withOpacity(0.3))
              ]),
          child: SvgPicture.asset(
            iconPath,
          ),
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
                style: AppFonts.ibm12SubTextGrey600
                    .copyWith(color: AppColors.lightBlack),
              ),
              Text(
                info,
                style:
                    AppFonts.ibm11Grey400.copyWith(color: AppColors.lightBlack),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
