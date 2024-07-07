import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../models/notifications_model.dart';
import 'notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: AppConstants.screenWidth(context),
        height: AppConstants.screenHeight(context),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DefaultHeader(
                header: "Notifications",
                textAlignment: AlignmentDirectional.center,
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (previous, current) =>
                    current is GetNotificationsLoadingState ||
                    current is GetNotificationsErrorState ||
                    current is GetNotificationsSuccessState,
                builder: (context, state) {
                  List<UserNotificationModel> notifications =
                      context.watch<HomeCubit>().notifications;
                  return state is GetNotificationsLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              context.read<HomeCubit>().getNotifications();
                            },
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 20,
                              ),
                              itemBuilder: (context, index) => NotificationCard(
                                title: notifications[index].notificationType,
                                subTitle:
                                    notifications[index].notificationMessage,
                                date: notifications[index]
                                    .notificationDate
                                    .toIso8601String(),
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 16,
                              ),
                              itemCount: notifications.length,
                            ),
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
