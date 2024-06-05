import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/home/home_cubit.dart';
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
              "Your location",
              style: AppFonts.sfPro12Grey400,
            ),
            const SizedBox(
              height: 2,
            ),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
              current is GetCurrentUserLocationState,
              builder: (context, state) {
                return Text(
                  // getIt<AuthRepository>().currentAddress ?? "",
                  "Jeddah, KSA",
                  style: AppFonts.sfPro16LocationBlue600,
                );
              },
            ),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications_none_rounded)
      ],
    );
  }
}
