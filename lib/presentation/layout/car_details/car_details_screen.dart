import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/routing/routes.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/default_buttons.dart';
import 'package:turbo/models/car_items.dart';
import 'package:turbo/presentation/layout/car_details/widgets/car_colors.dart';
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
      backgroundColor: AppColors.grey500,
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
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.15),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                             mainAxisSize: MainAxisSize.min,
                            children: [
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
                                  var blocRead =
                                      context.read<CarDetailsCubit>();
                                  var blocWatch =
                                      context.watch<CarDetailsCubit>();
                                  List<CarItem> carInfoItems = [
                                    CarItem(
                                      title: "Category",
                                      info: blocRead
                                          .carDetailsData
                                          .carCategory,
                                      iconPath:
                                          "assets/images/icons/car_details_icons/category.svg",
                                    ),
                                    CarItem(
                                      title: "Type",
                                      info: blocRead
                                          .carDetailsData.carType,
                                      iconPath:
                                          "assets/images/icons/car.svg",
                                    ),
                                    CarItem(
                                      title: "model".getLocale(
                                          context: context),
                                      info: blocRead
                                          .carDetailsData
                                          .carModel,
                                      iconPath:
                                          "assets/images/icons/car_details_icons/model.svg",
                                    ),
                                    CarItem(
                                      title: "year".getLocale(
                                          context: context),
                                      info: blocRead
                                          .carDetailsData
                                          .carYear,
                                      iconPath:
                                          "assets/images/icons/car_details_icons/year.svg",
                                    ),
                                    CarItem(
                                      title: "engine".getLocale(
                                          context: context),
                                      info: blocRead
                                          .carDetailsData
                                          .carEngine,
                                      iconPath:
                                          "assets/images/icons/car_details_icons/engine.svg",
                                    ),
                                    CarItem(
                                      title: "seats".getLocale(
                                          context: context),
                                      info: blocRead
                                          .carDetailsData
                                          .carPassengerNo
                                          .toString(),
                                      iconPath:
                                          "assets/images/icons/car_details_icons/seats.svg",
                                    ),
                                    CarItem(
                                      title:
                                          "${"limitedKm".getLocale(context: context)} (Daily)",
                                      info:
                                          "${blocRead.carDetailsData.carLimitedKiloMeters}"
                                              .toString(),
                                      iconPath:
                                          "assets/images/icons/car_details_icons/limitedKM.svg",
                                    ),
                                  ];
                                  return state is GetCarsDetailsLoadingState
                                      ? SizedBox(
                                     height:   AppConstants.screenHeight(context) * .45,
                                        child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      )
                                      : blocWatch.carDetailsData.id.isEmpty
                                          ? const SizedBox()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/images/icons/car.svg'),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "carInfo".getLocale(
                                                            context: context),
                                                        style: AppFonts
                                                            .ibm18HeaderBlue600
                                                            .copyWith(
                                                          color: AppColors
                                                              .lightBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
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
                                                        return CarInfoItem(title: carInfoItems[index].title, info: carInfoItems[index].info, iconPath: carInfoItems[index].iconPath);
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(2),
                                                        // margin: const EdgeInsets.only(right: 4),
                                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.gold),
                                                        child: const Icon(Icons.color_lens, color: AppColors.white, size: 18,)
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        Text(
                                                          "available Colors".getLocale(context: context),
                                                          style: AppFonts
                                                                  .ibm18HeaderBlue600
                                                                  .copyWith(
                                                                color: AppColors.lightBlack,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.only(
                                                      start: 29.0 , end: 16.0 , bottom: 30, top: 10),
                                                    child: CarColors(colors: blocRead.carDetailsData.carColor,),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(2),
                                                        // margin: const EdgeInsets.only(right: 4),
                                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.gold),
                                                        child: const Icon(Icons.attach_money_rounded, color: AppColors.white, size: 18,)
                                                        ),
                                                        const SizedBox(width: 10,),
                                                      Text(
                                                        "prices".getLocale(
                                                            context: context),
                                                        style: AppFonts
                                                            .ibm18HeaderBlue600
                                                            .copyWith(
                                                          color: AppColors.lightBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  Center(child: CarPricesRow(blocRead: blocRead)),
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
                          current is GetCarsDetailsSuccessState ||
                          current is RefreshCustomerDataLoadingState ||
                          current is RefreshCustomerDataErrorState ||
                          current is RefreshCustomerDataSuccessState,
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
                              loading: state is RefreshCustomerDataLoadingState,
                              marginTop: 20,
                              marginBottom: 20,
                              marginRight: 16,
                              marginLeft: 16,
                              color: AppColors.primaryBlue,
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
                                              "loginRequiredTitle"
                                                  .getLocale(context: context),
                                              style:
                                                  AppFonts.ibm18HeaderBlue600,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 24,
                                              ),
                                              child: Text(
                                                "loginRequiredContent"
                                                    .getLocale(
                                                        context: context),
                                                style: AppFonts.ibm11Grey400,
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
                                                        AppColors.primaryBlue,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .primaryBlue),
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
                                                          AppColors.primaryBlue,
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
                                  if (state
                                      is! RefreshCustomerDataLoadingState) {
                                    await blocRead.refreshCustomerData().then(
                                          (value) => Navigator.pushNamed(
                                            context,
                                            Routes.signupScreen,
                                            arguments: SignupScreenArguments(
                                              carId: car.carId,
                                              dailyPrice: blocRead
                                                  .carDetailsData.carDailyPrice,
                                              weeklyPrice: blocRead
                                                  .carDetailsData
                                                  .carWeaklyPrice,
                                              monthlyPrice: blocRead
                                                  .carDetailsData
                                                  .carMothlyPrice,
                                            ),
                                          ),
                                        );
                                  }
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
