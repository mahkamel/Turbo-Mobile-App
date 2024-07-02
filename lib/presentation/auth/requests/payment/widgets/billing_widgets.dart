import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/payment/payment_cubit.dart';
import '../../../../../core/helpers/enums.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/widgets/text_field_with_header.dart';

class BillingFirstAndLastName extends StatelessWidget {
  const BillingFirstAndLastName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: (context
                                      .watch<PaymentCubit>()
                                      .billingLastNameValidation ==
                                  TextFieldValidation.notValid &&
                              context
                                      .watch<PaymentCubit>()
                                      .billingFirstNameValidation !=
                                  TextFieldValidation.notValid)
                          ? 28
                          : 0),
                  child: AuthTextFieldWithHeader(
                    horizontalPadding: 0,
                    width: double.infinity,
                    header: "First Name",
                    hintText: "Enter First Name",
                    validationText: "Enter valid name",
                    isWithValidation: true,
                    inputFormatters: [
                      NoLeadingOrTrailingSpaceFormatter(),
                    ],
                    textInputType: TextInputType.name,
                    textEditingController: blocRead.billingFirstNameCtrl,
                    validation: blocWatch.cardExpiryDateValidation,
                    onChange: (value) {},
                    onSubmit: (_) {},
                  ),
                );
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
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: (context
                                      .watch<PaymentCubit>()
                                      .billingFirstNameValidation ==
                                  TextFieldValidation.notValid &&
                              context
                                      .watch<PaymentCubit>()
                                      .billingLastNameValidation !=
                                  TextFieldValidation.notValid)
                          ? 28
                          : 0),
                  child: AuthTextFieldWithHeader(
                    width: double.infinity,
                    horizontalPadding: 0,
                    header: "Last Name",
                    hintText: "Enter Last Name",
                    validationText: "Enter valid Name",
                    isWithValidation: true,
                    inputFormatters: [
                      NoLeadingOrTrailingSpaceFormatter(),
                    ],
                    textInputType: TextInputType.name,
                    textEditingController: blocRead.billingLastNameCtrl,
                    validation: blocWatch.billingLastNameValidation,
                    onChange: (value) {},
                    onSubmit: (_) {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
