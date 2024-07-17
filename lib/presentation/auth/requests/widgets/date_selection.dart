import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/widget_with_header.dart';

class DateSelection extends StatefulWidget {
  const DateSelection({
    super.key,
    required this.header,
    required this.onDateSelected,
    this.selectedDateTime,
    this.minDate,
    this.padding,
    this.isDeliveryDate = false,
  });

  final String header;
  final DateTime? selectedDateTime;
  final DateTime? minDate;
  final void Function(DateTime?) onDateSelected;
  final bool isDeliveryDate;
  final EdgeInsetsDirectional? padding;

  @override
  State<DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends State<DateSelection> {
  DateTime? tempDateTime;
  DateTime? selectedDateTime;
  @override
  Widget build(BuildContext context) {
    return WidgetWithHeader(
      header: "${widget.header} Date",
      padding: widget.padding ??
          const EdgeInsetsDirectional.only(
            bottom: 12,
            start: 20,
            end: 20,
          ),
      widget: InkWell(
        onTap: () {},
        child: Container(
          width: AppConstants.screenWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.black.withOpacity(0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  tempDateTime = widget.minDate ??
                      (widget.selectedDateTime ??
                          (widget.isDeliveryDate
                              ? DateTime.now()
                                  .add(const Duration(days: 1, minutes: 30))
                              : DateTime.now().add(const Duration(hours: 1))));
                  showModalBottomSheet(
                    context: context,
                    builder: (bsContext) => Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      height: 350,
                      width: AppConstants.screenWidth(context),
                      color: AppColors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.header} Date and Time",
                            style: AppFonts.inter18Black500,
                          ),
                          Expanded(
                            child: CupertinoDatePicker(
                              // use24hFormat: true,
                              minimumDate: widget.minDate ??
                                  (widget.isDeliveryDate
                                      ? DateTime.now().add(
                                          const Duration(days: 1, hours: 1))
                                      : DateTime.now()
                                          .add(const Duration(hours: 1))),
                              initialDateTime: widget.minDate ??
                                  (widget.selectedDateTime ??
                                      (widget.isDeliveryDate
                                          ? DateTime.now().add(const Duration(
                                              days: 1, minutes: 30))
                                          : DateTime.now()
                                              .add(const Duration(hours: 1)))),
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (dateTime) {
                                setState(() {
                                  tempDateTime = dateTime;
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (Navigator.of(bsContext).canPop()) {
                                    Navigator.of(bsContext).pop();
                                  }
                                },
                                child: Text(
                                  "Cancel",
                                  style: AppFonts.inter16Black500.copyWith(
                                    color: AppColors.errorRed,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  TimeOfDay timeOfDay = TimeOfDay.fromDateTime(
                                      widget.selectedDateTime ??
                                          selectedDateTime ??
                                          (widget.isDeliveryDate
                                              ? DateTime.now().add(
                                                  const Duration(
                                                      hours: 1, minutes: 30))
                                              : DateTime.now().add(
                                                  const Duration(hours: 1))));
                                  print("tinee of the dat ${timeOfDay.hour} -- ${timeOfDay.minute}");

                                  setState(() {
                                    selectedDateTime = tempDateTime;
                                    selectedDateTime = selectedDateTime!.copyWith(
                                      hour: timeOfDay.hour,
                                      minute: timeOfDay.minute,
                                    );
                                  });
                                  widget.onDateSelected(selectedDateTime);
                                  if (Navigator.of(bsContext).canPop()) {
                                    Navigator.of(bsContext).pop();
                                  }
                                },
                                child: Text(
                                  "Confirm",
                                  style: AppFonts.inter16Black500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(widget.selectedDateTime != null
                        ? formatDate(widget.selectedDateTime!)
                        : selectedDateTime != null
                            ? formatDate(selectedDateTime!)
                            : "Select Date"),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (selectedDateTime != null) {
                    showModalBottomSheet(
                      context: context,
                      builder: (timeBSContext) => Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        height: 350,
                        width: AppConstants.screenWidth(context),
                        color: AppColors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.header} Time",
                              style: AppFonts.inter18Black500,
                            ),
                            Expanded(
                              child: CupertinoDatePicker(
                                // use24hFormat: true,
                                minimumDate: widget.minDate ??
                                    DateTime.now()
                                        .add(const Duration(hours: 1)),
                                initialDateTime: selectedDateTime ??
                                    DateTime.now()
                                        .add(const Duration(hours: 1)),
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (DateTime value) {
                                  setState(() {
                                    tempDateTime = value;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (Navigator.of(timeBSContext).canPop()) {
                                      Navigator.of(timeBSContext).pop();
                                    }
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: AppFonts.inter16Black500.copyWith(
                                      color: AppColors.errorRed,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDateTime = tempDateTime;
                                    });
                                    widget.onDateSelected(selectedDateTime);
                                    if (Navigator.of(timeBSContext).canPop()) {
                                      Navigator.of(timeBSContext).pop();
                                    }
                                  },
                                  child: Text(
                                    "Confirm",
                                    style: AppFonts.inter16Black500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
                icon: Row(
                  children: [
                    Container(
                      height: 12,
                      width: 2,
                      color: AppColors.grey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(widget.selectedDateTime != null
                        ? formatTime(widget.selectedDateTime!)
                        : "00:00"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd-M-yyyy');
  return formatter.format(dateTime);
}

String formatTime(DateTime dateTime) {
  final DateFormat timeFormatter = DateFormat('HH:mm');
  return timeFormatter.format(dateTime);
}
