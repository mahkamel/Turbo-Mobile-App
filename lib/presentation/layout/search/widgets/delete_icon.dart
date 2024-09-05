import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Container(
        height: 15,
        width: 15,
        decoration: const BoxDecoration(
          color: AppColors.red,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.close_rounded,
            size: 14,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
