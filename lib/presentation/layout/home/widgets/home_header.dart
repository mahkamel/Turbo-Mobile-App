import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.black),
          ),
          child: const Icon(Icons.location_on_outlined),
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "yourLocation".getLocale(),
              style: AppFonts.inter12Grey400,
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              // getIt<AuthRepository>().currentAddress ?? "",
              "Jeddah, KSA",
              style: AppFonts.inter16LocationBlue600,
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
            );
          },
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        )
      ],
    );
  }
}
