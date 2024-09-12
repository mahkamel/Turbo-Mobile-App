import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/orders/order_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../models/request_model.dart';
import 'request_card.dart';

class AllRequestsView extends StatelessWidget {
  const AllRequestsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
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
                : AppConstants.screenWidth(context) > 760
                ? const RequestsGridForTablet()
                : const RequestList(),
          ),
        );
      },
    );
  }
}


class RequestsGridForTablet extends StatelessWidget {
  const RequestsGridForTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ...List.generate(
              context
                  .watch<OrderCubit>()
                  .allRequests
                  .length,
                  (index) {
                var request = context
                    .watch<OrderCubit>()
                    .allRequests[index];
                return RequestCard(
                  request: request,
                );
              },
            )
          ],
        ),
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
