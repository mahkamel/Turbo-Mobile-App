import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/enums.dart';
import '../../../../core/helpers/functions.dart';
import '../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../core/widgets/custom_header.dart';
import '../../../core/widgets/default_buttons.dart';
import '../../../core/widgets/snackbar.dart';
import '../../../core/widgets/text_field_with_header.dart';

class AddNewCardScreen extends StatelessWidget {
  const AddNewCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Column(
            children: [
              const DefaultHeader(
                header: "Add New Card",
                textAlignment: AlignmentDirectional.center,
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      buildWhen: (previous, current) =>
                          current is CheckCardToSaveHolderNameState,
                      builder: (context, state) {
                        var blocRead = context.read<ProfileCubit>();
                        var blocWatch = context.watch<ProfileCubit>();
                        return AuthTextFieldWithHeader(
                          header: "Cardholder Name",
                          hintText: "Enter Name",
                          textEditingController: blocRead.cardHolderName,
                          validation: blocWatch.cardHolderNameValidation,
                          isWithValidation: true,
                          validationText: "Enter valid name",
                          onChange: (value) {
                            if (value.isEmpty ||
                                blocRead.cardHolderNameValidation !=
                                    TextFieldValidation.normal) {
                              context
                                  .read<ProfileCubit>()
                                  .checkCardHolderNameValidation();
                            }
                          },
                          onSubmit: (_) {
                            blocRead.checkCardHolderNameValidation();
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 21.0,
                        bottom: 17.0,
                      ),
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        buildWhen: (previous, current) =>
                            current is CheckCardToSaveNumberState,
                        builder: (context, state) {
                          var blocRead = context.read<ProfileCubit>();
                          var blocWatch = context.watch<ProfileCubit>();
                          return AuthTextFieldWithHeader(
                            header: "Card Number",
                            hintText: "Enter Card Number",
                            validationText: "Enter valid number",
                            isWithValidation: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(19),
                              FilteringTextInputFormatter.digitsOnly,
                              CardNumberInputFormatter(),
                            ],
                            textInputType:
                                const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: false,
                            ),
                            textEditingController: blocRead.cardNumber,
                            validation: blocWatch.cardNumberValidation,
                            onChange: (value) {
                              if (value.isEmpty ||
                                  blocRead.cardNumberValidation !=
                                      TextFieldValidation.normal) {
                                context
                                    .read<ProfileCubit>()
                                    .checkCardNumberValidation();
                              }
                            },
                            onSubmit: (_) {
                              blocRead.checkCardNumberValidation();
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 18.0).copyWith(
                        bottom: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<ProfileCubit, ProfileState>(
                              buildWhen: (previous, current) =>
                                  current is CheckCardToSaveExpiryDateState ||
                                  current is CheckCardToSaveCVVState,
                              builder: (context, state) {
                                var blocRead = context.read<ProfileCubit>();
                                var blocWatch = context.watch<ProfileCubit>();
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: (context
                                                      .watch<ProfileCubit>()
                                                      .cardCVVValidation ==
                                                  TextFieldValidation
                                                      .notValid &&
                                              context
                                                      .watch<ProfileCubit>()
                                                      .cardExpiryDateValidation !=
                                                  TextFieldValidation.notValid)
                                          ? 28
                                          : 0),
                                  child: AuthTextFieldWithHeader(
                                    horizontalPadding: 0,
                                    width: double.infinity,
                                    header: "Expiry Date",
                                    hintText: "MM/YY",
                                    validationText: "Enter valid date",
                                    isWithValidation: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(5),
                                      ExpiryDateInputFormatter(),
                                    ],
                                    textInputType:
                                        const TextInputType.numberWithOptions(
                                      signed: false,
                                      decimal: false,
                                    ),
                                    textEditingController:
                                        blocRead.cardExpiryDate,
                                    validation:
                                        blocWatch.cardExpiryDateValidation,
                                    onChange: (value) {
                                      if (value.isEmpty ||
                                          blocRead.cardExpiryDateValidation !=
                                              TextFieldValidation.normal) {
                                        context
                                            .read<ProfileCubit>()
                                            .checkExpiryDateValidation();
                                      }
                                    },
                                    onSubmit: (_) {
                                      blocRead.checkExpiryDateValidation();
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
                                                  TextFieldValidation
                                                      .notValid &&
                                              context
                                                      .watch<ProfileCubit>()
                                                      .cardCVVValidation !=
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
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textInputType:
                                        const TextInputType.numberWithOptions(
                                      signed: false,
                                      decimal: false,
                                    ),
                                    textEditingController: blocRead.cardCVV,
                                    validation: blocWatch.cardCVVValidation,
                                    onChange: (value) {
                                      if (value.isEmpty ||
                                          blocRead.cardCVVValidation !=
                                              TextFieldValidation.normal) {
                                        context
                                            .read<ProfileCubit>()
                                            .checkCVVValidation();
                                      }
                                    },
                                    onSubmit: (_) {
                                      blocRead.checkCVVValidation();
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<ProfileCubit, ProfileState>(
                      listenWhen: (previous, current) =>
                          current is AddNewCardErrorState ||
                          current is AddNewCardSuccessState,
                      listener: (context, state) {
                        if (state is AddNewCardSuccessState) {
                          defaultSuccessSnackBar(
                            context: context,
                            message: "Visa Card Added Successfully",
                          );
                        } else if (state is AddNewCardErrorState) {
                          defaultErrorSnackBar(
                            context: context,
                            message: state.errMsg,
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is AddNewCardLoadingState ||
                          current is AddNewCardErrorState ||
                          current is AddNewCardSuccessState,
                      builder: (context, state) {
                        return DefaultButton(
                          loading: state is AddNewCardLoadingState,
                          function: () {
                            if (state is! AddNewCardLoadingState) {
                              context.read<ProfileCubit>().addNewPaymentCard();
                            }
                          },
                          text: "Add Card",
                          marginRight: 20,
                          marginLeft: 20,
                          marginTop: 30,
                          marginBottom: 16,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
