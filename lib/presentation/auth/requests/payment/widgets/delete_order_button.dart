import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/orders/order_cubit.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../layout/orders/request_status/widgets/edit_request_dialog.dart';

class DeleteOrderButton extends StatelessWidget {
  const DeleteOrderButton({
    super.key,
    required this.orderCubit,
    required this.carRequestId,
  });

  final OrderCubit? orderCubit;
  final String carRequestId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Container(
        height: 46,
        width: 46,
        margin: const EdgeInsetsDirectional.only(end: 10),
        decoration: BoxDecoration(
          color: AppColors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 2),
                color: AppColors.black.withOpacity(0.15)),
            BoxShadow(
                blurRadius: 2,
                spreadRadius: 0,
                offset: const Offset(0, 1),
                color: AppColors.black.withOpacity(0.30))
          ],
        ),
        child: const Icon(
          Icons.close_rounded,
          color: AppColors.white,
        ),
      ),
      color: AppColors.primaryBlue,
      onPressed: () {
        showAdaptiveDialog(
          context: context,
          builder: (dialogContext) =>
          BlocProvider<OrderCubit>.value(
            value: orderCubit!,
            child: EditRequestStatusDialog(
              requestId: carRequestId,
              requestStatus: 6,
              reason: "delete",
              orderCubit: orderCubit!,
              isFromPayment: true,
            ),
          ),
        );
      },
    );
  }
}
