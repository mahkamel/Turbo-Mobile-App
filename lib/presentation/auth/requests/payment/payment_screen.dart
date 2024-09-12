import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/orders/order_cubit.dart';
import 'package:turbo/presentation/auth/requests/payment/widgets/delete_order_button.dart';
import 'package:turbo/presentation/auth/requests/payment/widgets/payment_form.dart';

import '../../../../../core/widgets/custom_header.dart';
import '../../../../blocs/payment/payment_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../status_screens/default_error_screen.dart';
import '../../../status_screens/default_success_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    super.key,
    required this.paymentAmount,
    required this.carRequestId,
    required this.carRequestCode,
    this.orderCubit,
  });

  final num paymentAmount;
  final String carRequestId;
  final String carRequestCode;
  final OrderCubit? orderCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Column(
            children: [
              DefaultHeader(
                header: "Payment",
                textAlignment: AlignmentDirectional.topCenter,
                // isShowPrefixIcon: orderCubit != null,
                alignment: MainAxisAlignment.spaceBetween,
                suffixIcon: orderCubit != null
                    ? DeleteOrderButton(orderCubit: orderCubit, carRequestId: carRequestId)
                    : null,
              ),
              SizedBox(
                height: AppConstants.screenHeight(context) < 700 ? 8 : 12,
              ),
              Expanded(
                child: PaymentForm(
                  value: paymentAmount,
                  carRequestId: carRequestId,
                  carRequestCode: carRequestCode,
                ),
              ),
              BlocConsumer<PaymentCubit, PaymentState>(
                listenWhen: (previous, current) =>
                    current is SubmitPaymentFormErrorState ||
                    current is SubmitPaymentFormSuccessState,
                listener: (context, state) {
                  if (state is SubmitPaymentFormSuccessState) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => DefaultSuccessScreen(
                          route: Routes.layoutScreen,
                          lottiePath: "assets/lottie/success.json",
                          message:
                              "We are reviewing your documents and will notify you once the review is complete.",
                          title:
                              "Your request #$carRequestCode has been submitted successfully!",
                          onOkPressed: () {},
                        ),
                      ),
                      (route) => false,
                    );
                  } else if (state is SubmitPaymentFormErrorState) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DefaultErrorScreen(errMsg: state.errMsg),
                        ));
                  }
                },
                buildWhen: (previous, current) =>
                    current is SubmitPaymentFormLoadingState ||
                    current is SubmitPaymentFormErrorState ||
                    current is SubmitPaymentFormSuccessState,
                builder: (context, state) {
                  return DefaultButton(
                    loading: state is SubmitPaymentFormLoadingState,
                    function: () {
                      context.read<PaymentCubit>().payCarRequest(
                            carRequestId: carRequestId,
                            amount: paymentAmount,
                          );
                    },
                    text: "Pay Now",
                    marginRight: 20,
                    marginLeft: 20,
                    marginTop: 16,
                    marginBottom: 16,
                    // borderRadius: 0,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

