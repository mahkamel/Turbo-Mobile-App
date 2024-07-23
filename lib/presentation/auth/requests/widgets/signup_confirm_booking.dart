import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/routing/screens_arguments.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/auth/requests/widgets/select_file.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/text_field_with_header.dart';
import '../../../../core/widgets/widget_with_header.dart';
import 'date_selection.dart';

class SignupConfirmBooking extends StatelessWidget {
  const SignupConfirmBooking({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookingLocationField(),
          PrivateDriverRow(),
          PickupDateSelection(),
          DeliveryDateSelection(),
          RentalPrice(),
          SizedBox(
            height: 16,
          ),
          RequiredFilesSection(),
          ConfirmBookingButton()
        ],
      ),
    );
  }
}

class ConfirmBookingButton extends StatelessWidget {
  const ConfirmBookingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final blocRead = context.read<SignupCubit>();

    return BlocConsumer<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          current is ConfirmBookingErrorState ||
          current is ConfirmBookingSuccessState,
      listener: (context, state) {
        if (state is ConfirmBookingErrorState) {
          defaultErrorSnackBar(context: context, message: state.errMsg);
        } else if (state is ConfirmBookingSuccessState) {
          Navigator.of(context).pushReplacementNamed(
            Routes.paymentScreen,
            arguments: PaymentScreenArguments(
              paymentAmount: blocRead.calculatedPriceWithVat,
              carRequestId: state.requestId,
            ),
          );
        }
      },
      builder: (context, state) {
        var blocWatch = context.watch<SignupCubit>();
        return DefaultButton(
          loading: state is ConfirmBookingLoadingState,
          marginRight: 16,
          marginLeft: 16,
          marginTop: 24,
          marginBottom: 24,
          color: blocWatch.locationValidation != TextFieldValidation.valid ||
                  blocWatch.deliveryDate == null ||
                  blocWatch.pickedDate == null ||
                  state is SaveRequestEditedFileLoadingState ||
                  blocWatch.nationalIdInitStatus == 2 ||
                  blocWatch.passportInitStatus == 2 ||
                  blocWatch.nationalIdInitStatus == -1 ||
                  blocWatch.passportInitStatus == -1
              ? AppColors.greyBorder
              : AppColors.primaryRed,
          text: "Confirm Booking",
          function: () {
            if (state is! ConfirmBookingLoadingState &&
                state is! SaveRequestEditedFileLoadingState &&
                blocWatch.locationValidation == TextFieldValidation.valid &&
                blocWatch.deliveryDate != null &&
                blocWatch.pickedDate != null &&
                blocWatch.nationalIdInitStatus != 2 &&
                blocWatch.passportInitStatus != 2 &&
                blocWatch.nationalIdInitStatus != -1 &&
                blocWatch.passportInitStatus != -1) {
              blocRead.confirmBookingClicked();
            }
          },
        );
      },
    );
  }
}

class RequiredFilesSection extends StatelessWidget {
  const RequiredFilesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final blocRead = context.read<SignupCubit>();
    if (context.watch<AuthRepository>().customer.attachments.isEmpty) {
      return WidgetWithHeader(
        header: "Files",
        isRequiredField: true,
        headerStyle: AppFonts.inter16Black500.copyWith(
          color: AppColors.primaryRed,
          fontSize: 18,
        ),
        widget: Column(
          children: [
            SelectFile(
              key: const Key("NationalIDConfirm"),
              isFromMyApplication: false,
              padding: EdgeInsetsDirectional.zero,
              header: "National ID",
              onFileSelected: (p0, isSingle) async {
                blocRead.nationalIdFile = await convertPlatformFileList(p0);
                blocRead.changeNationalIdState(0);
              },
              onPrefixClicked: () {
                blocRead.nationalIdFile = null;
                blocRead.changeNationalIdState(-1);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            SelectFile(
              key: const Key("PassportConfirm"),
              isFromMyApplication: false,
              padding: EdgeInsetsDirectional.zero,
              header: "Passport",
              onFileSelected: (p0, isSingle) async {
                blocRead.passportFiles = await convertPlatformFileList(p0);
                blocRead.changePassportState(0);
              },
              onPrefixClicked: () {
                blocRead.passportFiles = null;
                blocRead.changePassportState(-1);
              },
            ),
          ],
        ),
      );
    } else {
      return const ExistingUserAttachments();
    }
  }
}

class ExistingUserAttachments extends StatefulWidget {
  const ExistingUserAttachments({
    super.key,
  });

  @override
  State<ExistingUserAttachments> createState() =>
      _ExistingUserAttachmentsState();
}

class _ExistingUserAttachmentsState extends State<ExistingUserAttachments> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          current is SaveRequestEditedFileErrorState ||
          current is SaveRequestEditedFileSuccessState,
      listener: (context, state) {
        if (state is SaveRequestEditedFileErrorState) {
          defaultErrorSnackBar(context: context, message: state.errMsg);
        } else if (state is SaveRequestEditedFileSuccessState) {
          defaultSuccessSnackBar(
              context: context,
              message: "Your File has been updated successfully");
        }
      },
      builder: (context, state) {
        var blocWatch = context.watch<SignupCubit>();
        var blocRead = context.read<SignupCubit>();
        return WidgetWithHeader(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          header: "Files",
          isRequiredField: true,
          headerStyle: AppFonts.inter16Black500.copyWith(
            color: AppColors.primaryRed,
            fontSize: 18,
          ),
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                width: AppConstants.screenWidth(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectFile(
                      isShowReplaceWithoutBorder: true,
                      isFromMyApplication: true,
                      width: blocWatch.nationalIdAttachments?.fileStatus == 4
                          ? AppConstants.screenWidth(context) - 80
                          : AppConstants.screenWidth(context) - 32,
                      key: const Key("NewRequestNationalID"),
                      padding: const EdgeInsetsDirectional.only(bottom: 4),
                      paths: blocRead.nationalIdAttachments?.filePath ?? "",
                      header: "National ID",
                      prefixImgPath: "assets/images/icons/national_id.png",
                      isFromPending: true,
                      onFileSelected: (p0, isSingle) async {
                        blocRead.nationalIdFile =
                            await convertPlatformFileList(p0);
                        if (blocRead.nationalIdAttachments != null &&
                            blocRead.nationalIdAttachments?.fileRejectComment !=
                                null) {
                          blocRead.nationalIdAttachments?.fileRejectComment =
                              null;
                          blocRead.nationalIdAttachments?.filePath = "";
                          blocRead.nationalIdAttachments?.fileStatus = 4;
                          setState(() {});
                        }
                      },
                      isWarningToReplace:
                          blocWatch.nationalIdAttachments?.fileStatus == 2,
                      onPrefixClicked: () {
                        if (blocRead.nationalIdAttachments == null ||
                            (blocRead.nationalIdAttachments != null &&
                                blocRead.nationalIdAttachments
                                        ?.fileRejectComment ==
                                    null)) {
                          blocRead.nationalIdFile = null;
                          setState(() {});
                        }
                      },
                    ),
                    if (blocRead.nationalIdAttachments?.fileStatus == 4)
                      BlocBuilder<SignupCubit, SignupState>(
                        buildWhen: (previous, current) {
                          return (current
                                      is SaveRequestEditedFileLoadingState &&
                                  current.fileId ==
                                      blocRead.nationalIdAttachments?.id) ||
                              (current is SaveRequestEditedFileSuccessState &&
                                  current.fileId ==
                                      blocRead.nationalIdAttachments?.id) ||
                              (current is SaveRequestEditedFileErrorState &&
                                  current.fileId ==
                                      blocRead.nationalIdAttachments?.id);
                        },
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: Center(
                              child:
                                  (state is SaveRequestEditedFileLoadingState &&
                                          state
                                                  .fileId ==
                                              blocRead
                                                  .nationalIdAttachments?.id)
                                      ? const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 8.0),
                                          child: CircularProgressIndicator(),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            if (blocRead.nationalIdFile !=
                                                    null &&
                                                blocRead.nationalIdFile!
                                                    .isNotEmpty &&
                                                blocRead.nationalIdAttachments
                                                        ?.fileStatus !=
                                                    2) {
                                              blocRead.updateRequestFile(
                                                fileId: blocRead
                                                        .nationalIdAttachments
                                                        ?.id ??
                                                    "",
                                                oldPathFiles:
                                                    blocRead.nationalIdOldPaths,
                                                fileType: "nationalId",
                                                newFile: blocRead
                                                    .nationalIdFile!.first,
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
              SizedBox(
                height: 110,
                width: AppConstants.screenWidth(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectFile(
                      isShowReplaceWithoutBorder: true,
                      isFromMyApplication: true,
                      width: blocWatch.passportAttachments?.fileStatus == 4
                          ? AppConstants.screenWidth(context) - 80
                          : AppConstants.screenWidth(context) - 32,
                      key: const Key("NewRequestPassport"),
                      padding: const EdgeInsetsDirectional.only(bottom: 4),
                      paths: blocRead.passportAttachments?.filePath ?? "",
                      header: "Passport",
                      isFromPending: true,
                      onFileSelected: (p0, isSingle) async {
                        blocRead.passportFiles =
                            await convertPlatformFileList(p0);
                        if (blocRead.passportAttachments != null &&
                            blocRead.passportAttachments?.fileRejectComment !=
                                null) {
                          blocRead.passportAttachments?.fileRejectComment =
                              null;
                          blocRead.passportAttachments?.filePath = "";
                          blocRead.passportAttachments?.fileStatus = 4;
                          setState(() {});
                        }
                      },
                      isWarningToReplace:
                          blocWatch.passportAttachments?.fileStatus == 2,
                      onPrefixClicked: () {
                        if (blocRead.passportAttachments == null ||
                            (blocRead.passportAttachments != null &&
                                blocRead.passportAttachments
                                        ?.fileRejectComment ==
                                    null)) {
                          blocRead.passportFiles = null;
                          setState(() {});
                        }
                      },
                    ),
                    if (blocRead.passportAttachments?.fileStatus == 4)
                      BlocBuilder<SignupCubit, SignupState>(
                        buildWhen: (previous, current) {
                          return (current
                                      is SaveRequestEditedFileLoadingState &&
                                  current.fileId ==
                                      blocRead.passportAttachments?.id) ||
                              (current is SaveRequestEditedFileSuccessState &&
                                  current.fileId ==
                                      blocRead.passportAttachments?.id) ||
                              (current is SaveRequestEditedFileErrorState &&
                                  current.fileId ==
                                      blocRead.passportAttachments?.id);
                        },
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: Center(
                              child:
                                  (state is SaveRequestEditedFileLoadingState &&
                                          state.fileId ==
                                              blocRead.passportAttachments?.id)
                                      ? const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 8.0),
                                          child: CircularProgressIndicator(),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            if (blocRead.passportFiles !=
                                                    null &&
                                                blocRead.passportFiles!
                                                    .isNotEmpty &&
                                                blocRead.passportAttachments
                                                        ?.fileStatus !=
                                                    2) {
                                              blocRead.updateRequestFile(
                                                fileId: blocRead
                                                        .passportAttachments
                                                        ?.id ??
                                                    "",
                                                oldPathFiles:
                                                    blocRead.passportOldPaths,
                                                fileType: "passport",
                                                newFile: blocRead
                                                    .passportFiles!.first,
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
            ],
          ),
        );
      },
    );
  }
}

class RentalPrice extends StatelessWidget {
  const RentalPrice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => current is CalculatePriceState,
      builder: (context, state) {
        var blocWatch = context.watch<SignupCubit>();
        return Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20.0,
            end: 20.0,
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
                    "${blocWatch.calculatedPrice.toStringAsFixed(2)} ",
                    style: AppFonts.inter16Black500,
                  ),
                  Text(
                    "SAR",
                    style: AppFonts.inter16Black500,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      "Vat (${AppConstants.vat}%): ",
                      style: AppFonts.inter16TypeGreyHeader600,
                    ),
                    const Spacer(),
                    Text(
                      "${(blocWatch.calculatedPrice * (AppConstants.vat / 100)).toStringAsFixed(2)} ",
                      style: AppFonts.inter16Black500,
                    ),
                    Text(
                      "SAR",
                      style: AppFonts.inter16Black500,
                    ),
                  ],
                ),
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
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${((blocWatch.calculatedPrice * (AppConstants.vat / 100)) + blocWatch.calculatedPrice).toStringAsFixed(2)} ",
                    style: AppFonts.inter16Black500.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "SAR",
                    style: AppFonts.inter16Black500,
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

class DeliveryDateSelection extends StatelessWidget {
  const DeliveryDateSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) =>
          current is ChangeSelectedDatesValueState,
      builder: (context, state) {
        final blocRead = context.read<SignupCubit>();

        return DateSelection(
          key: const Key("DeliveryDate"),
          header: "Delivery",
          isRequired: true,
          minDate: context.watch<SignupCubit>().pickedDate != null
              ? context
                  .watch<SignupCubit>()
                  .pickedDate!
                  .add(const Duration(days: 1, minutes: 30))
              : DateTime.now().add(const Duration(days: 1, minutes: 30)),
          isDeliveryDate: true,
          selectedDateTime: context.watch<SignupCubit>().deliveryDate,
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

class PickupDateSelection extends StatelessWidget {
  const PickupDateSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final blocRead = context.read<SignupCubit>();
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) =>
          current is ChangeSelectedDatesValueState,
      builder: (context, state) {
        return DateSelection(
          key: const Key("PickupDate"),
          isRequired: true,
          header: "Pickup",
          minDate: DateTime.now().add(const Duration(hours: 1)),
          selectedDateTime: context.watch<SignupCubit>().pickedDate,
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

class PrivateDriverRow extends StatelessWidget {
  const PrivateDriverRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final blocRead = context.read<SignupCubit>();

    return AppConstants.driverFees == -1 || AppConstants.driverFees == 0
        ? const SizedBox(
            height: 16,
          )
        : Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 20.0,
              end: 10.0,
              top: 16.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                Text(
                  "Private Driver?",
                  style: AppFonts.inter16Black500
                      .copyWith(color: AppColors.primaryRed),
                ),
                const Spacer(),
                BlocBuilder<SignupCubit, SignupState>(
                  buildWhen: (previous, current) =>
                      current is ChangeIsWithPrivateDriverValueState,
                  builder: (context, state) {
                    return Switch.adaptive(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: context.watch<SignupCubit>().isWithPrivateDriver,
                      onChanged: (value) {
                        blocRead.changeIsWithPrivateDriverValue(value);
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }
}

class BookingLocationField extends StatelessWidget {
  const BookingLocationField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => current is CheckLocationValidationState,
      builder: (context, state) {
        final blocRead = context.read<SignupCubit>();

        return AuthTextFieldWithHeader(
          header: "Pickup Location*",
          hintText: "Enter Address",
          isWithValidation: true,
          textInputType: TextInputType.name,
          validationText: "Please Enter Pickup Address.",
          textEditingController: blocRead.locationController,
          validation: context.watch<SignupCubit>().locationValidation,
          onTapOutside: () {
            blocRead.checkLocationValidation();
          },
          onChange: (value) {
            if (value.isEmpty ||
                blocRead.customerNameValidation != TextFieldValidation.normal) {
              blocRead.checkLocationValidation();
            }
          },
          onSubmit: (value) {
            blocRead.checkLocationValidation();
          },
        );
      },
    );
  }
}
