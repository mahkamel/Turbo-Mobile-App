import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
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
                                              "Car info",
                                              style: AppFonts
                                                  .sfPro18HeaderBlack700
                                                  .copyWith(
                                                color: AppColors.grey700,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            CarInfoItem(
                                              title: "Model",
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
                                                title: "Year",
                                                info: blocRead
                                                    .carDetailsData.carYear,
                                                iconPath:
                                                    "assets/images/icons/car_details_icons/car_year_icon.png",
                                              ),
                                            ),
                                            CarInfoItem(
                                              title: "Limited KiloMeters",
                                              info: blocRead.carDetailsData
                                                  .carLimitedKiloMeters
                                                  .toString(),
                                              iconPath:
                                                  "assets/images/icons/car_details_icons/limitedkm_icon.png",
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: CarInfoItem(
                                                title: "Plate Number",
                                                info: blocRead.carDetailsData
                                                    .carPlateNumber,
                                                iconPath:
                                                    "assets/images/icons/car_details_icons/car_plate_icon.png",
                                              ),
                                            ),
                                            CarInfoItem(
                                              title: "Engine",
                                              info: blocRead
                                                  .carDetailsData.carEngine,
                                              iconPath:
                                                  "assets/images/icons/car_details_icons/car_engine_icon.png",
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Text(
                                              "Price",
                                              style: AppFonts
                                                  .sfPro18HeaderBlack700
                                                  .copyWith(
                                                color: AppColors.grey700,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            CarPricesRow(blocWatch: blocWatch),
                                            DefaultButton(
                                              marginTop: 20,
                                              marginBottom: 12,
                                              color: AppColors.primaryBG,
                                              textColor: AppColors.primaryRed,
                                              function: () {},
                                              text: "Book Now",
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
            ],
          ),
        ),
      ),
    );
  }
}
