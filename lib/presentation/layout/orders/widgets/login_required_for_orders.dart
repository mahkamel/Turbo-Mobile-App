import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/fonts.dart';

class LoginRequiredForOrders extends StatelessWidget {
  const LoginRequiredForOrders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: AppConstants.screenHeight(context) < 600
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          Lottie.asset(
            "assets/lottie/login_required.json",
            width: 400,
            height: 400,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "To view your current rentals, please login to your account",
              style: AppFonts.ibm16LightBlack600,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
