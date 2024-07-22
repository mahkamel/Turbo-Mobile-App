import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:turbo/flavors.dart';

import '../../../../core/theming/colors.dart';

class CarImage extends StatelessWidget {
  const CarImage({
    super.key,
    required this.carImgPath,
  });
  final String carImgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 124,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.black800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CachedNetworkImage(
        imageUrl: "${FlavorConfig.instance.filesBaseUrl}$carImgPath",
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
    );
  }
}
