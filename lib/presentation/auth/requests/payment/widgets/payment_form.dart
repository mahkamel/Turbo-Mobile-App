import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/payment/payment_cubit.dart';
import 'package:turbo/presentation/auth/requests/payment/widgets/payment_form_widgets.dart';
import 'package:turbo/presentation/status_screens/default_error_screen.dart';

import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/widgets/default_buttons.dart';
import 'billing_widgets.dart';

class PaymentForm extends StatelessWidget {
  const PaymentForm({
    super.key,
    required this.value,
  });
  final num value;

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
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 16.0,
            bottom: 16.0,
          ),
          child: Text.rich(
            TextSpan(
              text: "Total: ",
              style: AppFonts.inter16TypeGreyHeader600,
              children: [
                TextSpan(
                  text: "$value ",
                  style: AppFonts.inter18Black500,
                ),
                TextSpan(
                  text: "SAR",
                  style: AppFonts.inter18Black500.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<PaymentCubit, PaymentState>(
          buildWhen: (previous, current) =>
              current is CheckCardHolderNameState ||
              current is SelectedSavedCardState,
          builder: (context, state) {
            var blocRead = context.read<PaymentCubit>();
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0).copyWith(
            bottom: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<PaymentCubit, PaymentState>(
                  buildWhen: (previous, current) =>
                      current is CheckExpiryDateState ||
                      current is CheckCVVState ||
                      current is SelectedSavedCardState,
                  builder: (context, state) {
                    var blocRead = context.read<PaymentCubit>();
                    var blocWatch = context.watch<PaymentCubit>();
                    return ExpiryDate(blocRead: blocRead, blocWatch: blocWatch,);
                  },
                ),
              ),
              const SizedBox(
                width: 28,
              ),
              Expanded(
                child: BlocBuilder<PaymentCubit, PaymentState>(
                  buildWhen: (previous, current) =>
                      current is CheckCVVState ||
                      current is CheckExpiryDateState ||
                      current is SelectedSavedCardState,
                  builder: (context, state) {
                    var blocRead = context.read<PaymentCubit>();
                    var blocWatch = context.watch<PaymentCubit>();
                    return CVV(blocRead: blocRead, blocWatch: blocWatch);
                  },
                ),
              ),
            ],
          ),
        ),
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
        const Divider(
          height: 32,
          color: AppColors.divider,
        ),

        //Billing
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 16.0,
            bottom: 12.0,
          ),
          child: Text(
            "Billing",
            style: AppFonts.inter18Black500,
          ),
        ),
        const BillingFirstAndLastName(),

        BlocConsumer<PaymentCubit, PaymentState>(
          listenWhen: (previous, current) =>
              current is SubmitPaymentFormErrorState ||
              current is SubmitPaymentFormSuccessState,
          listener: (context, state) {
            if (state is SubmitPaymentFormSuccessState) {
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
              function: () {},
              text: "Pay Now",
              marginRight: 41,
              marginLeft: 41,
              marginTop: 30,
              marginBottom: 16,
              borderRadius: 0,
            );
          },
        ),
      ],
    );
  }
}

