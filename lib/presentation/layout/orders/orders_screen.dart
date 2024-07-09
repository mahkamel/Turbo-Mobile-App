import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turbo/blocs/localization/cubit/localization_cubit.dart';
import 'package:turbo/core/helpers/extentions.dart';
import 'package:turbo/core/helpers/functions.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/models/request_model.dart';
import 'package:turbo/presentation/layout/home/widgets/car_image.dart';

import '../../../blocs/orders/order_cubit.dart';
import '../../../core/helpers/constants.dart';
import '../../../core/routing/routes.dart';
import '../../../core/routing/screens_arguments.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.screenWidth(context),
      height: AppConstants.screenHeight(context),
      child: Column(
        children: [
          const DefaultHeader(
            header: "Orders Screen",
            textAlignment: AlignmentDirectional.center,
            isShowPrefixIcon: false,
          ),
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<OrderCubit, OrderState>(
            buildWhen: (previous, current) =>
                current is GetAllRequestsLoadingState ||
                current is GetAllRequestsErrorState ||
                current is GetAllRequestsSuccessState,
            builder: (context, state) {
              List<RequestModel> allRequests =
                  context.watch<OrderCubit>().allRequests;
              return state is GetAllRequestsLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryRed,
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<OrderCubit>().getAllCustomerRequests();
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 20,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  Routes.editRequestScreen,
                                  arguments: RequestStatusScreenArguments(
                                    requestId: allRequests[index].id,
                                  ),
                                );
                              },
                              child: Container(
                                width: AppConstants.screenWidth(context) - 32,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                margin: const EdgeInsets.only(bottom: 4),
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.black.withOpacity(0.1),
                                        offset: const Offset(0, 3),
                                        blurRadius: 8,
                                        spreadRadius: 0),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CarImage(
                                      carImgPath:
                                          "https://images.unsplash.com/photo-1489824904134-891ab64532f1?q=80&w=2531&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      allRequests[index]
                                          .requestCarId
                                          .last
                                          .carId
                                          .carName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.inter16Black500,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 2.0,
                                        bottom: 4.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            allRequests[index].requestLocation,
                                          ),
                                          if (allRequests[index].requestDriver)
                                            SvgPicture.asset(
                                              "assets/images/icons/chauffeur.svg",
                                              height: 24,
                                              width: 24,
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: "From: ",
                                        style: AppFonts.inter16Black500
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                        children: [
                                          TextSpan(
                                            text: formatDateTime(
                                              allRequests[index].requestFrom,
                                              locale: context
                                                  .read<LocalizationCubit>()
                                                  .state
                                                  .locale
                                                  .languageCode,
                                            ),
                                            style: AppFonts.inter14Black400
                                                .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: "To: ",
                                        style: AppFonts.inter16Black500
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                        children: [
                                          TextSpan(
                                            text: formatDateTime(
                                              allRequests[index].requestTo,
                                              locale: context
                                                  .read<LocalizationCubit>()
                                                  .state
                                                  .locale
                                                  .languageCode,
                                            ),
                                            style: AppFonts.inter14Black400
                                                .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "2000 ${"SAR".getLocale()}",
                                      style: AppFonts.inter16Black500.copyWith(
                                          color: AppColors.primaryRed,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 16,
                          ),
                          itemCount: allRequests.length,
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
