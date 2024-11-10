import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:turbo/blocs/payment/payment_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/theming/fonts.dart';
import 'package:turbo/presentation/auth/requests/payment/widgets/payment_form_widgets.dart';

import '../../../../../../core/widgets/default_buttons.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/custom_text_fields.dart';
import '../../../../layout/profile/widgets/saved_cards_widgets.dart';
import 'existing_cards_bottom_sheet.dart';

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
    return ListView(
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      children: [
        const CardsRow(),
        const Divider(
          endIndent: 16,
          indent: 16,
          height: 8,
          color: AppColors.newDivider,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 16.0,
            bottom: 16.0,
            top: 34.0,
          ),
          child: TotalAmount(value: value),
        ),
        if (context.watch<PaymentCubit>().selectedCard != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Bank Cards",
              style: AppFonts.ibm16LightBlack600,
            ),
          ),
          BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, state) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      top: 6.0,
                    ),
                    child: DefaultCardRadioButton(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: NewCardRadio(),
                  )
                ],
              );
            },
          ),
        ],
        if (context.watch<PaymentCubit>().selectedCard == null) const NewCard(),
      ],
    );
  }
}

class NewCardRadio extends StatelessWidget {
  const NewCardRadio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var selectedToggleIndex =
        context.watch<PaymentCubit>().selectedCardToggleIndex;

    return CustomRadioButton(
      isSelected: selectedToggleIndex == 1,
      onTap: () {
        context.read<PaymentCubit>().changeCardTypeToggleValue(1);
      },
      type: "",
      typeAsWidget: AnimatedContainer(
        height: selectedToggleIndex == 1 ? 480 : 30,
        width: AppConstants.screenWidth(context) - 40,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(
                  'assets/images/icons/add_card.svg',
                  height: 28,
                  width: 50,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "Use New Card",
                  style: AppFonts.ibm16LightBlack400.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            if (selectedToggleIndex == 1)
              InkWell(
                  onTap: () {},
                  child: const NewCard(
                    isFromRadio: true,
                  )),
          ],
        ),
      ),
    );
  }
}

class DefaultCardRadioButton extends StatelessWidget {
  const DefaultCardRadioButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var selectedToggleIndex =
        context.watch<PaymentCubit>().selectedCardToggleIndex;
    return CustomRadioButton(
      isSelected: selectedToggleIndex == 0,
      onTap: () {
        context.read<PaymentCubit>().changeCardTypeToggleValue(0);
      },
      type: "",
      margin: const EdgeInsetsDirectional.only(end: 4, top: 8),
      typeAsWidget: AnimatedContainer(
        height: selectedToggleIndex == 0 ? 110 : 54,
        width: AppConstants.screenWidth(context) - 40,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                context.read<PaymentCubit>().selectedCard!.visaCardType ==
                        "visa"
                    ? SvgPicture.asset(
                        'assets/images/visa.svg',
                        height: 40,
                        width: 62,
                      )
                    : context.read<PaymentCubit>().selectedCard!.visaCardType ==
                            "mastercard"
                        ? SvgPicture.asset(
                            'assets/images/masterCard.svg',
                            height: 40,
                            width: 62,
                          )
                        : context
                                    .read<PaymentCubit>()
                                    .selectedCard!
                                    .visaCardType ==
                                "amex"
                            ? SvgPicture.asset(
                                'assets/images/americanExpress.svg',
                                height: 40,
                                width: 62,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ).copyWith(right: 12, left: 6.0),
                                child: SvgPicture.asset(
                                  'assets/images/default_card.svg',
                                  height: 22,
                                  width: 62,
                                ),
                              ),
                Text(
                  "**** ${context.read<PaymentCubit>().selectedCard!.visaCardNumber}",
                  style: AppFonts.ibm16LightBlack400.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const Spacer(),
                DefaultButton(
                  width: 64,
                  height: 26,
                  color: AppColors.grey500,
                  fontSize: 13,
                  marginRight: 16,
                  border: Border.all(color: AppColors.primaryBlue),
                  textColor: AppColors.primaryBlue,
                  function: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (bottomSheetContext) => ExistingCardsBottomSheet(
                        blocRead: context.read<PaymentCubit>(),
                        bottomSheetContext: bottomSheetContext,
                      ),
                    );
                  },
                  text: "Change",
                ),
              ],
            ),
            if (selectedToggleIndex == 0)
              CustomTextField(
                onTap: () {},
                radius: 20,
                width: 200,
                textInputType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                validateText: "Please Enter Valid CVV.",
                hint: "CVV (Enter Last 3 digits)",
                isWithValidationMsg: false,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textEditingController: context.read<PaymentCubit>().cardCVV,
                validationState:
                    context.watch<PaymentCubit>().cardCVVValidation,
                onChange: (value) {
                  context.read<PaymentCubit>().checkCVVValidation();
                },
                onSubmit: (_) {
                  context.read<PaymentCubit>().checkCVVValidation();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class NewCard extends StatelessWidget {
  const NewCard({
    super.key,
    this.isFromRadio = false,
  });

  final bool isFromRadio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isFromRadio ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<PaymentCubit, PaymentState>(
            buildWhen: (previous, current) =>
                current is CheckCardHolderNameState ||
                current is SelectedSavedCardState,
            builder: (context, state) {
              var blocWatch = context.watch<PaymentCubit>();
              var blocRead = context.read<PaymentCubit>();
              return CardHolderName(
                blocRead: blocRead,
                blocWatch: blocWatch,
                isFromRadio: isFromRadio,
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
                  isFromRadio: isFromRadio,
                );
              },
            ),
          ),
          ExpiryDateAndCvvRow(
            isFromRadio: isFromRadio,
          ),
          BlocBuilder<PaymentCubit, PaymentState>(
            buildWhen: (previous, current) =>
                current is ChangeSaveCreditCardState ||
                current is SelectedSavedCardState ||
                current is ChangeCardTypeToggleState,
            builder: (context, state) {
              var toggleIndex =
                  context.watch<PaymentCubit>().selectedCardToggleIndex;
              return toggleIndex == 1 ||
                      context.watch<PaymentCubit>().selectedCard == null
                  ? SaveCardInfo(
                      isFromRadio: isFromRadio,
                    )
                  : const SizedBox.shrink();
            },
          ),
          DefaultButton(
            marginBottom: 16,
            marginLeft:
                context.watch<PaymentCubit>().selectedCard == null ? 16 : 0,
            width: 102,
            height: 42,
            function: () {
              context.read<PaymentCubit>().clearPaymentFormData();
            },
            borderRadius: 20,
            color: AppColors.white,
            textColor: AppColors.gold,
            fontWeight: FontWeight.w600,
            border: Border.all(color: AppColors.gold),
            text: "Reset All",
          )
        ],
      ),
    );
  }
}
