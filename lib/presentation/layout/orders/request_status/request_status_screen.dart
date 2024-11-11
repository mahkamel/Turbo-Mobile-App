import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/orders/order_cubit.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/theming/colors.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/edit_request.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/edit_request_dialog.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/request_status/booking_approved.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/request_status/request_cancelled.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/request_status/request_pending.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/request_status/request_refund.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/snackbar.dart';

class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({
    super.key,
    required this.requestId,
    required this.requestCode,
    required this.orderCubit,
  });

  final String requestId;
  final String requestCode;
  final OrderCubit orderCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            _buildRequestStatusHeader(),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<OrderCubit, OrderState>(
              listener: (context, state) {
                if (state is SaveEditedDataErrorState) {
                  defaultErrorSnackBar(context: context, message: state.errMsg);
                } else if (state is GetRequestStatusErrorState) {
                  defaultErrorSnackBar(context: context, message: state.errMsg);
                } else if (state is SaveEditedDataSuccessState) {
                  defaultSuccessSnackBar(
                    context: context,
                    message: "Your Data has been saved Successfully",
                  );
                } else if (state is SubmitEditsSuccessState) {
                  orderCubit.getAllCustomerRequests();
                }
              },
              buildWhen: (previous, current) =>
                  current is GetRequestStatusSuccessState ||
                  current is GetRequestStatusErrorState ||
                  current is GetRequestStatusLoadingState,
              builder: (context, state) {
                var blocWatch = context.watch<OrderCubit>();
                if (state is GetRequestStatusLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (blocWatch.requestStatus != null) {
                  if (blocWatch.requestStatus!.requestStatus == 0) {
                    return const RequestPending();
                  } else if (blocWatch.requestStatus!.requestStatus == 1) {
                    return const BookingApprovedStatus();
                  } else if (blocWatch.requestStatus!.requestStatus == 3) {
                    return const RequestRefunded();
                  } else if (blocWatch.requestStatus!.requestStatus == 2 ||
                      blocWatch.requestStatus!.requestStatus == 4) {
                    return RepositoryProvider<AuthRepository>.value(
                      value: getIt<AuthRepository>(),
                      child: const EditRequest(),
                    );
                  } else if (blocWatch.requestStatus!.requestStatus == 5) {
                    return const RequestCancelled();
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  DefaultHeader _buildRequestStatusHeader() {
    return DefaultHeader(
      header: "#$requestCode",
      textAlignment: AlignmentDirectional.center,
      alignment: MainAxisAlignment.spaceBetween,
      suffixIcon: CancelOrderButton(
        requestId: requestId,
        orderCubit: orderCubit,
      ),
    );
  }
}

class CancelOrderButton extends StatelessWidget {
  const CancelOrderButton({
    super.key,
    required this.requestId,
    this.reason = "cancel",
    this.reasonCode = 5,
    this.orderCubit,
  });

  final String requestId;
  final String reason;
  final int reasonCode;
  final OrderCubit? orderCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (previous, current) =>
          current is GetRequestStatusSuccessState ||
          current is GetRequestStatusErrorState ||
          current is GetRequestStatusLoadingState,
      builder: (context, state) {
        return (context.watch<OrderCubit>().requestStatus != null &&
                (context.watch<OrderCubit>().requestStatus!.requestStatus ==
                        2 ||
                    context.watch<OrderCubit>().requestStatus!.requestStatus ==
                        4 ||
                    context.watch<OrderCubit>().requestStatus!.requestStatus ==
                        0))
            ? IconButton(
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
                    builder: (dialogContext) => BlocProvider.value(
                      value: context.read<OrderCubit>(),
                      child: EditRequestStatusDialog(
                        requestId: requestId,
                        requestStatus: reasonCode,
                        reason: reason,
                        orderCubit:orderCubit?? context.read<OrderCubit>(),
                      ),
                    ),
                  );
                },
              )
            : const SizedBox();
      },
    );
  }
}
