import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:turbo/blocs/orders/order_cubit.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/edit_request.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/snackbar.dart';
import '../orders_screen.dart';

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
            DefaultHeader(
              header: "#$requestCode",
              textAlignment: AlignmentDirectional.center,
              alignment: MainAxisAlignment.spaceBetween,
              suffixIcon: BlocBuilder<OrderCubit, OrderState>(
                buildWhen: (previous, current) =>
                    current is GetRequestStatusSuccessState ||
                    current is GetRequestStatusErrorState ||
                    current is GetRequestStatusLoadingState,
                builder: (context, state) {
                  return (context.watch<OrderCubit>().requestStatus != null &&
                          (context
                                      .watch<OrderCubit>()
                                      .requestStatus!
                                      .requestStatus ==
                                  2 ||
                              context
                                      .watch<OrderCubit>()
                                      .requestStatus!
                                      .requestStatus ==
                                  4 ||
                              context
                                      .watch<OrderCubit>()
                                      .requestStatus!
                                      .requestStatus ==
                                  0))
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.cancel_outlined,
                          ),
                          color: AppColors.primaryBlue,
                          onPressed: () {
                            showAdaptiveDialog(
                              context: context,
                              builder: (dialogContext) => BlocProvider.value(
                                value: context.read<OrderCubit>(),
                                child: EditRequestStatusDialog(
                                  requestId: requestId,
                                  requestStatus: 5,
                                  reason: "cancel",
                                  orderCubit: orderCubit,
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox();
                },
              ),
            ),
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
                }
              },
              buildWhen: (previous, current) =>
                  current is GetRequestStatusSuccessState ||
                  current is GetRequestStatusErrorState ||
                  current is GetRequestStatusLoadingState,
              builder: (context, state) {
                print("sssasssasdasd");
                var blocWatch = context.watch<OrderCubit>();
                if (state is GetRequestStatusLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (blocWatch.requestStatus != null) {
                  if (blocWatch.requestStatus!.requestStatus == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/images/pending_request.jpg"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "We are reviewing your documents and will notify you once the review is complete.",
                            style: AppFonts.ibm16LightBlack600.copyWith(
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else if (blocWatch.requestStatus!.requestStatus == 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Lottie.asset("assets/lottie/luxury_car_loading.json"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Congratulations! Your car rental request is approved!.",
                            style: AppFonts.ibm16LightBlack600.copyWith(
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else if (blocWatch.requestStatus!.requestStatus == 3) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Congratulations! Your refund is created successfully, please follow up with your bank within 21 days",
                        style: AppFonts.ibm16LightBlack600.copyWith(
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (blocWatch.requestStatus!.requestStatus == 2 ||
                      blocWatch.requestStatus!.requestStatus == 4) {
                    return RepositoryProvider<AuthRepository>.value(
                      value: getIt<AuthRepository>(),
                      child: const EditRequest(),
                    );
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
}
