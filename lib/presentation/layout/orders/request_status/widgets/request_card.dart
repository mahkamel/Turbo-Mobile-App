import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:turbo/core/widgets/default_buttons.dart';

import '../../../../../blocs/orders/order_cubit.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/routing/screens_arguments.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../main_paths.dart';
import '../../../../../models/request_model.dart';
import '../../../home/widgets/car_image.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    this.isFromHistory = false,
  });

  final RequestModel request;
  final bool isFromHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.screenWidth(context) - 32,
      margin: const EdgeInsets.only(bottom: 4),
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.15),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.black.withOpacity(0.3),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CarImage(
            carImgPath: request.requestCarId.last.carId.carMedia.first.mediaId
                .mediaMediumImageUrl,
          ),
          const SizedBox(
            height: 8,
          ),
          OrderNumberAndStatus(
            requestPaidStatus: request.requestPaidStatus,
            requestStatus: request.requestStatus,
            requestCode: request.requestCode,
            isFromHistory: isFromHistory,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              bottom: 5,
              top: 2,
            ),
            child: Text.rich(
              TextSpan(
                text: "SAR",
                style: AppFonts.ibm12Grey400,
                children: [
                  TextSpan(
                    text: " ${request.requestPrice.toStringAsFixed(2)}",
                    style: AppFonts.ibm15LightBlack600,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: AppConstants.screenWidth(context) - 64,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: request.requestCarId.last.carId.carModel,
                              style: AppFonts.ibm16LightBlack400,
                              children: [
                                TextSpan(
                                    text:
                                        " ${request.requestCarId.last.carId.carYear}",
                                    style: AppFonts.ibm11Grey400),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              "assets/images/icons/location_icon.svg"),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4.0,
                              // top: 4.0,
                            ),
                            child: SizedBox(
                              width: AppConstants.screenWidth(context) - 264,
                              child: Text(
                                request.requestLocation,
                                style: AppFonts.ibm12Primary400,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (request.requestDriver)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                                "assets/images/icons/private_driver_icon.svg"),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                top: 4.0,
                              ),
                              child: Text(
                                "Private Driver",
                                style: AppFonts.ibm12Primary400,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RequestDate(
                        isFrom: true,
                        isWithPrivateDriver: request.requestDriver,
                        dateTime: request.requestFrom,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RequestDate(
                        isFrom: false,
                        isWithPrivateDriver: request.requestDriver,
                        dateTime: request.requestTo,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isFromHistory)
            const SizedBox(
              height: 12,
            ),
          if (!isFromHistory)
            DefaultButton(
              marginBottom: 12,
              marginTop: 16,
              marginLeft: 16,
              marginRight: 16,
              function: () {
                if (request.requestPaidStatus == "paid") {
                  Navigator.of(context).pushNamed(
                    Routes.requestStatusScreen,
                    arguments: RequestStatusScreenArguments(
                      requestId: request.id,
                      requestCode: request.requestCode,
                      orderCubit: context.read<OrderCubit>(),
                    ),
                  );
                } else {
                  Navigator.of(context).pushNamed(
                    Routes.paymentScreen,
                    arguments: PaymentScreenArguments(
                      paymentAmount: request.requestPrice,
                      carRequestId: request.id,
                      carRequestCode: request.requestCode,
                    ),
                  );
                }
              },
              text: "View details",
              height: 36,
              textStyle: AppFonts.ibm15OffWhite400,
            ),
        ],
      ),
    );
  }
}

class RequestDate extends StatelessWidget {
  const RequestDate({
    super.key,
    this.isFrom = true,
    this.isWithPrivateDriver = false,
    required this.dateTime,
  });

  final bool isFrom;
  final bool isWithPrivateDriver;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isWithPrivateDriver ? 4.0 : 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.date_range,
            color: AppColors.secondary,
            size: 18,
          ),
          const SizedBox(
            width: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: isFrom ? "From:" : "To:",
                  style: AppFonts.ibm12Secondary400,
                  children: [
                    TextSpan(
                        text: " ${formatDate(dateTime)}",
                        style: AppFonts.ibm12Primary400),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                DateFormat('HH:mm a').format(dateTime),
                style: AppFonts.ibm11Grey400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderNumberAndStatus extends StatelessWidget {
  const OrderNumberAndStatus({
    super.key,
    required this.requestCode,
    required this.requestPaidStatus,
    required this.requestStatus,
    this.isFromHistory = false,
  });

  final String requestCode;
  final String requestPaidStatus;
  final int requestStatus;
  final bool isFromHistory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            "Your Order #$requestCode",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.ibm14Primary600,
          ),
          const Spacer(),
          StatusBadge(
            requestPaidStatus: requestPaidStatus,
            requestStatus: requestStatus,
            isFromHistory: isFromHistory,
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(
      {super.key,
      required this.requestPaidStatus,
      required this.requestStatus,
      this.isFromHistory = false});

  final String requestPaidStatus;
  final int requestStatus;
  final bool isFromHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: requestPaidStatus == "pending"
            ? AppColors.darkOrange.withOpacity(0.3)
            : requestStatus == 0 || requestStatus == 4
                ? AppColors.pendingYellow.withOpacity(0.3)
                : requestStatus == 1
                    ? AppColors.green.withOpacity(0.3)
                    : requestStatus == 3
                        ? AppColors.darkOrange
                        : requestStatus == 5
                            ? AppColors.grey400
                            : AppColors.red.withOpacity(0.3),
      ),
      child: Text(
        requestPaidStatus == "pending"
            ? "Payment Required"
            : requestStatus == 0
                ? "Pending"
                : requestStatus == 1
                    ? isFromHistory
                        ? "Completed"
                        : "Approved"
                    : requestStatus == 3
                        ? "Refund"
                        : requestStatus == 4
                            ? "Files Required"
                            : requestStatus == 5
                                ? "Cancelled"
                                : "Rejected",
        style: TextStyle(
          color: requestPaidStatus == "pending"
              ? AppColors.darkOrange
              : requestStatus == 0 || requestStatus == 4
                  ? AppColors.pendingYellowText
                  : requestStatus == 1
                      ? AppColors.green
                      : requestStatus == 3
                          ? AppColors.white
                          : requestStatus == 5
                              ? AppColors.white
                              : AppColors.red,
          fontWeight: FontWeight.w400,
          fontSize: 10,
        ),
      ),
    );
  }
}

class EmptyRequests extends StatelessWidget {
  const EmptyRequests({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
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
          "You don't have any rentals yet,\nExplore our wide selection of cars to find the perfect one for your next trip.",
          style: AppFonts.ibm16LightBlack600,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
