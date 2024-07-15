import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/home/home_cubit.dart';
import 'package:turbo/core/routing/screens_arguments.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../models/notifications_model.dart';
import 'notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    context.read<HomeCubit>().getNotifications(isFromNotificationScreen: true);
    super.initState();
  }

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
                builder: (homeContext, state) {
                  List<UserNotificationModel> notifications =
                      homeContext.watch<HomeCubit>().notifications;
                  return state is GetNotificationsLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              context.read<HomeCubit>().getNotifications(
                                  isFromNotificationScreen: true);
                            },
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 20,
                              ),
                              itemBuilder: (listViewContext, index) => InkWell(
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  context.read<HomeCubit>().readNotification(
                                      notifications[index].id);
                                  Navigator.of(context).pushNamed(
                                    Routes.requestStatusScreen,
                                    arguments: RequestStatusScreenArguments(
                                      requestId: notifications[index]
                                          .notificationRequestId,
                                    ),
                                  );
                                },
                                child: NotificationCard(
                                  title: notifications[index].notificationType,
                                  subTitle:
                                      notifications[index].notificationMessage,
                                  date: notifications[index]
                                      .notificationDate
                                      .toIso8601String(),
                                  isRead:
                                      notifications[index].isNotificationRead,
                                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
