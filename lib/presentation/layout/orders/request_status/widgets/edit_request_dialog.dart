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
    this.isFromPayment = false,
  });

  final String reason;
  final String requestId;
  final int requestStatus;
  final OrderCubit? orderCubit;
  final bool isFromPayment;

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
          horizontal: 34,
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 34,
              ),
              child: Text(
                "Are you sure you want to $reason your order?",
                style: AppFonts.ibm24HeaderBlue600,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<OrderCubit, OrderState>(
                    buildWhen: (previous, current) =>
                        current is SubmitEditStatusLoadingState ||
                        current is SubmitEditStatusErrorState ||
                        current is SubmitEditStatusSuccessState,
                    builder: (blocContext, state) {
                      return DefaultButton(
                        loading: state is SubmitEditStatusLoadingState,
                        border: Border.all(color: AppColors.darkRed),
                        textColor: AppColors.darkRed,
                        color: AppColors.white,
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
                              if (isFromPayment) {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              }
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
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: DefaultButton(
                    color: AppColors.primaryBlue,
                    textColor: AppColors.white,
                    function: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
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
