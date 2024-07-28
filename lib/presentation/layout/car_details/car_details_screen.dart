import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/presentation/layout/car_details/widgets/car_details_app_bar.dart';
import 'package:turbo/presentation/layout/car_details/widgets/car_details_widgets.dart';

import '../../../core/routing/screens_arguments.dart';
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
                  BlocProvider<CarDetailsCubit>.value(
                    value: context.read<CarDetailsCubit>(),
                    child: CarDetailsAppBar(
                      carId: car.carId,
                      carImageUrl: car.media.mediaMediumImageUrl,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        CarNameWithBrandImg(
                          carName: car.model.modelName,
                          brandImgUrl: car.brand.brandPath,
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
                                              "carInfo".getLocale(context: context),
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
                                              title: "model".getLocale(context: context),
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
                                                title: "year".getLocale(context: context),
                                                info: blocRead
                                                    .carDetailsData.carYear,
                                                iconPath:
                                                    "assets/images/icons/car_details_icons/car_year_icon.png",
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: CarInfoItem(
                                                title: "engine".getLocale(context: context),
                                                info: blocRead
                                                    .carDetailsData.carEngine,
                                                iconPath:
                                                    "assets/images/icons/car_details_icons/car_engine_icon.png",
                                              ),
                                            ),
                                            CarInfoItem(
                                              title: "seats".getLocale(context: context),
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
                                                title:
                                                    "${"limitedKm".getLocale(context: context)} (Daily)",
                                                info:
                                                    "${blocRead.carDetailsData.carLimitedKiloMeters}"
                                                        .toString(),
                                                iconPath:
                                                    "assets/images/icons/car_details_icons/limitedkm_icon.png",
                                              ),
                                            ),
                                            Text(
                                              "prices".getLocale(context: context),
                                              style: AppFonts
                                                  .inter18HeaderBlack700
                                                  .copyWith(
                                                color: AppColors.grey700,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            CarPricesRow(blocRead: blocRead),
                                            const SizedBox(
                                              height: 100,
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
                child: Container(
                  height: 100,
                  color: AppColors.white,
                  child: BlocBuilder<CarDetailsCubit, CarDetailsState>(
                      buildWhen: (previous, current) =>
                          current is GetCarsDetailsErrorState ||
                          current is GetCarsDetailsLoadingState ||
                          current is GetCarsDetailsSuccessState,
                      builder: (context, state) {
                        var blocRead = context.read<CarDetailsCubit>();
                        if (context
                            .watch<CarDetailsCubit>()
                            .carDetailsData
                            .id
                            .isEmpty) {
                          return const SizedBox();
                        } else {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: DefaultButton(
                              marginTop: 20,
                              marginBottom: 20,
                              marginRight: 16,
                              marginLeft: 16,
                              color: AppColors.primaryRed,
                              function: () async {
                                if (context
                                    .read<AuthRepository>()
                                    .customer
                                    .token
                                    .isEmpty) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (bsContext) {
                                      return Container(
                                        width:
                                            AppConstants.screenWidth(bsContext),
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(
                                          horizontal: 20,
                                          vertical: 18,
                                        ),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                            ),
                                            color: AppColors.white),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "loginRequiredTitle".getLocale(context: context),
                                              style: AppFonts
                                                  .inter18HeaderBlack700,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 24,
                                              ),
                                              child: Text(
                                                "loginRequiredContent"
                                                    .getLocale(context: context),
                                                style: AppFonts.inter14Grey400,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppConstants.screenWidth(
                                                  context),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: DefaultButton(
                                                    text: "Cancel",
                                                    color: AppColors.white,
                                                    textColor:
                                                        AppColors.primaryRed,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .primaryRed),
                                                    function: () {
                                                      Navigator.of(bsContext)
                                                          .pop();
                                                    },
                                                  )),
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  Expanded(
                                                    child: DefaultButton(
                                                      color:
                                                          AppColors.primaryRed,
                                                      function: () {
                                                        Navigator.of(bsContext)
                                                            .pop();

                                                        Navigator.pushNamed(
                                                          context,
                                                          Routes.loginScreen,
                                                          arguments:
                                                              LoginScreenArguments(
                                                            carId: car.carId,
                                                            dailyPrice: blocRead
                                                                .carDetailsData
                                                                .carDailyPrice,
                                                            weeklyPrice: blocRead
                                                                .carDetailsData
                                                                .carWeaklyPrice,
                                                            monthlyPrice: blocRead
                                                                .carDetailsData
                                                                .carMothlyPrice,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  await context
                                      .read<AuthRepository>()
                                      .refreshCustomerData()
                                      .then(
                                        (value) => Navigator.pushNamed(
                                          context,
                                          Routes.signupScreen,
                                          arguments: SignupScreenArguments(
                                            carId: car.carId,
                                            dailyPrice: blocRead
                                                .carDetailsData.carDailyPrice,
                                            weeklyPrice: blocRead
                                                .carDetailsData.carWeaklyPrice,
                                            monthlyPrice: blocRead
                                                .carDetailsData.carMothlyPrice,
                                          ),
                                        ),
                                      );
                                }
                              },
                              text: "bookNow".getLocale(context: context),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
