import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/payment/payment_cubit.dart';
import '../../../../../core/helpers/enums.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/text_field_with_header.dart';

class SaveCardInfo extends StatelessWidget {
  const SaveCardInfo({
    super.key,
    this.isFromRadio = false,
  });

  final bool isFromRadio;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFromRadio)
          const SizedBox(
            width: 6,
          ),
        Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.padded,
          side: const BorderSide(
            color: AppColors.blackBorder,
            width: 1.5,
          ),
          value: context.watch<PaymentCubit>().isSaveCardInfo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          onChanged: (value) {
            if (value != null) {
              context.read<PaymentCubit>().changeSaveCardValue(value);
            }
          },
        ),
        Text(
          "Save credit card information",
          style: AppFonts.ibm14Primary600,
        ),
      ],
    );
  }
}

class CVV extends StatelessWidget {
  const CVV({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<PaymentCubit>();
    var blocWatch = context.watch<PaymentCubit>();
    return Padding(
      padding: EdgeInsets.only(
          bottom: (context.watch<PaymentCubit>().cardExpiryDateValidation ==
                      TextFieldValidation.notValid &&
                  context.watch<PaymentCubit>().cardCVVValidation !=
                      TextFieldValidation.notValid)
              ? 28
              : 0),
      child: AuthTextFieldWithHeader(
        width: double.infinity,
        horizontalPadding: 0,
        isRequiredFiled: true,
        header: "CVV",
        hintText: "CVV",
        validationText: "Please Enter Valid CVV.",
        isWithValidation: true,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.digitsOnly,
        ],
        textInputType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        textEditingController: blocRead.cardCVV,
        validation: blocWatch.cardCVVValidation,
        onChange: (value) {
          if (value.isEmpty ||
              blocRead.cardCVVValidation != TextFieldValidation.normal) {
            context.read<PaymentCubit>().checkCVVValidation();
          }
        },
        onTapOutside: () {
          context.read<PaymentCubit>().checkCVVValidation();
        },
        onSubmit: (_) {
          blocRead.checkCVVValidation();
        },
      ),
    );
  }
}

class ExpiryDate extends StatelessWidget {
  const ExpiryDate({
    super.key,
    required this.blocRead,
    required this.blocWatch,
  });

  final PaymentCubit blocRead;
  final PaymentCubit blocWatch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: (context.watch<PaymentCubit>().cardCVVValidation ==
                      TextFieldValidation.notValid &&
                  context.watch<PaymentCubit>().cardExpiryDateValidation !=
                      TextFieldValidation.notValid)
              ? 28
              : 0),
      child: AuthTextFieldWithHeader(
        horizontalPadding: 0,
        isRequiredFiled: true,
        width: double.infinity,
        header: "Expiry Date",
        hintText: "MM/YY",
        validationText: "Please Enter Valid Date.",
        // isEnabled: blocRead.selectedSavedCardId != null ? false : true,
        isWithValidation: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(5),
          ExpiryDateInputFormatter(),
        ],
        textInputType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        textEditingController: blocRead.cardExpiryDate,
        validation: blocWatch.cardExpiryDateValidation,
        onChange: (value) {
          if (value.isEmpty ||
              blocRead.cardExpiryDateValidation != TextFieldValidation.normal) {
            context.read<PaymentCubit>().checkExpiryDateValidation();
          }
        },
        onSubmit: (_) {
          blocRead.checkExpiryDateValidation();
        },
      ),
    );
  }
}

class CardNumber extends StatelessWidget {
  const CardNumber({
    super.key,
    required this.blocRead,
    required this.blocWatch,
    this.isFromRadio = false,
  });
  final bool isFromRadio;
  final PaymentCubit blocRead;
  final PaymentCubit blocWatch;

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldWithHeader(
      horizontalPadding: isFromRadio ? 0 : 18,
      header: "Card Number",
      hintText: "Enter Card Number",
      isRequiredFiled: true,
      validationText: "Please Enter valid Number.",
      // isEnabled: blocRead.selectedSavedCardId != null ? false : true,
      isWithValidation: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(19),
        FilteringTextInputFormatter.digitsOnly,
        CardNumberInputFormatter(),
      ],
      textInputType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
      textEditingController: blocRead.cardNumber,
      validation: blocWatch.cardNumberValidation,
      onTapOutside: () {
        blocRead.checkCardNumberValidation();
      },
      onChange: (value) {
        if (value.isEmpty ||
            blocRead.cardNumberValidation != TextFieldValidation.normal) {
          context.read<PaymentCubit>().checkCardNumberValidation();
        }
      },
      onSubmit: (_) {
        blocRead.checkCardNumberValidation();
      },
      onTap: () {},
    );
  }
}

class CardHolderName extends StatelessWidget {
  const CardHolderName({
    super.key,
    required this.blocRead,
    required this.blocWatch,
    this.isFromRadio = false,
  });
  final bool isFromRadio;

  final PaymentCubit blocRead;
  final PaymentCubit blocWatch;

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldWithHeader(
      horizontalPadding: isFromRadio ? 0 : 16,
      header: "Cardholder Name",
      hintText: "Enter Name",
      // isEnabled: blocRead.selectedSavedCardId != null ? false : true,
      isRequiredFiled: true,
      textEditingController: blocRead.cardHolderName,
      validation: blocWatch.cardHolderNameValidation,
      isWithValidation: true,
      validationText: "Please Enter valid name.",
      onChange: (value) {
        if (value.isEmpty ||
            blocRead.cardHolderNameValidation != TextFieldValidation.normal) {
          context.read<PaymentCubit>().checkCardHolderNameValidation();
        }
      },
      onSubmit: (_) {
        blocRead.checkCardHolderNameValidation();
      },
    );
  }
}

class TotalAmount extends StatelessWidget {
  const TotalAmount({
    super.key,
    required this.value,
  });

  final num value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "Payment Amount",
            style: AppFonts.ibm16LightBlack600,
            children: [
              TextSpan(
                text: " (Including Vat)",
                style: AppFonts.ibm16subTextGrey600,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          "$value SAR",
          style: AppFonts.ibm18HeaderBlue600,
        ),
      ],
    );
  }
}

class ExpiryDateAndCvvRow extends StatelessWidget {
  const ExpiryDateAndCvvRow({
    super.key,
    this.isFromRadio = false,
  });
  final bool isFromRadio;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: isFromRadio ? 0 : 18.0).copyWith(
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
                return ExpiryDate(
                  blocRead: blocRead,
                  blocWatch: blocWatch,
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
                return const CVV();
              },
            ),
          ),
        ],
      ),
    );
  }
}
