import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/enums.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/widget_with_header.dart';

class DateSelection extends StatefulWidget {
  const DateSelection({
    super.key,
    required this.header,
    required this.onDateSelected,
    this.selectedDateTime,
    this.validationState = TextFieldValidation.normal,
    this.minDate,
    this.padding,
    this.onPressed,
    this.initialDate,
    this.isDeliveryDate = false,
    this.isRequired = false,
    this.isWithTime = true,
    this.isEnabled = true,
  });

  final String header;
  final DateTime? selectedDateTime;
  final DateTime? minDate;
  final DateTime? initialDate;
  final void Function(DateTime?) onDateSelected;
  final void Function()? onPressed;
  final bool isDeliveryDate;
  final bool isRequired;
  final bool isWithTime;
  final bool isEnabled;
  final TextFieldValidation validationState;
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
      isRequiredField: widget.isRequired,
      padding: widget.padding ??
          const EdgeInsetsDirectional.only(
            bottom: 12,
            start: 20,
            end: 20,
          ),
      widget: InkWell(
        onTap: () {
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: Container(
          width: AppConstants.screenWidth(context),
          padding: widget.isEnabled
              ? null
              : const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
          decoration: BoxDecoration(
            color: widget.isEnabled ? null : AppColors.greyBorder,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.validationState == TextFieldValidation.notValid
                  ? AppColors.errorRed
                  : AppColors.black.withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              widget.isEnabled
                  ? IconButton(
                      onPressed: () {
                        if (widget.onPressed != null) {
                          widget.onPressed!();
                        }
                        tempDateTime = widget.minDate ??
                            (widget.selectedDateTime ??
                                (widget.isDeliveryDate
                                    ? DateTime.now().add(
                                        const Duration(days: 1, minutes: 30))
                                    : DateTime.now()
                                        .add(const Duration(hours: 1))));
                        buildDatePickerBottomSheet(context);
                      },
                      icon: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 24,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.selectedDateTime != null
                                ? formatDate(widget.selectedDateTime!)
                                : selectedDateTime != null
                                    ? formatDate(selectedDateTime!)
                                    : "Select Date",
                            style: widget.selectedDateTime != null ||
                                    selectedDateTime != null
                                ? AppFonts.ibm15LightBlack400
                                : AppFonts.ibm15subTextGrey400,
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 24,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.selectedDateTime != null
                              ? formatDate(widget.selectedDateTime!)
                              : selectedDateTime != null
                                  ? formatDate(selectedDateTime!)
                                  : "Select Date",
                          style: widget.selectedDateTime != null ||
                                  selectedDateTime != null
                              ? AppFonts.ibm15LightBlack400
                              : AppFonts.ibm15subTextGrey400,
                        ),
                      ],
                    ),
              if (widget.isWithTime)
                widget.isEnabled
                    ? IconButton(
                        onPressed: () {
                          if (selectedDateTime != null) {
                            buildTimePicketBottomSheet(context);
                          }
                        },
                        icon: Row(
                          children: [
                            if (widget.selectedDateTime != null)
                              Container(
                                height: 16,
                                width: 2,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                color: AppColors.lightBlack,
                              ),
                            if (widget.selectedDateTime != null)
                              const SizedBox(
                                width: 8,
                              ),
                            Text(
                              widget.selectedDateTime != null
                                  ? formatTime(widget.selectedDateTime!)
                                  : "",
                              style: AppFonts.ibm15LightBlack400.copyWith(
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          if (widget.selectedDateTime != null)
                            Container(
                              height: 16,
                              width: 2,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              color: AppColors.lightBlack,
                            ),
                          if (widget.selectedDateTime != null)
                            const SizedBox(
                              width: 8,
                            ),
                          Text(
                            widget.selectedDateTime != null
                                ? formatTime(widget.selectedDateTime!)
                                : "00:00",
                            style: AppFonts.ibm15LightBlack400.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildTimePicketBottomSheet(BuildContext context) {
    return showModalBottomSheet(
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
                    DateTime.now().add(const Duration(hours: 1)),
                initialDateTime: selectedDateTime ??
                    DateTime.now().add(const Duration(hours: 1)),
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

  Future<dynamic> buildDatePickerBottomSheet(BuildContext context) {
    return showModalBottomSheet(
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
              "${widget.header} Date",
              style: AppFonts.inter18Black500,
            ),
            Expanded(
              child: CupertinoDatePicker(
                // use24hFormat: true,
                minimumDate: widget.minDate ??
                    (widget.isDeliveryDate
                        ? DateTime.now().add(const Duration(days: 1, hours: 1))
                        : DateTime.now().add(const Duration(hours: 1))),
                initialDateTime: widget.initialDate ??
                    widget.minDate ??
                    (widget.selectedDateTime ??
                        (widget.isDeliveryDate
                            ? DateTime.now()
                                .add(const Duration(days: 1, minutes: 30))
                            : DateTime.now().add(const Duration(hours: 1)))),
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
                    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(widget
                            .selectedDateTime ??
                        selectedDateTime ??
                        (widget.isDeliveryDate
                            ? DateTime.now()
                                .add(const Duration(hours: 1, minutes: 30))
                            : DateTime.now().add(const Duration(hours: 1))));

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
  }
}

String formatDate(DateTime dateTime) {
  final DateFormat formatter = DateFormat('dd-M-yyyy');
  return formatter.format(dateTime);
}

String formatTime(DateTime dateTime) {
  final DateFormat timeFormatter = DateFormat('HH:mm a');
  return timeFormatter.format(dateTime);
}
