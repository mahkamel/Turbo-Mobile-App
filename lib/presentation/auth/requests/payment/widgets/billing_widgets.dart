import 'package:flutter/material.dart';
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
    var blocRead = context.read<PaymentCubit>();
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
                var blocWatch = context.watch<PaymentCubit>();
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: (blocWatch.billingLastNameValidation ==
                                  TextFieldValidation.notValid &&
                              blocWatch.billingFirstNameValidation !=
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
                    onChange: (value) {
                      if (value.isEmpty ||
                          blocRead.billingFirstNameValidation !=
                              TextFieldValidation.normal) {
                        blocRead.checkFirstNameValidation();
                      }
                    },
                    onSubmit: (_) {
                      blocRead.checkFirstNameValidation();
                    },
                    onTapOutside: () {
                      blocRead.checkFirstNameValidation();
                    },
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
                var blocWatch = context.watch<PaymentCubit>();
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: (blocWatch.billingFirstNameValidation ==
                                  TextFieldValidation.notValid &&
                              blocWatch.billingLastNameValidation !=
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
                    onChange: (value) {
                      if (value.isEmpty ||
                          blocRead.billingLastNameValidation !=
                              TextFieldValidation.normal) {
                        blocRead.checkLastNameValidation();
                      }
                    },
                    onSubmit: (_) {
                      blocRead.checkLastNameValidation();
                    },
                    onTapOutside: () {
                      blocRead.checkLastNameValidation();
                    },
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


class BillingPostalCode extends StatelessWidget {
  const BillingPostalCode({
    super.key,
    required this.blocRead,
  });

  final PaymentCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      buildWhen: (previous, current) =>
      current is CheckingBillingAddressValidation,
      builder: (context, state) {
        return AuthTextFieldWithHeader(
          header: "Postal Code",
          hintText: "Enter Postal Code",
          isWithValidation: true,
          textInputType: TextInputType.text,
          validationText: "Invalid Postal Code.",
          textEditingController: blocRead.billingPostalCodeCtrl,
          validation:
          context.watch<PaymentCubit>().billingPostalCodeValidation,
          onTapOutside: () {
            blocRead.checkBillingPostalCodeValidation();
          },
          onChange: (value) {
            if (value.isEmpty ||
                blocRead.billingPostalCodeValidation !=
                    TextFieldValidation.normal) {
              blocRead.checkBillingPostalCodeValidation();
            }
          },
          onSubmit: (value) {
            blocRead.checkBillingPostalCodeValidation();
          },
        );
      },
    );
  }
}

class BillingAddress extends StatelessWidget {
  const BillingAddress({
    super.key,
    required this.blocRead,
  });

  final PaymentCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      buildWhen: (previous, current) =>
      current is CheckingBillingAddressValidation,
      builder: (context, state) {
        return AuthTextFieldWithHeader(
          header: "Address",
          hintText: "Enter Address",
          isWithValidation: true,
          textInputType: TextInputType.text,
          validationText: "Invalid Address.",
          textEditingController: blocRead.billingAddressCtrl,
          validation:
          context.watch<PaymentCubit>().billingAddressValidation,
          onTapOutside: () {
            blocRead.checkBillingAddressValidation();
          },
          onChange: (value) {
            if (value.isEmpty ||
                blocRead.billingAddressValidation !=
                    TextFieldValidation.normal) {
              blocRead.checkBillingAddressValidation();
            }
          },
          onSubmit: (value) {
            blocRead.checkBillingAddressValidation();
          },
        );
      },
    );
  }
}

class BillingCity extends StatelessWidget {
  const BillingCity({
    super.key,
    required this.blocRead,
  });

  final PaymentCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      buildWhen: (previous, current) =>
      current is CheckingBillingCityValidation,
      builder: (context, state) {
        return AuthTextFieldWithHeader(
          header: "City",
          hintText: "Enter City",
          isWithValidation: true,
          textInputType: TextInputType.text,
          validationText: "Invalid City.",
          textEditingController: blocRead.billingCityCtrl,
          validation: context.watch<PaymentCubit>().billingCityValidation,
          onTapOutside: () {
            blocRead.checkBillingCityValidation();
          },
          onChange: (value) {
            if (value.isEmpty ||
                blocRead.billingCityValidation !=
                    TextFieldValidation.normal) {
              blocRead.checkBillingCityValidation();
            }
          },
          onSubmit: (value) {
            blocRead.checkBillingCityValidation();
          },
        );
      },
    );
  }
}
