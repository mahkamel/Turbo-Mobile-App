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
      child: Image.network(
        "${FlavorConfig.instance.filesBaseUrl}$carImgPath",
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const SizedBox(
            height: 40,
            width: 40,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            ),
          );
        },
        errorBuilder: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
