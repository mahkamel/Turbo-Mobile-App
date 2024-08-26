import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.subTitle,
    required this.date,
    required this.type
  });

  final String subTitle;
  final String date;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        width: AppConstants.screenWidth(context),
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 2,
              color: AppColors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   width: 40,
                //   height: 40,
                //   margin: const EdgeInsets.only(right: 16),
                //   decoration: BoxDecoration(
                //     color: AppColors.primaryBlue.withOpacity(0.08),
                //     shape: BoxShape.circle,
                //   ),
                //   child: const Icon(
                //     Icons.notifications_none_rounded,
                //     color: AppColors.primaryBlue,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: getIconFromNotificationType(type),
                ),
                SizedBox(
                  width: AppConstants.screenWidth(context) - 124,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getTitleFromNotificationType(type),
                        style: AppFonts.ibm12SubTextGrey600.copyWith(
                          color: getColorFromNotificationType(type),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          formatNotificationDate(date),
                          style: AppFonts.ibm10White600.copyWith(
                            color: AppColors.grey400,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        subTitle,
                        style: AppFonts.ibm11Grey400.copyWith(
                          color: AppColors.lightBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

Color getColorFromNotificationType(String notificationType) {
  switch (notificationType) {
    case "reject":
      return AppColors.red;
    case "approve":
      return AppColors.green;
    case "refund":
      return AppColors.darkOrange;
    default:
      return AppColors.primaryBlue;
  }
}

String getTitleFromNotificationType(String notificationType) {
  switch (notificationType) {
    case "reject":
      return "Car request disapproved";
    case "approve":
      return "Car request approved";
    case "refund":
      return "Refund car request";
    default:
      return "Upload files";
  }
}

SvgPicture getIconFromNotificationType(String notificationType) {
  switch (notificationType) {
    case "reject":
      return SvgPicture.asset("assets/images/icons/reject.svg");
    case "approve":
      return SvgPicture.asset("assets/images/icons/approve.svg");
    case "refund":
      return SvgPicture.asset("assets/images/icons/refund.svg");
    default:
    //todo
      return SvgPicture.asset("assets/images/icons/upload.svg");
  }
}