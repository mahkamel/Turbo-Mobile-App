import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/presentation/layout/profile/widgets/saved_cards_widgets.dart';
import '../../../../../core/helpers/constants.dart';
import '../../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../../core/widgets/custom_header.dart';

class SavedCardsScreen extends StatelessWidget {
  const SavedCardsScreen({super.key});
  bool isExpiredCard(int expiryMonth, int expiryYear) {
    int year = DateTime.now().year % 100;
    int month = DateTime.now().month;
    if (expiryYear < year) {
      return true;
    } else if (expiryYear == year && expiryMonth < month) {
      return true;
    } else {
    return false;
  }
  }

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
              const DefaultHeader(
                header: "Payment Methods",
                textAlignment: AlignmentDirectional.center,
                alignment: MainAxisAlignment.spaceBetween,
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
                              isExpired: isExpiredCard(
                                int.parse(blocRead.savedPaymentCards[index].visaCardExpiryMonth),
                                int.parse(blocRead.savedPaymentCards[index].visaCardExpiryYear)
                              ),
                              index: index,
                              cardType: blocRead
                              .savedPaymentCards[index].visaCardType,
                              isDefault: blocRead
                              .savedPaymentCards[index].isCardDefault,
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
