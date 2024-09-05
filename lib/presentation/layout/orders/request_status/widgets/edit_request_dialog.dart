import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/orders/order_cubit.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/default_buttons.dart';

class EditRequestStatusDialog extends StatelessWidget {
  const EditRequestStatusDialog({
    super.key,
    required this.reason,
    required this.requestId,
    required this.requestStatus,
    this.orderCubit,
  });

  final String reason;
  final String requestId;
  final int requestStatus;
  final OrderCubit? orderCubit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
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
              height: 16,
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
                "Are you sure you want to $reason this request? This action cannot be undone.",
                style: AppFonts.ibm11Grey400,
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
                  child: BlocBuilder<OrderCubit, OrderState>(
                    buildWhen: (previous, current) =>
                        current is SubmitEditStatusLoadingState ||
                        current is SubmitEditStatusErrorState ||
                        current is SubmitEditStatusSuccessState,
                    builder: (blocContext, state) {
                      return DefaultButton(
                        loading: state is SubmitEditStatusLoadingState,
                        color: AppColors.errorRed,
                        function: () async {
                          if (state is! SubmitEditsLoadingState) {
                            blocContext
                                .read<OrderCubit>()
                                .editRequestStatus(
                                  requestId: requestId,
                                  requestStatus: requestStatus,
                                )
                                .then((_) {
                              Navigator.pop(context);
                              if (reason == "cancel") {
                                if (orderCubit != null) {
                                  orderCubit!.getAllCustomerRequests();
                                }
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                        text: "Confirm",
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
