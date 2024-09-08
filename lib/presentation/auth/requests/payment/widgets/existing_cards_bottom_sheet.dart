import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/services/networking/repositories/payment_repository.dart';
import 'package:turbo/presentation/layout/profile/screens/add_new_card_screen.dart';

import '../../../../../blocs/payment/payment_cubit.dart';
import '../../../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/constants.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/container_with_shadow.dart';
import '../../../../../core/widgets/default_buttons.dart';

class ExistingCardsBottomSheet extends StatelessWidget {
  const ExistingCardsBottomSheet({
    super.key,
    required this.blocRead,
    required this.bottomSheetContext,
  });

  final PaymentCubit blocRead;
  final BuildContext bottomSheetContext;

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWithShadow(
      padding: const EdgeInsets.only(left: 20),
      height: double.infinity,
      width: AppConstants.screenWidth(context),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 33.0,
              right: 8.0,
              bottom: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: SizedBox(
                    width: AppConstants.screenWidth(context) - 100,
                    child: Text(
                      "Choose payment method",
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.inter18BottomSheetGrey400,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.bottomSheetCloseGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "EXISTING CARDS",
            style: AppFonts.inter14BottomSheetDarkerGrey100,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12.0),
              itemCount: getIt<PaymentRepository>().savedPaymentCards.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  blocRead.onSavedCardSelected(
                    getIt<PaymentRepository>().savedPaymentCards[index],
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(
                    top: index == 0 ? 10 : 20,
                    right: 34,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: AppColors.savedCardsBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          getIt<PaymentRepository>()
                              .savedPaymentCards[index]
                              .visaCardName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "**** `${getIt<PaymentRepository>().savedPaymentCards[index].visaCardNumber}",
                        style: AppFonts.inter16BottomSheetGreyGrey100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [

              Expanded(
                child: DefaultButton(
                  function: () {
                    Navigator.of(bottomSheetContext).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider<ProfileCubit>.value(
                          value: getIt<ProfileCubit>()..savedCardsInit(),
                          child: const AddNewCardScreen()),
                    ));
                  },
                  borderRadius: 0,
                  marginRight: 20,
                  marginBottom: 34,
                  marginTop: 12.0,
                  color: AppColors.primaryBlue,
                  // border: Border.all(
                  //   color: AppColors.buttonGreyBorder,
                  // ),
                  textColor: AppColors.white,
                  text: "Add New Card",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
