import 'package:flutter/material.dart';

import '../theming/colors.dart';

class BackButtonWithBG extends StatelessWidget {
  const BackButtonWithBG({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47,
      height: 47,
      margin: const EdgeInsetsDirectional.only(
        top: 20,
        start: 16,
      ),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
      ),
      child: IconButton(onPressed: (){Navigator.of(context).pop();},
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: AppColors.secondary,
          size: 24,
        ),
      ),
    );
  }
}
