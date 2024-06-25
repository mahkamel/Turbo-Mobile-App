import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';

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
    return SliverAppBar(
      expandedHeight: AppConstants.screenHeight(context) * .4,
      pinned: false,
      stretch: false,
      elevation: 0,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        title: Hero(
          tag: carId,
          child: SizedBox(
            height: 350,
            width: AppConstants.screenWidth(context),
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: carImageUrl,
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
