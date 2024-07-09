import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/orders/order_cubit.dart';
import '../../../../../core/helpers/constants.dart';
import '../../../../../core/helpers/enums.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/default_buttons.dart';
import '../../../../../core/widgets/text_field_with_header.dart';
import '../../../../../core/widgets/widget_with_header.dart';
import '../../../../../models/attachment.dart';
import '../../../../auth/requests/widgets/date_selection.dart';
import '../../../../auth/requests/widgets/select_file.dart';

class EditRequest extends StatelessWidget {
  const EditRequest({
    super.key,
    required this.blocWatch,
    required this.blocRead,
    required this.nationalIdResult,
    required this.passportResult,
    required this.requestId,
  });

  final OrderCubit blocWatch;
  final OrderCubit blocRead;
  final Attachment? nationalIdResult;
  final Attachment? passportResult;
  final String requestId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditLocation(blocWatch: blocWatch, blocRead: blocRead),
            const EditPrivateDriver(),
            const EditPickupDate(),
            EditDeliveryDate(
              blocWatch: blocWatch,
              blocRead: blocRead,
            ),
            EditedPrice(blocWatch: blocWatch),
            BlocBuilder<OrderCubit, OrderState>(
              buildWhen: (previous, current) =>
              current is SaveEditedDataLoadingState ||
                  current is SaveEditedDataSuccessState ||
                  current is SaveEditedDataErrorState,
              builder: (context, state) {
                return DefaultButton(
                  loading: state is SaveEditedDataLoadingState,
                  marginTop: 16,
                  function: () {
                    blocRead.saveEditedRequestData();
                  },
                  border: Border.all(color: AppColors.primaryRed),
                  color: AppColors.white,
                  textColor: AppColors.primaryRed,
                  text: "Save Edits",
                );
              },
            ),
            const Divider(
              height: 48,
              color: AppColors.divider,
              thickness: 2,
            ),
            WidgetWithHeader(
              padding: EdgeInsetsDirectional.zero,
              header: "Files",
              headerStyle: AppFonts.inter16Black500.copyWith(
                color: AppColors.primaryRed,
                fontSize: 18,
              ),
              widget: RepaintBoundary(
                child: EditedFiles(
                  blocRead: blocRead,
                  blocWatch: blocWatch,
                  nationalIDRejectionComment: nationalIdResult != null
                      ? nationalIdResult?.fileRejectComment ?? ""
                      : "",
                  passportRejectionComment: passportResult != null
                      ? passportResult?.fileRejectComment ?? ""
                      : "",
                ),
              ),
            ),
            BlocBuilder<OrderCubit, OrderState>(
              buildWhen: (previous, current) =>
              current is SubmitEditsLoadingState ||
                  current is SubmitEditsSuccessState ||
                  current is SubmitEditsErrorState,
              builder: (context, state) {
                var blocRead = context.read<OrderCubit>();
                return DefaultButton(
                  loading: state is SubmitEditsLoadingState,
                  marginTop: 16,
                  marginBottom: 20,
                  function: () {
                    blocRead.onSubmitButtonClicked(requestId);
                  },
                  text: "Submit",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditedFiles extends StatefulWidget {
  const EditedFiles({
    super.key,
    required this.blocRead,
    required this.blocWatch,
    required this.nationalIDRejectionComment,
    required this.passportRejectionComment,
  });

  final OrderCubit blocRead;
  final OrderCubit blocWatch;
  final String nationalIDRejectionComment;
  final String passportRejectionComment;

  @override
  State<EditedFiles> createState() => _EditedFilesState();
}

class _EditedFilesState extends State<EditedFiles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 110,
          width: AppConstants.screenWidth(context) - 32,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectFile(
                width: widget.blocWatch.nationalIdAttachments?.fileStatus == 4
                    ? AppConstants.screenWidth(context) - 80
                    : AppConstants.screenWidth(context) - 32,
                key: const Key("EditNationalID"),
                padding: const EdgeInsetsDirectional.only(bottom: 4),
                paths: widget.blocRead.nationalIdAttachments?.filePath ?? "",
                header: "National ID",
                prefixImgPath: "assets/images/icons/national_id.png",
                isFromPending: true,
                onFileSelected: (p0, isSingle) async {
                  widget.blocRead.nationalID =
                  await convertPlatformFileList(p0);
                  if (widget.blocRead.nationalIdAttachments != null &&
                      widget.blocRead.nationalIdAttachments
                          ?.fileRejectComment !=
                          null) {
                    widget.blocRead.nationalIdAttachments?.fileRejectComment =
                    null;
                    widget.blocRead.nationalIdAttachments?.filePath = "";
                    widget.blocRead.nationalIdAttachments?.fileStatus = 4;
                    setState(() {});
                  }
                },
                isWarningToReplace:
                widget.blocWatch.nationalIdAttachments?.fileStatus == 2,
                onPrefixClicked: () {
                  if (widget.blocRead.nationalIdAttachments == null ||
                      (widget.blocRead.nationalIdAttachments != null &&
                          widget.blocRead.nationalIdAttachments
                              ?.fileRejectComment ==
                              null)) {
                    widget.blocRead.nationalID = null;
                    setState(() {});
                  }
                },
              ),
              if (widget.blocRead.nationalIdAttachments?.fileStatus == 4)
                BlocBuilder<OrderCubit, OrderState>(
                  buildWhen: (previous, current) {
                    return (current is SaveEditedFileLoadingState &&
                        current.fileId ==
                            widget.blocRead.nationalIdAttachments?.id) ||
                        (current is SaveEditedFileSuccessState &&
                            current.fileId ==
                                widget.blocRead.nationalIdAttachments?.id) ||
                        (current is SaveEditedFileErrorState &&
                            current.fileId ==
                                widget.blocRead.nationalIdAttachments?.id);
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Center(
                        child: (state is SaveEditedFileLoadingState &&
                            state.fileId ==
                                widget.blocRead.nationalIdAttachments?.id)
                            ? const Padding(
                          padding: EdgeInsetsDirectional.only(start: 8.0),
                          child: CircularProgressIndicator(),
                        )
                            : IconButton(
                          onPressed: () {
                            if (widget.blocRead.nationalID != null &&
                                widget.blocRead.nationalID!.isNotEmpty &&
                                widget.blocRead.nationalIdAttachments
                                    ?.fileStatus !=
                                    2) {
                              context
                                  .read<OrderCubit>()
                                  .updateRequestFile(
                                fileId: widget.blocRead
                                    .nationalIdAttachments?.id ??
                                    "",
                                oldPathFiles: widget
                                    .blocRead.nationalIdOldPaths,
                                fileType: "nationalId",
                                newFile:
                                widget.blocRead.nationalID!.first,
                              );
                            }
                          },
                          icon: const Center(
                            child: Icon(
                              Icons.upload_file_rounded,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        if (widget.blocWatch.nationalIdAttachments?.fileStatus == 2)
          Text(
            widget.nationalIDRejectionComment,
            style: AppFonts.inter14ErrorRed400,
          ),
        SizedBox(
          height:
          widget.blocWatch.nationalIdAttachments?.fileStatus == 2 ? 8 : 12,
        ),
        SelectFile(
          key: const Key("EditPassport"),
          padding: const EdgeInsetsDirectional.only(bottom: 4),
          paths: widget.blocRead.passportAttachments?.filePath ?? "",
          header: "Passport",
          isFromPending: true,
          onFileSelected: (p0, isSingle) async {
            widget.blocRead.passportFiles = await convertPlatformFileList(p0);
            if (widget.blocRead.passportAttachments != null &&
                widget.blocRead.passportAttachments?.fileRejectComment !=
                    null) {
              widget.blocRead.passportAttachments?.fileRejectComment = null;
              widget.blocRead.passportAttachments?.filePath = "";
              widget.blocRead.passportAttachments?.fileStatus = 0;
              setState(() {});
            }
          },
          isWarningToReplace:
          widget.blocWatch.passportAttachments?.fileStatus == 2,
          onPrefixClicked: () {
            if (widget.blocRead.passportAttachments == null ||
                (widget.blocRead.passportAttachments != null &&
                    widget.blocRead.passportAttachments?.fileRejectComment ==
                        null)) {
              widget.blocRead.passportFiles = null;
            }
          },
        ),
        if (widget.blocWatch.passportAttachments?.fileStatus == 2)
          Text(
            widget.passportRejectionComment,
            style: AppFonts.inter14ErrorRed400,
          ),
        SizedBox(
          height:
          widget.blocWatch.passportAttachments?.fileStatus == 2 ? 8 : 12,
        ),
      ],
    );
  }
}

class EditedPrice extends StatelessWidget {
  const EditedPrice({
    super.key,
    required this.blocWatch,
  });

  final OrderCubit blocWatch;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (previous, current) => current is CalculateEdittedPriceState,
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            text: "Rental price: ",
            style: AppFonts.inter16TypeGreyHeader600,
            children: [
              TextSpan(
                text: "${blocWatch.calculatedPrice.toStringAsFixed(2)} ",
                style: AppFonts.inter18Black500,
              ),
              TextSpan(
                text: "SAR",
                style: AppFonts.inter18Black500.copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EditDeliveryDate extends StatelessWidget {
  const EditDeliveryDate({
    super.key,
    required this.blocWatch,
    required this.blocRead,
  });

  final OrderCubit blocWatch;
  final OrderCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (previous, current) => current is ChangeEditedDatesValueState,
      builder: (context, state) {
        return DateSelection(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
          key: const Key("EditDeliveryDate"),
          header: "Delivery",
          minDate: blocWatch.pickedDate != null
              ? context
              .watch<OrderCubit>()
              .pickedDate!
              .add(const Duration(days: 1))
              : DateTime.now().add(const Duration(days: 1)),
          isDeliveryDate: true,
          selectedDateTime: blocWatch.deliveryDate,
          onDateSelected: (selectedDate) {
            blocRead.deliveryDate = selectedDate;
            blocRead.changePickupDateValue();
            blocRead.calculatePrice();
          },
        );
      },
    );
  }
}

class EditPickupDate extends StatelessWidget {
  const EditPickupDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<OrderCubit>();
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (previous, current) => current is ChangeEditedDatesValueState,
      builder: (context, state) {
        return DateSelection(
          padding: EdgeInsetsDirectional.zero,
          key: const Key("EditPickupDate"),
          header: "Pickup",
          selectedDateTime: context.watch<OrderCubit>().pickedDate,
          onDateSelected: (selectedDate) {
            blocRead.pickedDate = selectedDate;
            blocRead.changePickupDateValue(pickUp: selectedDate);
            blocRead.calculatePrice();
          },
        );
      },
    );
  }
}

class EditPrivateDriver extends StatelessWidget {
  const EditPrivateDriver({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<OrderCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text(
            "Private Driver?",
            style: AppFonts.inter16Black500,
          ),
          const Spacer(),
          BlocBuilder<OrderCubit, OrderState>(
            buildWhen: (previous, current) =>
            current is ChangeIsWithPrivateEditValueState,
            builder: (context, state) {
              return Checkbox(
                visualDensity: VisualDensity.standard,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: context.watch<OrderCubit>().isWithPrivateDriver,
                onChanged: (value) {
                  if (value != null) {
                    blocRead.changeIsWithPrivateDriverValue(value);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditLocation extends StatelessWidget {
  const EditLocation({
    super.key,
    required this.blocWatch,
    required this.blocRead,
  });

  final OrderCubit blocWatch;
  final OrderCubit blocRead;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (previous, current) => current is SaveEditedDataSuccessState,
      builder: (context, state) {
        return AuthTextFieldWithHeader(
          horizontalPadding: 0,
          header: "Location",
          hintText: blocRead.requestStatus!.requestLocation,
          isWithValidation: true,
          textInputType: TextInputType.name,
          validationText: "Invalid Location.",
          textEditingController: blocRead.locationController,
          validation: TextFieldValidation.valid,
          onChange: (value) {},
          onSubmit: (value) {},
        );
      },
    );
  }
}