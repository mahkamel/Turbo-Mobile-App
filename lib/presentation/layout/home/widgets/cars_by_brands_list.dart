import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/routing/screens_arguments.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../models/get_cars_by_brands.dart';

class CarsByBrandsList extends StatelessWidget {
  const CarsByBrandsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is GetCarsByBrandErrorState ||
          current is GetCarsByBrandLoadingState ||
          current is GetCarsByBrandSuccessState,
      builder: (context, state) {
        var blocWatch = context.watch<HomeCubit>();
        var blocRead = context.read<HomeCubit>();
        return state is GetCarsByBrandLoadingState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: ListView.separated(
                  itemCount: blocWatch.carsByBrand.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
                  itemBuilder: (context, index) {
                    String carType = blocRead.carsByBrand.keys.toList()[index];
                    List<Car> cars =
                        blocRead.carsByBrand.values.toList()[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 16,
                          ),
                          child: Text(
                            carType,
                            style: AppFonts.sfPro16TypeGreyHeader600,
                          ),
                        ),
                        SizedBox(
                          height: 234,
                          child: ListView.separated(
                            itemCount: cars.length,
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 8,
                            ),
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 16,
                            ),
                            itemBuilder: (context, index) => InkWell(
                              highlightColor: Colors.transparent,
                              onTap: () {
                                context.pushNamed(
                                  Routes.carDetailsScreen,
                                  arguments: CardDetailsScreenArguments(
                                    carId: cars[index].carName,
                                    carImageUrl: "imageUrl",
                                  ),
                                );
                              },
                              child: Container(
                                width: AppConstants.screenWidth(context) * 0.8,
                                height: 224,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.carCardGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Hero(
                                      tag: "carId",
                                      child: Container(
                                        width: double.infinity,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: AppColors.black800,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 10,
                                            foregroundColor: AppColors.grey400,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              cars[index]
                                                  .carBrand
                                                  .first
                                                  .brandName,
                                              style: AppFonts.sfPro14Black400,
                                            ),
                                          ),
                                          Text(
                                            cars[index].carYear,
                                            style: AppFonts.sfPro14Black400,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      cars[index].carName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.sfPro16Black500,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text.rich(
                                        TextSpan(
                                          text:
                                              "${cars[index].carDailyPrice} SAR",
                                          style: AppFonts.sfPro16Black500
                                              .copyWith(
                                                  color: AppColors.primaryRed,
                                                  fontWeight: FontWeight.w600),
                                          children: [
                                            TextSpan(
                                              text: "/day",
                                              style: AppFonts.sfPro14Black400
                                                  .copyWith(
                                                      color: AppColors.grey400,
                                                      fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
      },
    );
  }
}
