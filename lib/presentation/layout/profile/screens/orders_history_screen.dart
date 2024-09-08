import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:turbo/blocs/profile_cubit/profile_cubit.dart';
import 'package:turbo/core/helpers/constants.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../models/request_model.dart';
import '../../orders/request_status/widgets/request_card.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: AppConstants.screenWidth(context),
        height: AppConstants.screenHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DefaultHeader(
              header: "Your History",
              textAlignment: AlignmentDirectional.center,
              alignment: MainAxisAlignment.spaceBetween,
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (previous, current) =>
                  current is GetAllRequestsHistoryLoadingState ||
                  current is GetAllRequestsHistoryErrorState ||
                  current is GetAllRequestsHistorySuccessState,
              builder: (context, state) {
                List<RequestModel> requestsHistory =
                    context.watch<ProfileCubit>().requestsHistory;
                return state is GetAllRequestsHistoryLoadingState
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryBlue,
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<ProfileCubit>()
                                .getCustomerHistoryRequests();
                          },
                          child: requestsHistory.isEmpty
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
                                      style: AppFonts.ibm16LightBlack600,
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
                                    var request = context
                                        .read<ProfileCubit>()
                                        .requestsHistory[index];
                                    return RequestCard(
                                      request: request,
                                      isFromHistory: true,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 16,
                                  ),
                                  itemCount: context
                                      .watch<ProfileCubit>()
                                      .requestsHistory
                                      .length,
                                ),
                        ),
                      );
              },
            ),
          ],
        ),
      )),
    );
  }
}
