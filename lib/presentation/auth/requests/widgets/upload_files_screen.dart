import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/presentation/auth/requests/widgets/signup_confirm_widgets.dart';

import '../../../../blocs/signup/signup_cubit.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/routing/screens_arguments.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/snackbar.dart';

class UploadFilesStep extends StatelessWidget {
  const UploadFilesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final blocRead = context.read<SignupCubit>();
    var blocWatch = context.watch<SignupCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Expanded(child: RequiredFilesSection()),
        BlocConsumer<SignupCubit, SignupState>(
          listenWhen: (previous, current) =>
              current is ConfirmBookingErrorState ||
              current is ConfirmBookingSuccessState,
          listener: (context, state) {
            if (state is ConfirmBookingErrorState) {
              defaultErrorSnackBar(context: context, message: state.errMsg);
            } else if (state is ConfirmBookingSuccessState) {
              Navigator.of(context).pushReplacementNamed(
                Routes.paymentScreen,
                arguments: PaymentScreenArguments(
                  paymentAmount: blocRead.calculatedPriceWithVat,
                  carRequestId: state.requestId,
                  carRequestCode: state.registerCode,
                ),
              );
            }
          },
          builder: (context, state) {
            return DefaultButton(
              loading: state is ConfirmBookingLoadingState,
              marginRight: 16,
              marginLeft: 16,
              marginTop: 24,
              marginBottom: 24,
              color: blocWatch.nationalIdInitStatus != 2 &&
                      blocWatch.passportInitStatus != 2 &&
                      ((blocWatch.nationalIdInitStatus != -1 &&
                              blocWatch.passportInitStatus != -1) ||
                          blocRead.isSaudiOrSaudiResident())
                  ? AppColors.primaryBlue
                  : AppColors.greyBorder,
              text: "Confirm Booking",
              function: () {
                if (state is! ConfirmBookingLoadingState &&
                    state is! SaveRequestEditedFileLoadingState &&
                    blocWatch.nationalIdInitStatus != 2 &&
                    blocWatch.passportInitStatus != 2 &&
                    ((blocWatch.nationalIdInitStatus != -1 &&
                            blocWatch.passportInitStatus != -1) ||
                        blocRead.isSaudiOrSaudiResident())) {
                  blocRead.confirmBookingClicked();
                }
              },
            );
          },
        )
      ],
    );
  }
}
