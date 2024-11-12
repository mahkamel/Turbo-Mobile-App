import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/helpers/extentions.dart';

import '../../../../blocs/car_details/car_details_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/routing/screens_arguments.dart';
import '../../../../core/services/networking/repositories/auth_repository.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../models/car_details_model.dart';

class BookNowButton extends StatelessWidget {
  const BookNowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        color: AppColors.white,
        child: BlocBuilder<CarDetailsCubit, CarDetailsState>(
            buildWhen: (previous, current) =>
                current is GetCarsDetailsErrorState ||
                current is GetCarsDetailsLoadingState ||
                current is GetCarsDetailsSuccessState ||
                current is RefreshCustomerDataLoadingState ||
                current is RefreshCustomerDataErrorState ||
                current is RefreshCustomerDataSuccessState,
            builder: (context, state) {
              var carDetailsData =
                  context.watch<CarDetailsCubit>().carDetailsData;
              var blocRead = context.read<CarDetailsCubit>();
              if (carDetailsData.id.isEmpty) {
                return const SizedBox();
              } else {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: DefaultButton(
                    loading: state is RefreshCustomerDataLoadingState,
                    marginTop: 20,
                    marginBottom: 20,
                    marginRight: 16,
                    marginLeft: 16,
                    color: AppColors.primaryBlue,
                    function: () async {
                      if (context
                          .read<AuthRepository>()
                          .customer
                          .token
                          .isEmpty) {
                        loginRequiredBottomSheet(context, carDetailsData);
                      } else {
                        if (state is! RefreshCustomerDataLoadingState) {
                          await blocRead.refreshCustomerData().then(
                                (value) => Navigator.pushNamed(
                                  context,
                                  Routes.signupScreen,
                                  arguments: SignupScreenArguments(
                                    carId: carDetailsData.id,
                                    dailyPrice:
                                        blocRead.carDetailsData.carDailyPrice,
                                    weeklyPrice:
                                        blocRead.carDetailsData.carWeaklyPrice,
                                    monthlyPrice:
                                        blocRead.carDetailsData.carMothlyPrice,
                                    carColor: blocRead.carDetailsData.carColor,
                                  ),
                                ),
                              );
                        }
                      }
                    },
                    text: "bookNow".getLocale(context: context),
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<dynamic> loginRequiredBottomSheet(
    BuildContext context,
    CarDetailsData carDetailsData,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (bsContext) {
        return Container(
          width: AppConstants.screenWidth(bsContext),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: AppColors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "loginRequiredTitle".getLocale(context: context),
                style: AppFonts.ibm24HeaderBlue600,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 24.0,
                ),
                child: Text(
                  "loginRequiredContent".getLocale(context: context),
                  style: AppFonts.ibm11Grey400.copyWith(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: AppConstants.screenWidth(context),
                child: Row(
                  children: [
                    Expanded(
                        child: DefaultButton(
                      text: "Cancel",
                      color: AppColors.white,
                      textColor: AppColors.primaryBlue,
                      border: Border.all(color: AppColors.primaryBlue),
                      function: () {
                        Navigator.of(bsContext).pop();
                      },
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: DefaultButton(
                        color: AppColors.primaryBlue,
                        function: () {
                          Navigator.of(bsContext).pop();
                          Navigator.pushNamed(
                            context,
                            Routes.loginScreen,
                            arguments: LoginScreenArguments(
                              carId: carDetailsData.id,
                              dailyPrice: carDetailsData.carDailyPrice,
                              weeklyPrice: carDetailsData.carWeaklyPrice,
                              monthlyPrice: carDetailsData.carMothlyPrice,
                              carColor: carDetailsData.carColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
