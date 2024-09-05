import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/presentation/layout/car_details/widgets/book_now_button.dart';
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
      backgroundColor: AppColors.grey500,
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomScrollView(
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
                            decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CarNameWithBrandImg(
                                  carName: car.model.modelName,
                                  brandImgUrl: car.brand.brandPath,
                                ),
                                const CarDetails(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const BackButtonWithBG(),
              const BookNowButton(),
            ],
          ),
        ),
      ),
    );
  }
}
