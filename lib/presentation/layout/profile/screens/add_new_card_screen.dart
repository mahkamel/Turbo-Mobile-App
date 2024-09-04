import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/presentation/layout/profile/widgets/saved_cards_widgets.dart';

import '../../../../../core/helpers/constants.dart';
import '../../../../../core/helpers/enums.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/snackbar.dart';
import '../../../../core/widgets/text_field_with_header.dart';

class AddNewCardScreen extends StatelessWidget {
  final int? index;
  const AddNewCardScreen({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Column(
            children: [
              DefaultHeader(
                header: index != null ? "Edit Card" : "Add Card",
                textAlignment: AlignmentDirectional.center,
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(
                    top: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          const CardsRow(),
                          const Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 15),
                            child: Divider(),
                          ),
                          CardHolderName(index: index,),
                          CardNumber(index: index),
                          ExpiryDate(index: index),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AddCardButton(index: index,),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCardButton extends StatelessWidget {
  final int? index;
  const AddCardButton({
    super.key,
    this.index,
  });

  @override

  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          current is AddNewCardErrorState || current is AddNewCardSuccessState
          || current is EditPaymentCardErrorState || current is EditPaymentCardSuccessState,
      listener: (context, state) {
        if (state is AddNewCardSuccessState) {
          Navigator.of(context).pop();
        } else if (state is AddNewCardErrorState) {
          defaultErrorSnackBar(
            context: context,
            message: state.errMsg,
          );
        } else if(state is EditPaymentCardErrorState) {
          defaultErrorSnackBar(
            context: context,
            message: state.errMsg,
          );
        } else if(state is EditPaymentCardSuccessState) {
          defaultSuccessSnackBar(context: context, message: state.success);
        }
      },
      buildWhen: (previous, current) =>
          current is AddNewCardLoadingState ||
          current is AddNewCardErrorState ||
          current is AddNewCardSuccessState ||
          current is EditPaymentCardErrorState ||
          current is EditPaymentCardSuccessState ||
          current is EditPaymentCardLoadingState,
      builder: (context, state) {
        return DefaultButton(
          loading: state is AddNewCardLoadingState || state is EditPaymentCardLoadingState,
          function: () {
            if (index != null) {
              context.read<ProfileCubit>().editPaymentCard(index!);
            } else {
              context.read<ProfileCubit>().addNewPaymentCard();
            }
          },
          text: index != null ? "Edit Card": "Add Card",
          marginRight: 20,
          marginLeft: 20,
          marginTop: 30,
          marginBottom: 16,
        );
      },
    );
  }
}

class ExpiryDate extends StatelessWidget {
  final int? index;
  const ExpiryDate({
    super.key,
    this.index
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
            child: BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (previous, current) =>
                  current is CheckCardToSaveExpiryDateState ||
                  current is CheckCardToSaveCVVState ||
                  current is EditPaymentCardSuccessState,
                  
              builder: (context, state) {
                var blocRead = context.read<ProfileCubit>();
                var blocWatch = context.watch<ProfileCubit>();
                return Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          ((context.watch<ProfileCubit>().cardCVVValidation ==
                                      TextFieldValidation.notValid &&
                            context
                                    .watch<ProfileCubit>()
                                    .cardExpiryDateValidation !=
                            TextFieldValidation.notValid && index == null
                            )
                          )
                              ? 28
                              : 0),
                  child: AuthTextFieldWithHeader(
                    horizontalPadding: 0,
                    width: double.infinity,
                    header: "Expiry Date",
                    hintText: index == null ? "MM/YY" : "${blocRead.savedPaymentCards[index!].visaCardExpiryMonth} / ${blocRead.savedPaymentCards[index!].visaCardExpiryYear}",
                    validationText: "Enter valid date",
                    isWithValidation: index != null && blocRead.cardExpiryDate.text.isEmpty ? false : true,
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
                    validation: index != null && blocRead.cardExpiryDate.text.isEmpty ? TextFieldValidation.normal : blocWatch.cardExpiryDateValidation,
                    onChange: (value) {
                      if (
                        ((value.isEmpty ||
                          blocRead.cardExpiryDateValidation !=
                              TextFieldValidation.normal) && index == null)
                        ) {
                        context
                            .read<ProfileCubit>()
                            .checkExpiryDateValidation();
                      }

                      if(((value.isNotEmpty ||
                          blocRead.cardExpiryDateValidation !=
                              TextFieldValidation.normal) && index != null)) {
                                
                                context
                            .read<ProfileCubit>()
                            .checkExpiryDateValidation();
                      }
                      if(value.isEmpty && index != null) {
                        context
                            .read<ProfileCubit>()
                            .checkExpiryDateValidation(isFromEdit: true);
                      }
                    },
                    onSubmit: (_) {
                      if(index == null) {
                        blocRead.checkExpiryDateValidation();
                      } else if(index != null && blocRead.cardExpiryDate.text.isEmpty) {
                        blocRead.checkExpiryDateValidation();
                      }
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
            child: BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (previous, current) =>
                  current is CheckCardToSaveCVVState ||
                  current is CheckCardToSaveExpiryDateState,
              builder: (context, state) {
                var blocRead = context.read<ProfileCubit>();
                var blocWatch = context.watch<ProfileCubit>();
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: (context
                                      .watch<ProfileCubit>()
                                      .cardExpiryDateValidation ==
                                  TextFieldValidation.notValid &&
                              context.watch<ProfileCubit>().cardCVVValidation !=
                                  TextFieldValidation.notValid)
                          ? 28
                          : 0),
                  child: AuthTextFieldWithHeader(
                    width: double.infinity,
                    horizontalPadding: 0,
                    header: "CVV",
                    hintText: "CVV",
                    validationText: "Enter valid cvv",
                    isWithValidation: true,
                    isEnabled: index == null ? true: false,
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
                          blocRead.cardCVVValidation !=
                              TextFieldValidation.normal) {
                        context.read<ProfileCubit>().checkCVVValidation();
                      }
                    },
                    onSubmit: (_) {
                      blocRead.checkCVVValidation();
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CardNumber extends StatelessWidget {
  final int? index;
  const CardNumber({
    super.key,
    this.index
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 21.0,
        bottom: 17.0,
      ),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) => current is CheckCardToSaveNumberState || current is EditPaymentCardSuccessState,
        builder: (context, state) {
          var blocRead = context.read<ProfileCubit>();
          var blocWatch = context.watch<ProfileCubit>();
          return AuthTextFieldWithHeader(
            header: "Cardholder Number",
            hintText: index == null ? "Enter Card Number" :  "**** **** **** ${blocRead.savedPaymentCards[index!].visaCardNumber}",
            validationText: "Enter valid number",
            isWithValidation: index == null ? true : false,
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
            validation: index == null ? blocWatch.cardNumberValidation : TextFieldValidation.normal,
            onChange: (value) {
              if ((value.isEmpty ||
                  blocRead.cardNumberValidation != TextFieldValidation.normal) && index == null) {
                context.read<ProfileCubit>().checkCardNumberValidation();
              }
            },
            onSubmit: (_) {
              if(index == null) {
                blocRead.checkCardNumberValidation();
              }
            },
            isEnabled: index == null ? true : false,
          );
        },
      ),
    );
  }
}

class CardHolderName extends StatelessWidget {
  final int? index;
  const CardHolderName({
    super.key,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          current is CheckCardToSaveHolderNameState ||
          current is EditPaymentCardSuccessState,
      builder: (context, state) {
        var blocRead = context.read<ProfileCubit>();
        var blocWatch = context.watch<ProfileCubit>();
        return AuthTextFieldWithHeader(
          header: "Cardholder Name",
          hintText: index != null ? blocRead.savedPaymentCards[index!].visaCardName : "Enter Name",
          textEditingController: blocRead.cardHolderName,
          validation: index != null ? TextFieldValidation.normal : blocWatch.cardHolderNameValidation,
          isWithValidation: index != null ? false : true,
          validationText: "Enter valid name",
          onChange: (value) {
            if ((value.isEmpty ||
                blocRead.cardHolderNameValidation !=
                    TextFieldValidation.normal) && index == null) {
              context.read<ProfileCubit>().checkCardHolderNameValidation();
            }
          },
          onSubmit: (_) {
            if(index == null) {
              blocRead.checkCardHolderNameValidation();
            }
          },
        );
      },
    );
  }
}
