import 'package:cached_network_image/cached_network_image.dart';
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
import '../../../core/services/local/token_service.dart';
import '../../../core/services/networking/repositories/auth_repository.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: () async {
        await UserTokenService.getUserToken();
        if (UserTokenService.currentUserToken.isNotEmpty) {
          context.read<OrderCubit>().getAllCustomerRequests();
        }
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

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
          if (context.watch<AuthRepository>().customer.token.isNotEmpty)
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
                          child: allRequests.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 20,
                                    right: 16,
                                    left: 16,
                                  ),
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/no-data.svg",
                                      height: 350,
                                    ),
                                    Text(
                                      "You don't have any past rentals yet,\nExplore our wide selection of cars to find the perfect one for your next trip.",
                                      style: AppFonts.inter16Black400,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )
                              : ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 20,
                                    right: 16,
                                    left: 16,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        if (allRequests[index]
                                                .requestPaidStatus ==
                                            "paid") {
                                          Navigator.of(context).pushNamed(
                                            Routes.requestStatusScreen,
                                            arguments:
                                                RequestStatusScreenArguments(
                                              requestId: allRequests[index].id,
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).pushNamed(
                                            Routes.paymentScreen,
                                            arguments: PaymentScreenArguments(
                                              paymentAmount: allRequests[index]
                                                  .requestPrice,
                                              carRequestId:
                                                  allRequests[index].id,
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width:
                                            AppConstants.screenWidth(context) -
                                                32,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        margin:
                                            const EdgeInsets.only(bottom: 4),
                                        constraints: const BoxConstraints(
                                          maxWidth: 300,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColors.black
                                                    .withOpacity(0.1),
                                                offset: const Offset(0, 3),
                                                blurRadius: 8,
                                                spreadRadius: 0),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CarImage(
                                              carImgPath: allRequests[index]
                                                  .requestCarId
                                                  .last
                                                  .carId
                                                  .carMedia
                                                  .first
                                                  .mediaId
                                                  .mediaMediumImageUrl,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 24,
                                                  width: 24,
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .only(end: 2),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color:
                                                        AppColors.carCardGrey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          getCompleteFileUrl(
                                                        allRequests[index]
                                                            .requestCarId
                                                            .last
                                                            .carId
                                                            .carBrand
                                                            .brandPath,
                                                      ),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${allRequests[index].requestCarId.last.carId.carModel} ${allRequests[index].requestCarId.last.carId.carYear}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      AppFonts.inter16Black500,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2.0,
                                                bottom: 4.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    allRequests[index]
                                                        .requestLocation,
                                                  ),
                                                  if (allRequests[index]
                                                      .requestDriver)
                                                    SvgPicture.asset(
                                                      "assets/images/icons/chauffeur.svg",
                                                      height: 24,
                                                      width: 24,
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.date_range),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  formatDateTime(
                                                    allRequests[index]
                                                        .requestFrom,
                                                    locale: context
                                                        .read<
                                                            LocalizationCubit>()
                                                        .state
                                                        .locale
                                                        .languageCode,
                                                  ),
                                                  style: AppFonts
                                                      .inter14Black400
                                                      .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.date_range),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  formatDateTime(
                                                    allRequests[index]
                                                        .requestTo,
                                                    locale: context
                                                        .read<
                                                            LocalizationCubit>()
                                                        .state
                                                        .locale
                                                        .languageCode,
                                                  ),
                                                  style: AppFonts
                                                      .inter14Black400
                                                      .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${allRequests[index].requestPrice} ${"SAR".getLocale(context: context)}",
                                                  style: AppFonts
                                                      .inter16Black500
                                                      .copyWith(
                                                          color: AppColors
                                                              .primaryRed,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: allRequests[index]
                                                                .requestPaidStatus ==
                                                            "pending"
                                                        ? AppColors.orange
                                                        : allRequests[index]
                                                                    .requestStatus ==
                                                                0
                                                            ? AppColors.orange
                                                                .withOpacity(
                                                                    0.8)
                                                            : allRequests[index]
                                                                        .requestStatus ==
                                                                    1
                                                                ? AppColors
                                                                    .primaryGreen
                                                                    .withOpacity(
                                                                        0.8)
                                                                : Colors
                                                                    .red[400],
                                                  ),
                                                  child: Text(
                                                    allRequests[index]
                                                                .requestPaidStatus ==
                                                            "pending"
                                                        ? "Payment Required"
                                                        : allRequests[index]
                                                                    .requestStatus ==
                                                                0
                                                            ? "Pending"
                                                            : allRequests[index]
                                                                        .requestStatus ==
                                                                    1
                                                                ? "Approved"
                                                                : "Rejected",
                                                    style: const TextStyle(
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 16,
                                  ),
                                  itemCount: allRequests.length,
                                ),
                        ),
                      );
              },
            ),
          if (context.watch<AuthRepository>().customer.token.isEmpty)
            SvgPicture.asset("assets/images/login.svg"),
          if (context.watch<AuthRepository>().customer.token.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "To view your current and past rentals, please login to your account",
                style: AppFonts.inter16Black400,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
