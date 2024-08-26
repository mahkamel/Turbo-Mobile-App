import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/services/networking/repositories/payment_repository.dart';
import 'package:turbo/presentation/auth/requests/payment/widgets/payment_card_type.dart';

import '../../../../../blocs/payment/payment_cubit.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/constants.dart';
import '../../../../../core/helpers/enums.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/text_field_with_header.dart';
import 'existing_cards_bottom_sheet.dart';

class CardTypeToggle extends StatelessWidget {
  const CardTypeToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: AppConstants.widthBasedOnFigmaDevice(context, 391),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocBuilder<PaymentCubit, PaymentState>(
          buildWhen: (previous, current) =>
              current is ChangeCardTypeToggleState,
          builder: (context, state) {
            return Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              spacing: 4,
              children: [
                PaymentCardTypeRow(
                  isSelected: context.watch<PaymentCubit>().cardTypeToggle == 0,
                  index: 0,
                  type: "Visa",
                ),
                PaymentCardTypeRow(
                  isSelected: context.watch<PaymentCubit>().cardTypeToggle == 1,
                  index: 1,
                  type: "Mastercard",
                ),
                PaymentCardTypeRow(
                  isSelected: context.watch<PaymentCubit>().cardTypeToggle == 2,
                  index: 2,
                  type: "AmEx",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SaveCardInfo extends StatelessWidget {
  const SaveCardInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
          style: AppFonts.inter14Black400,
        ),
      ],
    );
  }
}

class CVV extends StatelessWidget {
  const CVV({
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
        validationText: "Please Enter Valid CVV." ,
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
        isEnabled: blocRead.selectedSavedCardId != null ? false : true,
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
  });

  final PaymentCubit blocRead;
  final PaymentCubit blocWatch;

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldWithHeader(
      header: "Card Number",
      hintText: "Enter Card Number",
      isRequiredFiled: true,
      validationText: "Please Enter valid Number.",
      isEnabled: blocRead.selectedSavedCardId != null ? false : true,
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
      onTap: () {
        if (blocRead.selectedSavedCardId != null) {
          showModalBottomSheet(
            context: context,
            builder: (bottomSheetContext) => ExistingCardsBottomSheet(
              blocRead: blocRead,
              bottomSheetContext: bottomSheetContext,
            ),
          );
        }
      },
      suffixIcon: getIt<PaymentRepository>().savedPaymentCards.isNotEmpty
          ? IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (bottomSheetContext) => ExistingCardsBottomSheet(
                    blocRead: blocRead,
                    bottomSheetContext: bottomSheetContext,
                  ),
                );
              },
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryBlue,
              ),
            )
          : null,
    );
  }
}

class CardHolderName extends StatelessWidget {
  const CardHolderName({
    super.key,
    required this.blocRead,
    required this.blocWatch,
  });

  final PaymentCubit blocRead;
  final PaymentCubit blocWatch;

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldWithHeader(
      header: "Cardholder Name",
      hintText: "Enter Name",
      isEnabled: blocRead.selectedSavedCardId != null ? false : true,
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
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 16.0,
        bottom: 16.0,
      ),
      child: Text.rich(
        TextSpan(
          text: "Total: ",
          style: AppFonts.ibm16TypeGreyHeader600,
          children: [
            TextSpan(
              text: "${value.toStringAsFixed(2)} ",
              style: AppFonts.inter18Black500,
            ),
            TextSpan(
              text: "SAR",
              style: AppFonts.inter18Black500.copyWith(
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: " (Including VAT)",
              style: AppFonts.ibm11Grey400,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpiryDateAndCvvRow extends StatelessWidget {
  const ExpiryDateAndCvvRow({
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
                var blocRead = context.read<PaymentCubit>();
                var blocWatch = context.watch<PaymentCubit>();
                return CVV(blocRead: blocRead, blocWatch: blocWatch);
              },
            ),
          ),
        ],
      ),
    );
  }
}
