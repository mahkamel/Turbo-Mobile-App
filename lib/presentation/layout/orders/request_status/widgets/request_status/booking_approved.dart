import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/theming/fonts.dart';

class BookingApprovedStatus extends StatelessWidget {
  const BookingApprovedStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Lottie.asset("assets/lottie/success_booking.json"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: Text(
            "Congratulations! Your car rental request is approved!.",
            style: AppFonts.ibm18PrimaryBlue00,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
