import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../blocs/profile_cubit/profile_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../screens/add_new_card_screen.dart';

class EmptySavedCards extends StatelessWidget {
  const EmptySavedCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppConstants.heightBasedOnFigmaDevice(context, 48),
        ),
        Lottie.asset(
          "assets/lottie/card.json",
          height: AppConstants.heightBasedOnFigmaDevice(context, 340),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          child: Column(
            children: [
              Text(
                "Add your first credit card for payment",
                textAlign: TextAlign.center,
                style: AppFonts.ibm24HeaderBlue600,
              ),
              const SizedBox(height: 10,),
              Text(
                "This credit card will be used by default for billing.",
                textAlign: TextAlign.center,
                style: AppFonts.ibm12SubTextGrey600,
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: DefaultButton(
        //     function: () {
        //       Navigator.of(context).push(MaterialPageRoute(
        //         builder: (_) => BlocProvider<ProfileCubit>.value(
        //             value: context.read<ProfileCubit>()..savedCardsInit(),
        //             child: const AddNewCardScreen()),
        //       ));
        //     },
        //     text: "Add A Card",
        //   ),
        // ),
      ],
    );
  }
}

class SavedPaymentCardItem extends StatelessWidget {
  const SavedPaymentCardItem({
    super.key,
    required this.name,
    required this.cardNumbers,
    required this.expDate,
    this.isEditing = true,
    required this.isCheckToBeDeleted,
    required this.onChanged,
  });

  final String name;
  final String cardNumbers;
  final String expDate;
  final bool isEditing;
  final bool isCheckToBeDeleted;
  final void Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.screenWidth(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isEditing)
            Checkbox(
              value: isCheckToBeDeleted,
              onChanged: onChanged,
            ),
          if (!isEditing)
            const SizedBox(
              width: 20,
            ),
          Container(
            // curve: Curves.easeInOut,
            // duration: const Duration(milliseconds: 150),\
            height: 160,
            width: isEditing
                ? AppConstants.screenWidth(context) - 68
                : AppConstants.screenWidth(context) - 40,
            decoration: BoxDecoration(
              color: AppColors.buttonGreyBorder.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.center,
                      colors: [
                        AppColors.white.withOpacity(0.4),
                        AppColors.white.withOpacity(0.4),
                        // AppColors.buttonGreyBorder.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.inter18White500.copyWith(
                          color: AppColors.bottomSheetGrey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FourStars(),
                            const FourStars(),
                            const FourStars(),
                            Text(
                              cardNumbers,
                              style: AppFonts.inter24White600.copyWith(
                                color: AppColors.bottomSheetGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Exp date",
                              style: AppFonts.ibm12SubTextGrey600.copyWith(
                                color: AppColors.black.withOpacity(0.4),
                              ),
                            ),
                            Text(
                              expDate,
                              style: AppFonts.inter14White500.copyWith(
                                color: AppColors.bottomSheetGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}

class FourStars extends StatelessWidget {
  const FourStars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        "****",
        style: AppFonts.inter24White600.copyWith(
          color: AppColors.bottomSheetGrey,
        ),
      ),
    );
  }
}
