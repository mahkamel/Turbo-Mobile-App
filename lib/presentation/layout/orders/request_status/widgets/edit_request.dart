import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/widgets/snackbar.dart';

import '../../../../../blocs/orders/order_cubit.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/constants.dart';
import '../../../../../core/helpers/enums.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/widgets/default_buttons.dart';
import '../../../../../core/widgets/error_msg_container.dart';
import '../../../../../core/widgets/text_field_with_header.dart';
import '../../../../../core/widgets/widget_with_header.dart';
import '../../../../../models/attachment.dart';
import '../../../../auth/requests/widgets/date_selection.dart';
import '../../../../auth/requests/widgets/select_file.dart';

class EditRequest extends StatefulWidget {
  const EditRequest({
    super.key,
  });

  @override
  State<EditRequest> createState() => _EditRequestState();
}

class _EditRequestState extends State<EditRequest> {
  Attachment? nationalIdResult;
  Attachment? passportResult;
  @override
  void initState() {
    var blocRead = context.read<OrderCubit>();

    nationalIdResult = findAttachmentFile(
      type: "nationalId",
      attachments: blocRead.requestStatus!.attachmentsId,
    );
    passportResult = findAttachmentFile(
      type: "passport",
      attachments: blocRead.requestStatus!.attachmentsId,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ErrMsg(),
            const IsolatedEditLocation(),
            const SizedBox(
              height: 16,
            ),
            const EditPickupDate(),
            const EditDeliveryDate(),
            const EditPrivateDriver(),
            const EditedPrice(),
            const SaveEditsButton(),
            const EditDivider(),
            RepaintBoundary(
              child: FilesSection(
                nationalIdResult: nationalIdResult,
                passportResult: passportResult,
              ),
            ),
            const SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class FilesSection extends StatelessWidget {
  const FilesSection({
    super.key,
    this.nationalIdResult,
    this.passportResult,
  });

  final Attachment? nationalIdResult;
  final Attachment? passportResult;

  @override
  Widget build(BuildContext context) {
    return (getIt<AuthRepository>().customer.customerType != 0 ||
            (getIt<AuthRepository>().customer.customerType == 0 &&
                context
                    .read<OrderCubit>()
                    .requestStatus!
                    .attachmentsId
                    .isNotEmpty) ||
            context.read<OrderCubit>().requestStatus!.requestStatus == 4)
        ? WidgetWithHeader(
            key: const Key("FilesWidget"),
            padding: EdgeInsetsDirectional.zero,
            header: "Files",
            isRequiredField:
                context.read<OrderCubit>().requestStatus?.requestStatus == 4
                    ? true
                    : false,
            headerStyle: AppFonts.inter16Black500.copyWith(
              color: AppColors.primaryBlue,
              fontSize: 18,
            ),
            widget: RepaintBoundary(
              key: const Key("EditedFilesKey"),
              child: EditedFiles(
                blocRead: context.read<OrderCubit>(),
                blocWatch: context.read<OrderCubit>(),
                nationalIDRejectionComment: nationalIdResult != null
                    ? nationalIdResult?.fileRejectComment ?? ""
                    : "",
                passportRejectionComment: passportResult != null
                    ? passportResult?.fileRejectComment ?? ""
                    : "",
              ),
            ),
          )
        : const SizedBox(
            height: 24,
          );
  }
}

class EditDivider extends StatelessWidget {
  const EditDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (getIt<AuthRepository>().customer.customerType != 0 ||
            context.read<OrderCubit>().requestStatus!.requestStatus == 4)
        ? const Divider(
            height: 48,
            color: AppColors.divider,
            thickness: 2,
          )
        : const SizedBox();
  }
}

class ErrMsg extends StatelessWidget {
  const ErrMsg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context
            .read<OrderCubit>()
            .requestStatus!
            .requestRejectComment
            .isNotEmpty
        ? ErrorMsgContainer(
            margin: const EdgeInsetsDirectional.only(
              top: 12,
              bottom: 16,
            ),
            errMsg:
                context.read<OrderCubit>().requestStatus!.requestRejectComment,
          )
        : const SizedBox();
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<OrderCubit>();
    return BlocConsumer<OrderCubit, OrderState>(
      listenWhen: (previous, current) =>
          current is SubmitEditsLoadingState ||
          current is SubmitEditsSuccessState ||
          current is SubmitEditsErrorState,
      listener: (context, state) {
        if (state is SubmitEditsErrorState) {
          defaultErrorSnackBar(context: context, message: state.errMsg);
        } else if (state is SubmitEditsSuccessState) {
          blocRead.getRequestStatus(blocRead.requestStatus?.id ?? "");
          blocRead.getAllCustomerRequests();
        }
      },
      buildWhen: (previous, current) =>
          current is SubmitEditsLoadingState ||
          current is SubmitEditsSuccessState ||
          current is SubmitEditsErrorState ||
          current is SaveEditedFileLoadingState ||
          current is SaveEditedFileSuccessState ||
          current is SaveEditedFileErrorState ||
          current is SelectNationalIdFileState ||
          current is SelectPassportFileState,
      builder: (blocContext, state) {
        var blocRead = blocContext.read<OrderCubit>();
        var blocWatch = blocContext.watch<OrderCubit>();
        print("sssss ${getIt<AuthRepository>().customer.customerType}");
        print("sssss ${blocWatch.passportAttachments?.fileStatus}");
        return DefaultButton(
          loading: state is SubmitEditsLoadingState,
          marginTop: 16,
          marginBottom: 20,
          color: (blocWatch.nationalIdInitStatus != 2) &&
                  (blocWatch.passportInitStatus != 2) &&
                  (blocWatch.nationalIdInitStatus != 4) &&
                  (blocWatch.passportInitStatus != 4) &&
                  (((((blocWatch.nationalIdAttachments != null &&
                                  blocWatch.nationalIdAttachments?.fileStatus !=
                                      2 &&
                                  blocWatch.nationalIdAttachments?.fileStatus !=
                                      4) ||
                              (blocWatch.nationalID != null &&
                                  getIt<AuthRepository>()
                                          .customer
                                          .customerType ==
                                      0)) &&
                          ((blocWatch.passportAttachments != null &&
                                  blocWatch.passportAttachments?.fileStatus !=
                                      2 &&
                                  blocWatch.passportAttachments?.fileStatus !=
                                      4) ||
                              (blocWatch.passportFiles != null &&
                                  getIt<AuthRepository>()
                                          .customer
                                          .customerType ==
                                      0)))) ||
                      getIt<AuthRepository>().customer.customerType == 0)
              ? AppColors.primaryBlue
              : AppColors.greyBorder,
          function: () {
            if (state is! SubmitEditsLoadingState &&
                state is! SaveEditedFileLoadingState &&
                (blocWatch.nationalIdInitStatus != 2) &&
                (blocWatch.passportInitStatus != 2) &&
                (blocWatch.nationalIdInitStatus != 4) &&
                (blocWatch.passportInitStatus != 4) &&
                (((((blocWatch.nationalIdAttachments != null &&
                                blocWatch.nationalIdAttachments?.fileStatus !=
                                    2 &&
                                blocWatch.nationalIdAttachments?.fileStatus !=
                                    4) ||
                            (blocWatch.nationalID != null && getIt<AuthRepository>().customer.customerType == 0)) &&
                        ((blocWatch.passportAttachments != null &&
                                blocWatch.passportAttachments?.fileStatus !=
                                    2 &&
                                blocWatch.passportAttachments?.fileStatus !=
                                    4) ||
                            (blocWatch.passportFiles != null && getIt<AuthRepository>().customer.customerType == 0)))) ||
                    getIt<AuthRepository>().customer.customerType == 0)) {
              blocRead.onSubmitButtonClicked(blocRead.requestStatus?.id ?? "");
            }
          },
          text: "Submit",
        );
      },
    );
  }
}

class SaveEditsButton extends StatelessWidget {
  const SaveEditsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<OrderCubit>();
    return BlocBuilder<OrderCubit, OrderState>(
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
          border: Border.all(color: AppColors.primaryBlue),
          color: AppColors.white,
          textColor: AppColors.primaryBlue,
          text: "Save Edits",
        );
      },
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
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (previous, current) =>
          current is SaveEditedFileLoadingState ||
          current is SaveEditedFileSuccessState ||
          current is SaveEditedFileErrorState ||
          current is SelectNationalIdFileState ||
          current is SelectPassportFileState,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepaintBoundary(
              key: const Key("EditNationalIdRepaint"),
              child: SizedBox(
                height: 110,
                width: AppConstants.screenWidth(context) - 32,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectFile(
                      width:
                          widget.blocWatch.nationalIdAttachments?.fileStatus ==
                                  4
                              ? AppConstants.screenWidth(context) - 80
                              : AppConstants.screenWidth(context) - 32,
                      key: const Key("EditNationalID"),
                      padding: const EdgeInsetsDirectional.only(bottom: 4),
                      paths:
                          widget.blocRead.nationalIdAttachments?.filePath ?? "",
                      header: "National ID",
                      prefixImgPath: "assets/images/icons/national_id.png",
                      isFromPending: true,
                      onFileSelected: (p0, isSingle) async {
                        widget.blocRead.nationalID =
                            await convertPlatformFile(p0.first);
                        if (widget.blocRead.nationalIdAttachments != null &&
                            widget.blocRead.nationalIdAttachments
                                    ?.fileRejectComment !=
                                null) {
                          widget.blocRead.nationalIdAttachments
                              ?.fileRejectComment = null;
                          widget.blocRead.nationalIdAttachments?.filePath = "";
                          widget.blocRead.nationalIdAttachments?.fileStatus = 4;
                        }
                        widget.blocRead.nationalIdInitStatus = 0;
                        setState(() {});
                        widget.blocRead.pickNationalIdFile();
                      },
                      isWarningToReplace:
                          widget.blocWatch.nationalIdAttachments?.fileStatus ==
                                  2 ||
                              widget.blocRead.nationalIdInitStatus == 4,
                      onPrefixClicked: () {
                        if (widget.blocRead.nationalIdAttachments == null ||
                            (widget.blocRead.nationalIdAttachments != null &&
                                widget.blocRead.nationalIdAttachments
                                        ?.fileRejectComment ==
                                    null)) {
                          widget.blocRead.nationalID = null;

                          setState(() {});
                          widget.blocRead.pickNationalIdFile();
                        }
                      },
                    ),
                    if (widget.blocRead.nationalIdAttachments?.fileStatus == 4)
                      BlocBuilder<OrderCubit, OrderState>(
                        buildWhen: (previous, current) {
                          return (current is SaveEditedFileLoadingState &&
                                  current.fileId ==
                                      widget.blocRead.nationalIdAttachments
                                          ?.id) ||
                              (current is SaveEditedFileSuccessState &&
                                  current.fileId ==
                                      widget.blocRead.nationalIdAttachments
                                          ?.id) ||
                              (current is SaveEditedFileErrorState &&
                                  current.fileId ==
                                      widget
                                          .blocRead.nationalIdAttachments?.id);
                        },
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: Center(
                              child: (state is SaveEditedFileLoadingState &&
                                      state.fileId ==
                                          widget.blocRead.nationalIdAttachments
                                              ?.id)
                                  ? const Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: 8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        if (widget.blocRead.nationalID !=
                                                null &&
                                            widget
                                                    .blocRead
                                                    .nationalIdAttachments
                                                    ?.fileStatus !=
                                                2) {
                                          context
                                              .read<OrderCubit>()
                                              .updateRequestFile(
                                                fileId: widget
                                                        .blocRead
                                                        .nationalIdAttachments
                                                        ?.id ??
                                                    "",
                                                oldPathFiles: widget.blocRead
                                                    .nationalIdOldPaths,
                                                fileType: "nationalId",
                                                newFile:
                                                    widget.blocRead.nationalID!,
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
            ),
            if (widget.blocWatch.nationalIdAttachments?.fileStatus == 2)
              Text(
                widget.nationalIDRejectionComment,
                style: AppFonts.inter14ErrorRed400,
              ),
            SizedBox(
              height: widget.blocWatch.nationalIdAttachments?.fileStatus == 2
                  ? 8
                  : 12,
            ),
            RepaintBoundary(
              key: const Key("EditPassportRepaint"),
              child: SizedBox(
                height: 110,
                width: AppConstants.screenWidth(context) - 32,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectFile(
                      width:
                          widget.blocWatch.passportAttachments?.fileStatus == 4
                              ? AppConstants.screenWidth(context) - 80
                              : AppConstants.screenWidth(context) - 32,
                      key: const Key("EditPassport"),
                      padding: const EdgeInsetsDirectional.only(bottom: 4),
                      paths:
                          widget.blocRead.passportAttachments?.filePath ?? "",
                      header: "Passport",
                      prefixIcon: widget.blocRead.passportInitStatus == 4
                          ? Text(
                              "Clear",
                              style: AppFonts.inter14TextBlack500,
                            )
                          : null,
                      isFromPending: true,
                      onFileSelected: (p0, isSingle) async {
                        widget.blocRead.passportFiles =
                            await convertPlatformFile(p0.first);
                        if (widget.blocRead.passportAttachments != null &&
                            widget.blocRead.passportAttachments
                                    ?.fileRejectComment !=
                                null) {
                          widget.blocRead.passportAttachments
                              ?.fileRejectComment = null;
                          widget.blocRead.passportAttachments?.filePath = "";
                          widget.blocRead.passportAttachments?.fileStatus = 4;
                        }
                        widget.blocRead.passportInitStatus = 0;
                        setState(() {});
                        widget.blocRead.pickPassportFile();
                      },
                      isWarningToReplace:
                          widget.blocWatch.passportAttachments?.fileStatus ==
                                  2 ||
                              widget.blocRead.passportInitStatus == 4,
                      onPrefixClicked: () {
                        if (widget.blocRead.passportAttachments == null ||
                            (widget.blocRead.passportAttachments != null &&
                                widget.blocRead.passportAttachments
                                        ?.fileRejectComment ==
                                    null)) {
                          widget.blocRead.passportFiles = null;
                          setState(() {});
                          widget.blocRead.pickPassportFile();
                        }
                      },
                    ),
                    if (widget.blocRead.passportAttachments?.fileStatus == 4)
                      BlocBuilder<OrderCubit, OrderState>(
                        buildWhen: (previous, current) {
                          return (current is SaveEditedFileLoadingState &&
                                  current.fileId ==
                                      widget
                                          .blocRead.passportAttachments?.id) ||
                              (current is SaveEditedFileSuccessState &&
                                  current.fileId ==
                                      widget
                                          .blocRead.passportAttachments?.id) ||
                              (current is SaveEditedFileErrorState &&
                                  current.fileId ==
                                      widget.blocRead.passportAttachments?.id);
                        },
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: Center(
                              child: (state is SaveEditedFileLoadingState &&
                                      state.fileId ==
                                          widget
                                              .blocRead.passportAttachments?.id)
                                  ? const Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: 8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        if (widget.blocRead.passportFiles !=
                                                null &&
                                            widget.blocRead.passportAttachments
                                                    ?.fileStatus !=
                                                2) {
                                          context
                                              .read<OrderCubit>()
                                              .updateRequestFile(
                                                fileId: widget
                                                        .blocRead
                                                        .passportAttachments
                                                        ?.id ??
                                                    "",
                                                oldPathFiles: widget
                                                    .blocRead.passportOldPaths,
                                                fileType: "passport",
                                                newFile: widget
                                                    .blocRead.passportFiles!,
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
            ),
            if (widget.blocWatch.passportAttachments?.fileStatus == 2)
              Text(
                widget.passportRejectionComment,
                style: AppFonts.inter14ErrorRed400,
              ),
            SizedBox(
              height: widget.blocWatch.passportAttachments?.fileStatus == 2
                  ? 8
                  : 12,
            ),
          ],
        );
      },
    );
  }
}

class EditedPrice extends StatelessWidget {
  const EditedPrice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (previous, current) => current is CalculateEdittedPriceState,
      builder: (context, state) {
        var blocWatch = context.watch<OrderCubit>();
        return Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 8.0,
            end: 8.0,
            top: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Rental price: ",
                    style: AppFonts.inter16TypeGreyHeader600,
                  ),
                  const Spacer(),
                  Text(
                    "${(blocWatch.calculatedPrice - blocWatch.calculatedDriverFees).toStringAsFixed(2)} ",
                    style: AppFonts.inter18Black500,
                  ),
                  Text(
                    "SAR",
                    style: AppFonts.inter16Black500.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              if (blocWatch.isWithPrivateDriver)
                Row(
                  children: [
                    Text(
                      "Driver Fees: ",
                      style: AppFonts.inter16TypeGreyHeader600,
                    ),
                    const Spacer(),
                    Text(
                      "${blocWatch.calculatedDriverFees.toStringAsFixed(2)} ",
                      style: AppFonts.inter18Black500,
                    ),
                    Text(
                      "SAR",
                      style: AppFonts.inter16Black500.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              Row(
                children: [
                  Text(
                    "Vat (${AppConstants.vat}%): ",
                    style: AppFonts.inter16TypeGreyHeader600,
                  ),
                  const Spacer(),
                  Text(
                    "${(blocWatch.calculatedPrice * (AppConstants.vat / 100)).toStringAsFixed(2)} ",
                    style: AppFonts.inter18Black500,
                  ),
                  Text(
                    "SAR",
                    style: AppFonts.inter16Black500.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 16,
                color: AppColors.greyBorder,
              ),
              Row(
                children: [
                  Text(
                    "Total: ",
                    style: AppFonts.inter16TypeGreyHeader600.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${((blocWatch.calculatedPrice * (AppConstants.vat / 100)) + blocWatch.calculatedPrice).toStringAsFixed(2)} ",
                    style: AppFonts.inter18Black500.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "SAR",
                    style: AppFonts.inter16Black500.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
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
  });

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<OrderCubit>();
    return DateSelection(
      isEnabled: false,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
      key: const Key("EditDeliveryDate"),
      header: "Delivery",
      minDate: blocRead.pickedDate != null
          ? context
              .watch<OrderCubit>()
              .pickedDate!
              .add(const Duration(days: 1, minutes: 30))
          : DateTime.now().add(const Duration(days: 1, minutes: 30)),
      isDeliveryDate: true,
      selectedDateTime: blocRead.deliveryDate,
      initialDate: blocRead.deliveryDate,
      onDateSelected: (selectedDate) {
        blocRead.deliveryDate = selectedDate;
        blocRead.changePickupDateValue();
        blocRead.calculatePrice();
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
          isEnabled: false,
          padding: EdgeInsetsDirectional.zero,
          key: const Key("EditPickupDate"),
          header: "Pickup",
          minDate: DateTime.now().add(const Duration(hours: 1)),
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
    return AppConstants.driverFees == -1 || AppConstants.driverFees == 0
        ? const SizedBox(
            height: 16,
          )
        : Row(
            children: [
              Text(
                "Private Driver?",
                style: AppFonts.inter16Black500
                    .copyWith(color: AppColors.primaryBlue),
              ),
              const Spacer(),
              BlocBuilder<OrderCubit, OrderState>(
                buildWhen: (previous, current) =>
                    current is ChangeIsWithPrivateEditValueState,
                builder: (context, state) {
                  return Switch.adaptive(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: context.watch<OrderCubit>().isWithPrivateDriver,
                    onChanged: (value) {
                      blocRead.changeIsWithPrivateDriverValue(value);
                    },
                  );
                },
              ),
            ],
          );
  }
}

class IsolatedEditLocation extends StatefulWidget {
  const IsolatedEditLocation({super.key});

  @override
  State<IsolatedEditLocation> createState() => _IsolatedEditLocationState();
}

class _IsolatedEditLocationState extends State<IsolatedEditLocation> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    var blocRead = context.read<OrderCubit>();
    _controller = TextEditingController(text: blocRead.locationController.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var blocRead = context.read<OrderCubit>();
    return AuthTextFieldWithHeader(
      horizontalPadding: 0,
      header: "Location",
      hintText: blocRead.requestStatus!.requestLocation,
      isWithValidation: true,
      textInputType: TextInputType.name,
      validationText: "Invalid Location.",
      textEditingController: _controller,
      validation: TextFieldValidation.valid,
      onChange: (value) {
        blocRead.locationController.text = value;
      },
      onSubmit: (value) {},
    );
  }
}
