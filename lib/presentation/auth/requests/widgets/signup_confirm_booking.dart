import 'package:flutter/material.dart';
import 'package:turbo/presentation/auth/requests/widgets/signup_confirm_widgets.dart';
class SignupConfirmBooking extends StatelessWidget {
  const SignupConfirmBooking({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookingLocationField(),
          SizedBox(height: 16),
          PickupDateSelection(),
          DeliveryDateSelection(),
          PrivateDriverRow(),
          CarColorSelection(),
          RentalPrice(),
          SizedBox(
            height: 16,
          ),
          ConfirmBookingButton()
        ],
      ),
    );
  }
}
