import 'package:flutter/material.dart';

import '../theming/colors.dart';

class BackButtonWithBG extends StatelessWidget {
  const BackButtonWithBG({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      margin: const EdgeInsetsDirectional.only(
        top: 20,
        start: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const BackButton(
        color: AppColors.white,
      ),);
  }
}
