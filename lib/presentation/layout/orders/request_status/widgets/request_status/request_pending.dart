import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/theming/fonts.dart';

class RequestPending extends StatelessWidget {
  const RequestPending({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Lottie.asset("assets/lottie/reviewing_docs.json"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: Text(
            "We are reviewing your documents and will notify you once the review is completed.",
            style: AppFonts.ibm18PrimaryBlue00,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
