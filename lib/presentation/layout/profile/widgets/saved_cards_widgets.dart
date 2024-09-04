import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:turbo/core/widgets/snackbar.dart';

import '../../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/default_dialog.dart';
import '../screens/add_new_card_screen.dart';

class EmptySavedCards extends StatelessWidget {
  const EmptySavedCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: AppConstants.heightBasedOnFigmaDevice(context, 48),
              ),
              Lottie.asset(
                "assets/lottie/card.json",
                // height: AppConstants.heightBasedOnFigmaDevice(context, 340),
              ),
              Text(
                "Add your first credit card for payment",
                textAlign: TextAlign.center,
                style: AppFonts.ibm24HeaderBlue600,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "This credit card will be used by default for billing.",
                textAlign: TextAlign.center,
                style: AppFonts.ibm12SubTextGrey600,
              ),
            ],
          ),
        ),
        //  const AddNewCardButton()
      ],
    );
  }
}

class SavedPaymentCardItem extends StatelessWidget {
  const SavedPaymentCardItem(
      {super.key,
      required this.cardNumbers,
      required this.expDate,
      this.isDefault = false,
      this.isFromDelete = false,
      required this.cardType,
      required this.cardId,
      required this.index,
      required this.isExpired});

  final String cardNumbers;
  final String cardType;
  final String expDate;
  final bool isDefault;
  final bool isFromDelete;
  final String cardId;
  final int index;
  final bool isExpired;
  @override
  Widget build(BuildContext context) {
    bool defaultCard = context.read<ProfileCubit>()
                              .savedPaymentCards[index]
                              .isCardDefault;
    return Container(
      height: 105,
      width: AppConstants.screenWidth(context) - 32,
      decoration: BoxDecoration(
          color: AppColors.grey500,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.subTextGrey)),
      child: Stack(
        children: [
          savedCardBackground(),
          Padding(
            padding: const EdgeInsets.all(
              10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppConstants.screenWidth(context) - 52,
                  child: Row(
                    children: [
                      getCardTypeIcon(cardType),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "**** $cardNumbers",
                                  style: AppFonts.ibm12SubTextGrey600.copyWith(
                                    color: AppColors.lightBlack,
                                  ),
                                ),
                                isFromDelete
                                    ? const SizedBox()
                                    : EditDeleteIcons(
                                        index: index,
                                        isExpired: isExpired,
                                        cardId: cardId,
                                        cardNumbers: cardNumbers,
                                        cardType: cardType,
                                        expDate: expDate,
                                        isFromDelete: isFromDelete,
                                      )
                              ],
                            ),
                            Text(
                              "Expires $expDate",
                              style: AppFonts.ibm11Grey400.copyWith(
                                color: AppColors.lightBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state is SetDefaultCardSuccessState) {
                      defaultSuccessSnackBar(
                          context: context, message: state.success);
                    } else if (state is SetDefaultCardErrorState) {
                      defaultErrorSnackBar(
                          context: context, message: state.errMsg);
                    }
                  },
                  listenWhen: (previous, current) {
                    return current is SetDefaultCardSuccessState ||
                        current is SetDefaultCardErrorState;
                  },
                  buildWhen: (previous, current) {
                    return current is SetDefaultCardSuccessState ||
                        current is SetDefaultCardErrorState ||
                        (current is SetDefaultCardLoadingState &&
                            current.id == cardId);
                  },
                  builder: (context, state) {
                    return DefaultCardButton(
                      isFromDelete: isFromDelete,
                      cardId: cardId,
                      isExpired: isExpired,
                      index: index,
                      isLoading: state is SetDefaultCardLoadingState,
                      isDefault: isFromDelete
                          ? defaultCard
                          : context
                              .watch<ProfileCubit>()
                              .savedPaymentCards[index]
                              .isCardDefault,
                    );
                  },
                ),
              ],
            ),
          ),
          savedCardLinearBackground(),
        ],
      ),
    );
  }
}

class EditDeleteIcons extends StatelessWidget {
  final String cardNumbers;
  final String cardType;
  final String expDate;
  final bool isFromDelete;
  final String cardId;
  final bool isExpired;
  final int index;
  const EditDeleteIcons(
      {super.key,
      required this.cardNumbers,
      required this.cardType,
      required this.expDate,
      required this.isFromDelete,
      required this.cardId,
      required this.isExpired,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            height: 27,
            decoration: const BoxDecoration(
                color: AppColors.darkOrange, shape: BoxShape.circle),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BlocProvider<ProfileCubit>.value(
                        value: context.read<ProfileCubit>(),
                        child: AddNewCardScreen(
                          index: index,
                        )),
                  ));
                },
                icon: const Icon(
                  Icons.edit,
                  size: 12,
                  color: AppColors.white,
                ))),
        Container(
          height: 27,
          decoration:
              const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
          child: IconButton(
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: context.read<ProfileCubit>()..clearPaymentFormData(),
                  child: BlocConsumer<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state is DeleteSavedCardsErrorState) {
                        defaultErrorSnackBar(
                            context: context, message: state.errMsg);
                      } else if (state is DeleteSavedCardsSuccessState) {
                        if (Navigator.of(dialogContext).canPop()) {
                          Navigator.of(dialogContext).pop();
                        }
                      }
                    },
                    builder: (context, state) {
                      return DefaultDialog(
                        title: "Are you sure you want to delete this card?",
                        widgetCard: SavedPaymentCardItem(
                          isExpired: isExpired,
                          cardId: cardId,
                          cardType: cardType,
                          cardNumbers: cardNumbers,
                          expDate: expDate,
                          isFromDelete: true,
                          index: index,
                        ),
                        loading: state is DeleteSavedCardsLoadingState,
                        onSecondButtonTapped: () {
                          context
                              .read<ProfileCubit>()
                              .deleteCardFromSaved(cardId);
                        },
                        secondButtonColor: AppColors.darkRed,
                      );
                    },
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.delete,
              size: 12,
              color: AppColors.white,
            ),
          ),
        )
      ],
    );
  }
}

class DefaultCardButton extends StatelessWidget {
  final bool isDefault;
  final String cardId;
  final int index;
  final bool isLoading;
  final bool isExpired;
  final bool isFromDelete;

  const DefaultCardButton(
      {super.key,
      required this.isDefault,
      required this.cardId,
      required this.index,
      required this.isLoading,
      required this.isExpired,
      required this.isFromDelete});

  @override
  Widget build(BuildContext context) {
    if (isDefault == true && isExpired == false) {
      return Container(
        width: 87,
        height: 20,
        decoration: BoxDecoration(
          color: AppColors.darkGreen.withOpacity(0.30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
          "Default",
          style: AppFonts.ibm11Grey400.copyWith(color: AppColors.green),
        )),
      );
    } else if (isDefault == false &&
        isExpired == false &&
        isFromDelete == false) {
          print("hhhhh");
      return isLoading
          ? const SizedBox(
              height: 24,
              width: 100,
              child: Center(
                child: SizedBox(
                    height: 24, width: 24, child: CircularProgressIndicator()),
              ),
            )
          : SizedBox(
              height: 24,
              width: 100,
              child: DefaultButton(
                function: () {
                  context.read<ProfileCubit>().setDefaultCard(cardId, index);
                },
                text: "Set as default",
                textStyle:
                    AppFonts.ibm11Grey400.copyWith(color: AppColors.white),
              ),
            );
    } else if (isFromDelete && isExpired == false) {
      return const SizedBox();
    } else {
      return Container(
        width: 87,
        height: 20,
        decoration: BoxDecoration(
          color: AppColors.red.withOpacity(0.30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
          "Expired",
          style: AppFonts.ibm11Grey400.copyWith(color: AppColors.red),
        )),
      );
    }
  }
}

Widget savedCardLinearBackground() {
  return IgnorePointer(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.center,
          colors: [
            Colors.white10,
            Colors.white10,
          ],
        ),
      ),
    ),
  );
}

SvgPicture getCardTypeIcon(String cardType) {
  switch (cardType) {
    case "visa":
      return SvgPicture.asset(
        "assets/images/visa.svg",
      );
    case "mastercard":
      return SvgPicture.asset(
        "assets/images/masterCard.svg",
      );
    case "amex":
      return SvgPicture.asset(
        "assets/images/americanExpress.svg",
      );
    default:
      return SvgPicture.asset('assets/images/card.svg');
  }
}

Widget savedCardBackground() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.center,
        colors: [
          AppColors.white.withOpacity(0.4),
          AppColors.white.withOpacity(0.4),
        ],
      ),
    ),
  );
}

class FourStars extends StatelessWidget {
  const FourStars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Text(
        "****",
        style: AppFonts.ibm12SubTextGrey600.copyWith(
          color: AppColors.lightBlack,
        ),
      ),
    );
  }
}

class AddNewCardButton extends StatelessWidget {
  const AddNewCardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
      key: const ValueKey<String>("AddNewCardKey"),
      marginBottom: 40,
      marginTop: 32,
      marginLeft: 20,
      marginRight: 20,
      function: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BlocProvider<ProfileCubit>.value(
              value: context.read<ProfileCubit>()..savedCardsInit(),
              child: const AddNewCardScreen()),
        ));
      },
      text: "Add New Card",
    );
  }
}

class CardsRow extends StatelessWidget {
  const CardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/visa.svg'),
        SvgPicture.asset('assets/images/americanExpress.svg'),
        SvgPicture.asset('assets/images/masterCard.svg'),
      ],
    );
  }
}
