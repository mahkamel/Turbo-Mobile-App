import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/core/widgets/custom_shimmer.dart';

import '../../../../core/helpers/constants.dart';
import 'cars_by_types_listview.dart';

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
          current is GetCarsBrandsLoadingState ||
          current is GetCarsByBrandSuccessState,
      builder: (context, state) {
        var blocWatch = context.watch<HomeCubit>();
        return (blocWatch.isGettingCars &&
                !AppConstants.isFirstTimeGettingCarRec)
            ? Center(
                child: Lottie.asset(
                  "assets/lottie/luxury_car_loading.json",
                  height: AppConstants.screenWidth(context) * .4,
                  width: (AppConstants.screenWidth(context) * .4) + 50,
                ),
              )
            : state is GetCarsByBrandLoadingState ||
                    state is GetCarsBrandsLoadingState ||
                    AppConstants.isFirstTimeGettingCarRec
                ? const CarsByBrandShimmer()
                : blocWatch.carsByBrand.isEmpty
                    ? Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 16.0,
                        end: 16.0,
                        // top: 48,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Lottie.asset(
                            "assets/lottie/no_result.json",
                            height: AppConstants.screenWidth(context) * .6,
                            width: (AppConstants.screenWidth(context) * .8),
                          ),
                          const SizedBox(height: 20,),
                          Text(
                            "noCarsBasedOnBrand"
                                .getLocale(context: context),
                            textAlign: TextAlign.center,
                            style: AppFonts.ibm24HeaderBlue600.copyWith(
                              fontSize: 18
                            )
                          ),
                        ],
                      ),
                    )
                    : CarsByTypesListview(
                      carsByBrand: blocWatch.carsByBrand,
                    );
      },
    );
  }
}

class CarsByBrandShimmer extends StatelessWidget {
  const CarsByBrandShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 16,
            ),
            child: Container(
              height: 12,
              width: 100,
              color: Colors.grey,
            ),
          ),
          Container(
            width: AppConstants.screenWidth(context) - 32,
            height: 180,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            margin: const EdgeInsetsDirectional.only(
              bottom: 4,
              start: 16,
              top: 8,
            ),
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      height: 16,
                      width: 16,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 8.0,
                        bottom: 6.0,
                        start: 8,
                      ),
                      child: Container(
                        height: 6,
                        width: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.grey,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 4,
                    width: 100,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
