import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/presentation/layout/profile/widgets/saved_cards_widgets.dart';
import '../../../../../core/helpers/constants.dart';
import '../../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../../core/widgets/custom_header.dart';

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
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const DefaultHeader(
                header: "Payment Methods",
                textAlignment: AlignmentDirectional.center,
                alignment: MainAxisAlignment.spaceBetween,
                // isShowPrefixIcon: true,
                // suffixIcon: BlocBuilder<ProfileCubit, ProfileState>(
                //   buildWhen: (previous, current) =>
                //       current is GetAllSavedCardsSuccessState ||
                //       current is GetAllSavedCardsLoadingState ||
                //       current is GetAllSavedCardsErrorState ||
                //       current is ChangeEditSavedCardsValueState ||
                //       current is ChangeSelectCardToBeDeletedState ||
                //       current is DeleteSavedCardsSuccessState ||
                //       current is DeleteSavedCardsErrorState ||
                //       current is DeleteSavedCardsLoadingState,
                //   builder: (context, state) {
                //     return context
                //                 .watch<ProfileCubit>()
                //                 .savedPaymentCards
                //                 .isNotEmpty ||
                //             state is DeleteSavedCardsLoadingState
                //         ? InkWell(
                //             splashColor: Colors.transparent,
                //             focusColor: Colors.transparent,
                //             highlightColor: Colors.transparent,
                //             hoverColor: Colors.transparent,
                //             onTap: () {
                //               blocRead.changeIsEditingSavedCardsValue();
                //             },
                //             child: Padding(
                //               padding: const EdgeInsets.only(right: 20.0),
                //               child: Text(
                //                 context
                //                         .watch<ProfileCubit>()
                //                         .isEditingSavedCards
                //                     ? "Done"
                //                     : "Edit",
                //                 style: AppFonts.inter14TextBlack500.copyWith(
                //                   fontSize: 16,
                //                   color: AppColors.primaryBlue,
                //                 ),
                //               ),
                //             ),
                //           )
                //         : const SizedBox.shrink();
                //   },
                // ),
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
                  Widget content;
                  if (state is GetAllSavedCardsLoadingState) {
                    content = const Expanded(
                      child:  Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is GetAllSavedCardsErrorState) {
                    content = const SizedBox();
                  } else if (blocWatch.savedPaymentCards.isNotEmpty) {
                    content = Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        itemBuilder: (context, index) =>
                            SavedPaymentCardItem(
                              //todo
                              cardType: 'visa',
                              cardId: blocRead.savedPaymentCards[index].id,
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
                    );
                  } else {
                    content = const EmptySavedCards();
                  }
                  return Expanded(
                    child: Column(
                      children: [
                        content,
                        const AddNewCardButton()
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
