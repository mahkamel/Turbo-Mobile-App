import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/payment/payment_cubit.dart';
import 'package:turbo/presentation/auth/requests/payment/widgets/payment_form_widgets.dart';
import 'package:turbo/presentation/status_screens/default_error_screen.dart';
import 'package:turbo/presentation/status_screens/default_success_screen.dart';

import '../../../../../../core/widgets/default_buttons.dart';
import '../../../../../core/routing/routes.dart';

class PaymentForm extends StatelessWidget {
  const PaymentForm({
    super.key,
    required this.value,
    required this.carRequestId,
    required this.carRequestCode,
  });
  final num value;
  final String carRequestId;
  final String carRequestCode;

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<PaymentCubit>();

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      children: [
        const CardTypeToggle(),
        TotalAmount(value: value),
        BlocBuilder<PaymentCubit, PaymentState>(
          buildWhen: (previous, current) =>
              current is CheckCardHolderNameState ||
              current is SelectedSavedCardState,
          builder: (context, state) {
            var blocWatch = context.watch<PaymentCubit>();
            return CardHolderName(
              blocRead: blocRead,
              blocWatch: blocWatch,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 21.0,
            bottom: 17.0,
          ),
          child: BlocBuilder<PaymentCubit, PaymentState>(
            buildWhen: (previous, current) =>
                current is CheckCardNumberState ||
                current is SelectedSavedCardState ||
                current is ChangeCardTypeToggleState,
            builder: (context, state) {
              var blocRead = context.read<PaymentCubit>();
              var blocWatch = context.watch<PaymentCubit>();
              return CardNumber(
                blocRead: blocRead,
                blocWatch: blocWatch,
              );
            },
          ),
        ),
        const ExpiryDateAndCvvRow(),
        BlocBuilder<PaymentCubit, PaymentState>(
          buildWhen: (previous, current) =>
              current is ChangeSaveCreditCardState ||
              current is SelectedSavedCardState,
          builder: (context, state) {
            var blocRead = context.read<PaymentCubit>();
            return blocRead.selectedSavedCardId != null
                ? const SizedBox.shrink()
                : const SaveCardInfo();
          },
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
                    lottiePath: "assets/lottie/car_pending.json",
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
                blocRead.payCarRequest(
                  carRequestId: carRequestId,
                  amount: value,
                );
              },
              text: "Pay Now",
              marginRight: 20,
              marginLeft: 20,
              marginTop: 30,
              marginBottom: 16,
              // borderRadius: 0,
            );
          },
        ),
      ],
    );
  }
}
