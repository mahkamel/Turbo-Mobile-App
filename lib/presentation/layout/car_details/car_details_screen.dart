import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/presentation/layout/car_details/widgets/car_details_app_bar.dart';
import 'package:turbo/presentation/layout/car_details/widgets/car_details_widgets.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/back_button_with_bg.dart';
import '../../../models/get_cars_by_brands.dart';

class CardDetailsScreen extends StatelessWidget {
  const CardDetailsScreen({
    super.key,
    required this.car,
  });

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  CarDetailsAppBar(
                    carId: car.carId,
                    carImageUrl: car.carImg,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        CarNameWithBrandImg(
                          carName: car.carName,
                          brandImgUrl: car.carBrand.first.path,
                        ),
                        BlocBuilder<CarDetailsCubit, CarDetailsState>(
                          buildWhen: (previous, current) =>
                              current is GetCarsDetailsErrorState ||
                              current is GetCarsDetailsLoadingState ||
                              current is GetCarsDetailsSuccessState,
                          builder: (context, state) {
                            var blocRead = context.read<CarDetailsCubit>();
                            var blocWatch = context.watch<CarDetailsCubit>();
                            return state is GetCarsDetailsLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : blocWatch.carDetailsData.id.isEmpty
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "carInfo".getLocale(),
                                              style: AppFonts
                                                  .inter18HeaderBlack700
                                                  .copyWith(
                                                color: AppColors.grey700,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            CarInfoItem(
                                              title: "model".getLocale(),
                                              info: blocRead
                                                  .carDetailsData.carModel,
                                              iconPath:
                                                  "assets/images/icons/car_details_icons/model_icon.png",
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: CarInfoItem(
                                                title: "year".getLocale(),
                                                info: blocRead
                                                    .carDetailsData.carYear,
                                                iconPath:
                                                    "assets/images/icons/car_details_icons/car_year_icon.png",
                                              ),
                                            ),
                                            CarInfoItem(
                                              title: "plateNumber".getLocale(),
                                              info: blocRead.carDetailsData
                                                  .carPlateNumber,
                                              iconPath:
                                                  "assets/images/icons/car_details_icons/car_plate_icon.png",
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: CarInfoItem(
                                                title: "engine".getLocale(),
                                                info: blocRead
                                                    .carDetailsData.carEngine,
                                                iconPath:
                                                    "assets/images/icons/car_details_icons/car_engine_icon.png",
                                              ),
                                            ),
                                            CarInfoItem(
                                              title: "seats".getLocale(),
                                              info: blocRead
                                                  .carDetailsData.carPassengerNo
                                                  .toString(),
                                              iconPath:
                                                  "assets/images/icons/car_details_icons/car_seat_icon.png",
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4.0,
                                                bottom: 16.0,
                                              ),
                                              child: CarInfoItem(
                                                title: "limitedKm".getLocale(),
                                                info: blocRead.carDetailsData
                                                    .carLimitedKiloMeters
                                                    .toString(),
                                                iconPath:
                                                    "assets/images/icons/car_details_icons/limitedkm_icon.png",
                                              ),
                                            ),
                                            Text(
                                              "prices".getLocale(),
                                              style: AppFonts
                                                  .inter18HeaderBlack700
                                                  .copyWith(
                                                color: AppColors.grey700,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            CarPricesRow(blocWatch: blocWatch),
                                            const SizedBox(
                                              height: 90,
                                            ),
                                          ],
                                        ),
                                      );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const BackButtonWithBG(),
              Align(
                alignment: Alignment.bottomCenter,
                child: DefaultButton(
                  marginTop: 20,
                  marginBottom: 20,
                  marginRight: 16,
                  marginLeft: 16,
                  color: AppColors.primaryBG,
                  textColor: AppColors.primaryRed,
                  function: () {},
                  text: "bookNow".getLocale(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
