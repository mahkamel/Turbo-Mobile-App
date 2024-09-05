import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import '../../../../blocs/car_details/car_details_cubit.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/fonts.dart';
import 'car_colors.dart';
import 'car_info.dart';
import 'car_price.dart';


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

class CarDetails extends StatelessWidget {
  const CarDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarDetailsCubit, CarDetailsState>(
      buildWhen: (previous, current) =>
      current is GetCarsDetailsErrorState ||
          current is GetCarsDetailsLoadingState ||
          current is GetCarsDetailsSuccessState,
      builder: (context, state) {
        var blocWatch =
        context.watch<CarDetailsCubit>();

        return state is GetCarsDetailsLoadingState
            ? SizedBox(
          height: AppConstants.screenHeight(
              context) *
              .45,
          child: const Center(
            child:
            CircularProgressIndicator(),
          ),
        )
            : blocWatch.carDetailsData.id.isEmpty
            ? const SizedBox()
            : Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              HeaderWithIcon(title: "carInfo".getLocale(context: context), svgIconPath: 'assets/images/icons/car.svg',),
              const Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 20,
                ),
                child: CarInfoDetails(),
              ),
              const AvailableColorsHeader(),
              const CarColorsList(),
              const CarPricesHeader(),
              const Padding(
                padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 100),
                child: CarPricesRow(),
              ),
            ],
          ),
        );
      },
    );
  }
}
