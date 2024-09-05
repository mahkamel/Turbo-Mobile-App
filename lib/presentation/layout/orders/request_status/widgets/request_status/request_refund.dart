import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:turbo/blocs/orders/order_cubit.dart';

import '../../../../../../core/theming/fonts.dart';

class RequestRefunded extends StatelessWidget {
  const RequestRefunded({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var amount = context.read<OrderCubit>().requestStatus?.requestPrice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Lottie.asset("assets/lottie/refunded_lottie.json"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: Text(
            "Your refund of [$amount] has been successfully processed. It may take a few business days for the refunded amount to reflect in your account, depending on your bank's processing time.",
            style: AppFonts.ibm18PrimaryBlue00,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
