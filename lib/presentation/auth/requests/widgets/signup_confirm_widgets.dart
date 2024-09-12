import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/orders/order_cubit.dart';
import 'package:turbo/presentation/auth/requests/widgets/select_file.dart';

import '../../../../blocs/signup/signup_cubit.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/enums.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/routing/screens_arguments.dart';
import '../../../../core/services/networking/repositories/auth_repository.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/widgets/default_buttons.dart';
import '../../../../core/widgets/snackbar.dart';
import '../../../../core/widgets/text_field_with_header.dart';
import '../../../../core/widgets/widget_with_header.dart';
import 'date_selection.dart';

class CarColorSelection extends StatelessWidget {
  const CarColorSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Car Colors",
            style: AppFonts.ibm16LightBlack600,
          ),
          const SizedBox(
            height: 6,
          ),
          Wrap(
            spacing: 5,
            children: [
              ...List.generate(
                  context.read<SignupCubit>().carColors.length,
                  (index) => InkWell(
                        onTap: () {
                          context.read<SignupCubit>().changeCarColor(index);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: context
                                            .watch<SignupCubit>()
                                            .selectedColorIndex ==
                                        index
                                    ? AppColors.secondary
                                    : context
                                        .read<SignupCubit>()
                                        .carColors[index]
                                        .color,
                                width: 4),
                            color: context
                                .read<SignupCubit>()
                                .carColors[index]
                                .color,
                          ),
                        ),
                      ))
            ],
          ),
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
    var blocWatch = context.watch<SignupCubit>();

    return blocRead.isSaudiOrSaudiResident() &&
            context.watch<AuthRepository>().customer.attachments.isEmpty
        ? BlocConsumer<SignupCubit, SignupState>(
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
                    carRequestCode: state.registerCode,
                  ),
                );
              }
            },
            builder: (context, state) {
              return DefaultButton(
                loading: state is ConfirmBookingLoadingState,
                marginRight: 16,
                marginLeft: 16,
                marginTop: 24,
                marginBottom: 24,
                color:
                    blocWatch.locationValidation == TextFieldValidation.valid &&
                            blocWatch.deliveryDate != null &&
                            blocWatch.pickedDate != null
                        ? AppColors.primaryBlue
                        : AppColors.greyBorder,
                text: "Confirm Booking",
                function: () {
                  if (state is! ConfirmBookingLoadingState &&
                      state is! SaveRequestEditedFileLoadingState &&
                      blocWatch.locationValidation ==
                          TextFieldValidation.valid &&
                      blocWatch.deliveryDate != null &&
                      blocWatch.pickedDate != null) {
                    blocRead.confirmBookingClicked();
                  }
                },
              );
            },
          )
        : BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              return Align(
                alignment: Alignment.centerRight,
                child: DefaultButton(
                  marginRight: 16,
                  marginLeft: 16,
                  width: 97,
                  marginTop: 24,
                  // marginBottom: 24,
                  color: blocWatch.locationValidation ==
                              TextFieldValidation.valid &&
                          blocWatch.deliveryDate != null &&
                          blocWatch.pickedDate != null
                      ? AppColors.primaryBlue
                      : AppColors.greyBorder,
                  text: "Next",
                  function: () {
                    if (blocWatch.locationValidation ==
                            TextFieldValidation.valid &&
                        blocWatch.deliveryDate != null &&
                        blocWatch.pickedDate != null) {
                      Navigator.of(context).pushNamed(Routes.uploadFilesScreen,
                          arguments: context.read<SignupCubit>());
                    }
                  },
                ),
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
    final blocWatch = context.watch<SignupCubit>();
    if (context.watch<AuthRepository>().customer.attachments.isEmpty) {
      return blocRead.isSaudiOrSaudiResident()
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 16.0,
              ),
              child: Column(
                children: [
                  SelectFile(
                    key: const Key("NationalIDConfirm"),
                    isFromMyApplication: false,
                    padding: EdgeInsetsDirectional.zero,
                    header: "National ID",
                    fileStatus: blocWatch.nationalIdInitStatus,
                    onFileSelected: (p0, isSingle) async {
                      blocRead.nationalIdFile =
                          await convertPlatformFileList(p0);
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
                    fileStatus: blocWatch.passportInitStatus,
                    onFileSelected: (p0, isSingle) async {
                      blocRead.passportFiles =
                          await convertPlatformFileList(p0);
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
          header: "",
          isRequiredField: false,
          headerStyle: AppFonts.inter16Black500.copyWith(
            color: AppColors.primaryBlue,
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
                      width: AppConstants.screenWidth(context) - 32,
                      key: const Key("NewRequestNationalID"),
                      padding: const EdgeInsetsDirectional.only(bottom: 4),
                      paths: blocRead.nationalIdAttachments?.filePath ?? "",
                      header: "National ID",
                      prefixImgPath: "assets/images/icons/national_id.png",
                      isFromPending: true,
                      fileStatus: blocWatch.nationalIdAttachments?.fileStatus ??
                          blocWatch.nationalIdInitStatus,
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
                        if (blocWatch.nationalIdAttachments?.fileStatus == 4) {
                          if (blocRead.nationalIdFile != null &&
                              blocRead.nationalIdFile!.isNotEmpty &&
                              blocRead.nationalIdAttachments?.fileStatus != 2) {
                            blocRead.updateRequestFile(
                              fileId: blocRead.nationalIdAttachments?.id ?? "",
                              oldPathFiles: blocRead.nationalIdOldPaths,
                              fileType: "nationalId",
                              newFile: blocRead.nationalIdFile!.first,
                            );
                          }
                        } else if (blocRead.nationalIdAttachments == null ||
                            (blocRead.nationalIdAttachments != null &&
                                blocRead.nationalIdAttachments
                                        ?.fileRejectComment ==
                                    null)) {
                          blocRead.nationalIdFile = null;
                          setState(() {});
                        }
                      },
                      isUploading: (state
                              is SaveRequestEditedFileLoadingState &&
                          state.fileId == blocRead.nationalIdAttachments?.id),
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
                      width: AppConstants.screenWidth(context) - 32,
                      key: const Key("NewRequestPassport"),
                      fileStatus: blocWatch.passportAttachments?.fileStatus ??
                          blocWatch.passportInitStatus,
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
                        if (blocRead.passportAttachments?.fileStatus == 4) {
                          if (blocRead.passportFiles != null &&
                              blocRead.passportFiles!.isNotEmpty &&
                              blocRead.passportAttachments?.fileStatus != 2) {
                            blocRead.updateRequestFile(
                              fileId: blocRead.passportAttachments?.id ?? "",
                              oldPathFiles: blocRead.passportOldPaths,
                              fileType: "passport",
                              newFile: blocRead.passportFiles!.first,
                            );
                          }
                        } else if (blocRead.passportAttachments == null ||
                            (blocRead.passportAttachments != null &&
                                blocRead.passportAttachments
                                        ?.fileRejectComment ==
                                    null)) {
                          blocRead.passportFiles = null;
                          setState(() {});
                        }
                      },
                      isUploading:
                          (state is SaveRequestEditedFileLoadingState &&
                              state.fileId == blocRead.passportAttachments?.id),
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
            top: 32.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Rental price: ",
                    style: AppFonts.ibm16Divider600,
                  ),
                  const Spacer(),
                  Text(
                    "${(blocWatch.calculatedPrice - blocWatch.calculatedDriverFees).toStringAsFixed(2)} SAR",
                    style: AppFonts.ibm16Secondary600,
                  ),
                ],
              ),
              if (blocWatch.isWithPrivateDriver)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        "Driver fees: ",
                        style: AppFonts.ibm16Divider600,
                      ),
                      const Spacer(),
                      Text(
                        "${(blocWatch.calculatedDriverFees).toStringAsFixed(2)} SAR",
                        style: AppFonts.ibm16Secondary600,
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Text(
                    "Vat (${AppConstants.vat}%): ",
                    style: AppFonts.ibm16Divider600,
                  ),
                  const Spacer(),
                  Text(
                    "${(blocWatch.calculatedPrice * (AppConstants.vat / 100)).toStringAsFixed(2)} SAR",
                    style: AppFonts.ibm16Secondary600,
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
                    style: AppFonts.ibm16PrimaryBlue600,
                  ),
                  const Spacer(),
                  Text(
                    "${((blocWatch.calculatedPrice * (AppConstants.vat / 100)) + blocWatch.calculatedPrice).toStringAsFixed(2)} SAR",
                    style: AppFonts.ibm16Secondary600,
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
    return AppConstants.driverFees == -1 || AppConstants.driverFees == 0
        ? const SizedBox(
            height: 16,
          )
        : Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 20.0,
              end: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Private Driver?",
                  style: AppFonts.ibm16LightBlack600,
                ),
                const SizedBox(
                  height: 6,
                ),
                BlocBuilder<SignupCubit, SignupState>(
                  buildWhen: (previous, current) =>
                      current is ChangeIsWithPrivateDriverValueState,
                  builder: (context, state) {
                    var blocRead = context.read<SignupCubit>();
                    var isWithPrivate =
                        context.watch<SignupCubit>().isWithPrivateDriver;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRadioButton(
                          isSelected: isWithPrivate,
                          type: "Yes",
                          onTap: () {
                            blocRead.changeIsWithPrivateDriverValue(true);
                          },
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        CustomRadioButton(
                          isSelected: !isWithPrivate,
                          type: "No",
                          onTap: () {
                            blocRead.changeIsWithPrivateDriverValue(false);
                          },
                        ),
                      ],
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
