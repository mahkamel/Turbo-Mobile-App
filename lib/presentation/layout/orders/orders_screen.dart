import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/models/request_model.dart';
import 'package:turbo/presentation/layout/orders/request_status/widgets/request_card.dart';

import '../../../blocs/orders/order_cubit.dart';
import '../../../core/helpers/constants.dart';
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
          const Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              bottom: 8.0,
            ),
            child: DefaultHeader(
              header: "Your orders",
              textAlignment: AlignmentDirectional.centerStart,
              isShowPrefixIcon: false,
            ),
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
                          color: AppColors.primaryBlue,
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<OrderCubit>().getAllCustomerRequests();
                          },
                          child: allRequests.isEmpty
                              ? const EmptyRequests()
                              : const RequestList(),
                        ),
                      );
              },
            ),
          if (context.watch<AuthRepository>().customer.token.isEmpty )
            Expanded(
              child: ListView(
            physics: AppConstants.screenHeight(context) < 600 ? const BouncingScrollPhysics():const NeverScrollableScrollPhysics(),
                children: [
                  SvgPicture.asset("assets/images/login.svg"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "To view your current rentals, please login to your account",
                      style: AppFonts.ibm16LightBlack600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),


        ],
      ),
    );
  }
}

class RequestList extends StatelessWidget {
  const RequestList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 20,
        right: 16,
        left: 16,
      ),
      itemBuilder: (context, index) {
        var request = context.read<OrderCubit>().allRequests[index];
        return RequestCard(
          request: request,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 16,
      ),
      itemCount: context.watch<OrderCubit>().allRequests.length,
    );
  }
}
