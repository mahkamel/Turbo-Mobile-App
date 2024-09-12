import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/widgets/custom_header.dart';
import 'package:turbo/presentation/layout/orders/widgets/login_required_for_orders.dart';
import 'package:turbo/presentation/layout/orders/widgets/requests_list.dart';

import '../../../blocs/orders/order_cubit.dart';
import '../../../core/helpers/constants.dart';
import '../../../core/services/local/token_service.dart';
import '../../../core/services/networking/repositories/auth_repository.dart';

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
            const AllRequestsView(),
          if (context.watch<AuthRepository>().customer.token.isEmpty)
            const LoginRequiredForOrders(),
        ],
      ),
    );
  }
}



