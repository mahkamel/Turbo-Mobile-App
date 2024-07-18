import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/car_details/car_details_cubit.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../flavors.dart';

class CarDetailsAppBar extends StatelessWidget {
  const CarDetailsAppBar({
    super.key,
    required this.carId,
    required this.carImageUrl,
  });

  final String carId;
  final String carImageUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarDetailsCubit, CarDetailsState>(
      buildWhen: (previous, current) => current is GetCarsDetailsSuccessState,
      builder: (context, state) {
        var blocWatch = context.watch<CarDetailsCubit>();
        var blocRead = context.read<CarDetailsCubit>();
        return SliverAppBar(
          expandedHeight: AppConstants.screenHeight(context) * .4,
          pinned: false,
          stretch: false,
          elevation: 0,
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1,
            background: Hero(
              tag: carId,
              child: SizedBox(
                height: 350,
                width: AppConstants.screenWidth(context),
                child: blocWatch.carDetailsData.id.isNotEmpty
                    ? Swiper(
                        control: const SwiperControl(),
                        itemCount: blocRead.carDetailsData.carMedia.length,
                        itemBuilder: (context, index) => AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl:
                                "${FlavorConfig.instance.filesBaseUrl}${blocRead.carDetailsData.carMedia[index].mediaId.mediaMediumImageUrl}",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl:
                              "${FlavorConfig.instance.filesBaseUrl}$carImageUrl",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
