import 'package:flutter/material.dart';
import 'package:turbo/presentation/auth/requests/payment/widgets/payment_form.dart';

import '../../../../../core/widgets/custom_header.dart';
import '../../../../core/helpers/constants.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    super.key,
    required this.value,
  });

  final num value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Column(
            children: [
              const DefaultHeader(
                header: "Payment",
                textAlignment: AlignmentDirectional.topCenter,
              ),
              SizedBox(
                height: AppConstants.screenHeight(context) < 700 ? 8 : 12,
              ),
              Expanded(
                child: PaymentForm(
                  value: value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
