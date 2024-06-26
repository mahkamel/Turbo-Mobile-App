import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theming/colors.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    super.key,
    this.baseColor = AppColors.shimmer,
    this.highlightColor = AppColors.white,
    this.height = 12,
    this.width = 100,
    this.child,
  });

  final Color baseColor;
  final Color highlightColor;
  final double height;
  final double width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child ??
          Container(
            height: height,
            width: width,
            color: AppColors.grey,
          ),
    );
  }
}
