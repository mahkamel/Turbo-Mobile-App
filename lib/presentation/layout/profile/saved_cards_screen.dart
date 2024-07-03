import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/presentation/layout/profile/widgets/saved_cards_widgets.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../core/theming/fonts.dart';
import '../../../core/widgets/custom_header.dart';
import '../../../core/widgets/default_buttons.dart';
import 'add_new_card_screen.dart';

class SavedCardsScreen extends StatelessWidget {
  const SavedCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<ProfileCubit>();
    return Scaffold(
      body: SizedBox(
        height: AppConstants.screenHeight(context),
        width: AppConstants.screenWidth(context),
        child: SafeArea(
          child: Column(
            children: [
              DefaultHeader(
                header: "Saved Cards",
                textAlignment: AlignmentDirectional.center,
                alignment: MainAxisAlignment.spaceBetween,
                isShowPrefixIcon: true,
                suffixIcon: BlocBuilder<ProfileCubit, ProfileState>(
                  buildWhen: (previous, current) =>
                      current is GetAllSavedCardsSuccessState ||
                      current is GetAllSavedCardsLoadingState ||
                      current is GetAllSavedCardsErrorState ||
                      current is ChangeEditSavedCardsValueState ||
                      current is ChangeSelectCardToBeDeletedState ||
                      current is DeleteSavedCardsSuccessState ||
                      current is DeleteSavedCardsErrorState ||
                      current is DeleteSavedCardsLoadingState,
                  builder: (context, state) {
                    return context
                                .watch<ProfileCubit>()
                                .savedPaymentCards
                                .isNotEmpty ||
                            state is DeleteSavedCardsLoadingState
                        ? InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () {
                              blocRead.changeIsEditingSavedCardsValue();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                context
                                        .watch<ProfileCubit>()
                                        .isEditingSavedCards
                                    ? "Done"
                                    : "Edit",
                                style: AppFonts.inter14TextBlack500.copyWith(
                                  fontSize: 16,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                buildWhen: (previous, current) =>
                    current is GetAllSavedCardsSuccessState ||
                    current is GetAllSavedCardsLoadingState ||
                    current is GetAllSavedCardsErrorState ||
                    current is ChangeEditSavedCardsValueState ||
                    current is ChangeSelectCardToBeDeletedState ||
                    current is DeleteSavedCardsSuccessState ||
                    current is DeleteSavedCardsErrorState,
                builder: (context, state) {
                  var blocWatch = context.watch<ProfileCubit>();
                  if (state is GetAllSavedCardsLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetAllSavedCardsErrorState) {
                    return const SizedBox();
                  } else if (blocWatch.savedPaymentCards.isNotEmpty) {
                    return Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              itemBuilder: (context, index) =>
                                  SavedPaymentCardItem(
                                isCheckToBeDeleted: blocWatch
                                    .savedPaymentCards[index].isSelected,
                                onChanged: (value) {
                                  blocRead.changeSelectCardToDeleteValue(index);
                                },
                                isEditing: blocWatch.isEditingSavedCards,
                                name: blocRead
                                    .savedPaymentCards[index].visaCardName,
                                cardNumbers: blocRead
                                    .savedPaymentCards[index].visaCardNumber,
                                expDate:
                                    "${blocRead.savedPaymentCards[index].visaCardExpiryMonth}/${blocRead.savedPaymentCards[index].visaCardExpiryYear}",
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 16,
                              ),
                              itemCount: blocWatch.savedPaymentCards.length,
                            ),
                          ),
                          // const Spacer(),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            child: blocWatch.isEditingSavedCards &&
                                    blocWatch
                                        .savedCardsIdsToBeDeleted.isNotEmpty
                                ? DefaultButton(
                                    key:
                                        const ValueKey<String>("DeleteCardKey"),
                                    marginBottom: 40,
                                    marginTop: 32,
                                    marginLeft: 20,
                                    marginRight: 20,
                                    color: AppColors.errorRed,
                                    function: () {
                                      showAdaptiveDialog(
                                        context: context,
                                        builder: (_) =>
                                            BlocProvider<ProfileCubit>.value(
                                          value: context.read<ProfileCubit>()
                                            ..clearPaymentFormData(),
                                          child: DeleteCardsDialog(
                                              blocRead: blocRead),
                                        ),
                                      );
                                    },
                                    textWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            "Delete",
                                            style: AppFonts.inter18White500,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Icon(
                                          Icons.delete_forever_rounded,
                                          color: AppColors.white,
                                        )
                                      ],
                                    ),
                                  )
                                : DefaultButton(
                                    key:
                                        const ValueKey<String>("AddNewCardKey"),
                                    marginBottom: 40,
                                    marginTop: 32,
                                    marginLeft: 20,
                                    marginRight: 20,
                                    function: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (_) =>
                                            BlocProvider<ProfileCubit>.value(
                                                value:
                                                    context.read<ProfileCubit>()
                                                      ..savedCardsInit(),
                                                child:
                                                    const AddNewCardScreen()),
                                      ));
                                    },
                                    text: "Add New Card",
                                  ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const EmptySavedCards();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteCardsDialog extends StatelessWidget {
  const DeleteCardsDialog({
    super.key,
    required this.blocRead,
  });

  final ProfileCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(0, 4),
              color: AppColors.black.withOpacity(0.05),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              "Confirmation Required",
              style: AppFonts.inter18Black500,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 20,
              ),
              child: Text(
                "Are you sure you want to delete this saved credit card? This action cannot be undone.",
                style: AppFonts.inter14Grey400,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DefaultButton(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.primaryGreen),
                    textColor: AppColors.primaryGreen,
                    function: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                Expanded(
                  child: DefaultButton(
                    color: AppColors.errorRed,
                    function: () {
                      blocRead.deleteCardFromSaved();
                      Navigator.pop(context);
                    },
                    text: "Delete",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
