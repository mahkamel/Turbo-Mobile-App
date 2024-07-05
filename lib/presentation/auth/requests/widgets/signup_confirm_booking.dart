import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo/blocs/signup/signup_cubit.dart';
import 'package:turbo/core/helpers/enums.dart';
import 'package:turbo/core/routing/screens_arguments.dart';
import 'package:turbo/core/widgets/custom_dropdown.dart';
import 'package:turbo/core/widgets/snackbar.dart';
import 'package:turbo/presentation/auth/requests/widgets/select_file.dart';

import '../../../../core/helpers/dropdown_keys.dart';
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
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(),
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: () {
          if (districtsKey.currentState != null) {
            if (districtsKey.currentState!.isOpen) {
              districtsKey.currentState!.closeBottomSheet();
            }
          }
        },
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 12.0),
            //   child: DistrictsDropdown(),
            // ),
            BookingLocationField(),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 20.0,
                end: 10.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: PrivateDriverRow(),
            ),
            PickupDateSelection(),
            DeliveryDateSelection(),
            RentalPrice(),
            SizedBox(
              height: 8,
            ),
            RequiredFilesSection(),
            ConfirmBookingButton()
          ],
        ),
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
          Navigator.of(context).pushNamed(
            Routes.paymentScreen,
            arguments: PaymentScreenArguments(
              value: blocRead.calculatedPrice,
              carRequestId: state.requestId,
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is ConfirmBookingErrorState ||
          current is ConfirmBookingLoadingState ||
          current is ConfirmBookingSuccessState,
      builder: (context, state) {
        return DefaultButton(
          loading: state is ConfirmBookingLoadingState,
          marginRight: 16,
          marginLeft: 16,
          marginTop: 24,
          marginBottom: 24,
          text: "Confirm Booking",
          function: () {
            if (districtsKey.currentState != null) {
              if (districtsKey.currentState!.isOpen) {
                districtsKey.currentState!.closeBottomSheet();
              }
            }
            blocRead.confirmBookingClicked();
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

    return WidgetWithHeader(
      header: "Files",
      headerStyle: AppFonts.inter16Black500.copyWith(
        color: AppColors.primaryRed,
        fontSize: 18,
      ),
      widget: InkWell(
        onTap: () {
          if (districtsKey.currentState != null) {
            if (districtsKey.currentState!.isOpen) {
              districtsKey.currentState!.closeBottomSheet();
            }
          }
        },
        child: Column(
          children: [
            SelectFile(
              padding: EdgeInsetsDirectional.zero,
              header: "National ID",
              onFileSelected: (p0, isSingle) async {
                blocRead.files = await convertPlatformFileList(p0);
              },
              onPrefixClicked: () {
                blocRead.files = null;
              },
            ),
          ],
        ),
      ),
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
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Text.rich(
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
          minDate: context.watch<SignupCubit>().pickedDate != null
              ? context
                  .watch<SignupCubit>()
                  .pickedDate!
                  .add(const Duration(days: 1))
              : DateTime.now().add(const Duration(days: 1)),
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
    return DateSelection(
      key: const Key("PickupDate"),
      header: "Pickup",
      onDateSelected: (selectedDate) {
        blocRead.pickedDate = selectedDate;
        blocRead.changePickupDateValue(pickUp: selectedDate);
        blocRead.calculatePrice();
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

    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        if (districtsKey.currentState != null) {
          if (districtsKey.currentState!.isOpen) {
            districtsKey.currentState!.closeBottomSheet();
          }
        }
      },
      child: Row(
        children: [
          Text(
            "Private Driver?",
            style: AppFonts.inter16Black500,
          ),
          const Spacer(),
          BlocBuilder<SignupCubit, SignupState>(
            buildWhen: (previous, current) =>
                current is ChangeIsWithPrivateDriverValueState,
            builder: (context, state) {
              return Checkbox(
                visualDensity: VisualDensity.standard,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: context.watch<SignupCubit>().isWithPrivateDriver,
                onChanged: (value) {
                  if (districtsKey.currentState != null) {
                    if (districtsKey.currentState!.isOpen) {
                      districtsKey.currentState!.closeBottomSheet();
                    }
                  }
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
          onTap: () {
            if (districtsKey.currentState != null) {
              if (districtsKey.currentState!.isOpen) {
                districtsKey.currentState!.closeBottomSheet();
              }
            }
          },
          header: "Location",
          hintText: "Enter Location",
          isWithValidation: true,
          textInputType: TextInputType.name,
          validationText: "Invalid Location.",
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

class DistrictsDropdown extends StatelessWidget {
  const DistrictsDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) =>
          current is GetDistrictByCityErrorState ||
          current is GetDistrictByCityLoadingState ||
          current is GetDistrictByCitySuccessState ||
          current is ChangeSelectedDistrictIndexState,
      builder: (context, state) {
        final blocRead = context.read<SignupCubit>();
        final blocWatch = context.watch<SignupCubit>();
        return WidgetWithHeader(
          header: "District",
          widget: state is GetDistrictByCityLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : blocWatch.districts.isEmpty
                  ? const SizedBox()
                  : CustomDropdown<int>(
                      onTap: () {},
                      border: Border.all(
                        color: AppColors.black.withOpacity(0.5),
                      ),
                      paddingLeft: 0,
                      key: districtsKey,
                      paddingRight: 0,
                      index: blocWatch.districtSelectedIndex,
                      showText: false,
                      listOfValues: blocWatch.districts
                          .map(
                            (e) => e.districtName,
                          )
                          .toList(),
                      text: "Select District",
                      isCheckedBox: false,
                      onChange: (_, int index) {
                        blocRead.changeSelectedDistrictId(index);
                      },
                      items: blocWatch.districts
                          .map(
                            (e) => e.districtName,
                          )
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (item) => CustomDropdownItem(
                              key: UniqueKey(),
                              value: item.key,
                              child: Text(
                                item.value,
                                style: AppFonts.inter15Black400,
                              ),
                            ),
                          )
                          .toList(),
                    ),
        );
      },
    );
  }
}
