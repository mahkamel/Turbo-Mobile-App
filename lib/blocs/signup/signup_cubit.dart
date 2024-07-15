import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';
import 'package:turbo/models/district_model.dart';

import '../../core/helpers/app_regex.dart';
import '../../core/helpers/enums.dart';
import '../../core/routing/screens_arguments.dart';

part 'signup_state.dart';
part 'signup_cubit.freezed.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;
  final CarRepository carRepository;
  final CitiesDistrictsRepository citiesDistrictsRepository;

  SignupCubit({
    required this.authRepository,
    required this.citiesDistrictsRepository,
    required this.carRepository,
  }) : super(const SignupState.initial());

  int currentStep = 0;
  int saCitizenSelectedIndex = 0;

  int citySelectedIndex = 0;
  int districtSelectedIndex = 0;

  double calculatedPrice = 0.0;
  double dailyPrice = 0;
  double weeklyPrice = 0;
  double monthlyPrice = 0;

  List<File>? nationalIdFile = [];
  List<File>? passportFiles = [];
  List<District> districts = [];

  TextEditingController customerNameController = TextEditingController();
  TextFieldValidation customerNameValidation = TextFieldValidation.normal;

  TextEditingController customerEmailController = TextEditingController();
  TextFieldValidation customerEmailValidation = TextFieldValidation.normal;

  TextEditingController customerAddressController = TextEditingController();
  TextFieldValidation customerAddressValidation = TextFieldValidation.normal;

  String phoneNumber = "";
  String country = "";
  String countryIsoCode = "";
  String dialCode = "";
  TextFieldValidation phoneValidation = TextFieldValidation.normal;

  TextEditingController passwordController = TextEditingController();
  TextFieldValidation passwordValidation = TextFieldValidation.normal;

  TextEditingController confirmPasswordController = TextEditingController();
  TextFieldValidation confirmPasswordValidation = TextFieldValidation.normal;

  bool isWithPrivateDriver = false;

  DateTime? pickedDate;
  DateTime? deliveryDate;

  String requestedCarId = "";

  TextEditingController locationController = TextEditingController();
  TextFieldValidation locationValidation = TextFieldValidation.normal;

  void onInit(SignupScreenArguments arguments) {
    requestedCarId = arguments.carId;
    dailyPrice = arguments.dailyPrice.toDouble();
    weeklyPrice = arguments.weeklyPrice.toDouble();
    monthlyPrice = arguments.monthlyPrice.toDouble();
    citySelectedIndex = authRepository.selectedCityIndex;
  }

  void changeStepIndicator(int index) {
    currentStep = index;
    emit(SignupState.changeIndicatorStep(currentStep: currentStep));
  }

  void changeSACitizenIndexValue(int index) {
    saCitizenSelectedIndex = index;
    emit(SignupState.changeSACitizenIndex(
        saCitizenIndex: saCitizenSelectedIndex));
  }

  void checkUserNameValidation() {
    if (customerNameController.text.isNotEmpty) {
      customerNameValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkName(
          name: customerNameController.text,
          validation: customerNameValidation,
        ),
      );
    } else {
      customerNameValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkName(
          name: customerNameController.text,
          validation: customerNameValidation,
        ),
      );
    }
  }

  void checkEmailValidationState() {
    if ((customerEmailController.text.isNotEmpty ||
            customerEmailValidation == TextFieldValidation.notValid) &&
        AppRegex.isEmailValid(customerEmailController.text)) {
      customerEmailValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkEmail(
          email: customerEmailController.text,
          validation: customerEmailValidation,
        ),
      );
    } else {
      customerEmailValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkEmail(
          email: customerEmailController.text,
          validation: customerEmailValidation,
        ),
      );
    }
  }

  void checkAddressValidation() {
    if (customerAddressController.text.isNotEmpty) {
      customerAddressValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkAddress(
          address: customerAddressController.text,
          validation: customerAddressValidation,
        ),
      );
    } else {
      customerAddressValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkAddress(
          address: customerAddressController.text,
          validation: customerAddressValidation,
        ),
      );
    }
  }

  void checkLocationValidation() {
    if (locationController.text.isNotEmpty) {
      locationValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkLocation(
          location: locationController.text,
          validation: locationValidation,
        ),
      );
    } else {
      locationValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkLocation(
          location: locationController.text,
          validation: locationValidation,
        ),
      );
    }
  }

  void checkPasswordValidation() {
    if (passwordController.text.isNotEmpty &&
        passwordController.text.length >= 6 &&
        AppRegex.hasSpecialCharacter(passwordController.text)) {
      passwordValidation = TextFieldValidation.valid;
      if (confirmPasswordController.text.isNotEmpty) {
        checkConfirmPasswordValidation();
      }
      emit(
        SignupState.checkPassword(
          password: passwordController.text,
          validation: passwordValidation,
        ),
      );
    } else {
      passwordValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkPassword(
          password: passwordController.text,
          validation: passwordValidation,
        ),
      );
    }
  }

  void checkConfirmPasswordValidation() {
    if (confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text == passwordController.text) {
      confirmPasswordValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkConfirmPassword(
          confirmPassword: confirmPasswordController.text,
          validation: confirmPasswordValidation,
        ),
      );
    } else {
      confirmPasswordValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkConfirmPassword(
          confirmPassword: confirmPasswordController.text,
          validation: confirmPasswordValidation,
        ),
      );
    }
  }

  void onPhoneNumberChange({
    required String phoneNumber,
    required String dialCode,
    required String country,
    required isoCode,
  }) {
    this.phoneNumber = phoneNumber;
    this.country = country;
    this.dialCode = dialCode;
    countryIsoCode = isoCode;
  }

  void checkPhoneValidation(bool isValid) {
    if (isValid) {
      phoneValidation = TextFieldValidation.valid;
    } else {
      phoneValidation = TextFieldValidation.notValid;
    }
  }

  void submitCustomerInfo() async {
    checkUserNameValidation();
    checkEmailValidationState();
    checkAddressValidation();
    checkPasswordValidation();
    checkConfirmPasswordValidation();
    if (isFieldValid(customerNameController, customerNameValidation) &&
        isFieldValid(customerEmailController, customerEmailValidation) &&
        isFieldValid(customerAddressController, customerAddressValidation) &&
        isFieldValid(confirmPasswordController, confirmPasswordValidation) &&
        isFieldValid(passwordController, passwordValidation) &&
        phoneNumber.isNotEmpty &&
        phoneValidation == TextFieldValidation.valid) {
      emit(const SignupState.submitCustomerInfoLoading());
      await Future.delayed(const Duration(seconds: 1));
      final res = await authRepository.signupInfoStep(
        customerName: customerNameController.text,
        customerEmail: customerEmailController.text,
        customerAddress: customerAddressController.text,
        customerTelephone: phoneNumber,
        customerPassword: passwordController.text,
        customerCountry: country,
        customerCountryCode: countryIsoCode,
        customerType: saCitizenSelectedIndex,
      );
      res.fold(
        (errMsg) => emit(SignupState.submitCustomerInfoFailed(errMsg: errMsg)),
        (_) {
          emit(const SignupState.submitCustomerInfoSuccess());
        },
      );
    } else {
      emit(const SignupState.submitCustomerInfoFailed(
          errMsg: "Please complete all required fields"));
    }
  }

  void getDistrictsByCity(String cityId) async {
    emit(SignupState.getDistrictByCityLoading(id: cityId));
    final result =
        await citiesDistrictsRepository.getDistrictBasedOnCity(cityId);
    result.fold((errMsg) {
      emit(SignupState.getDistrictByCityError(errMsg));
    }, (res) {
      districts = res;
      emit(
        SignupState.getDistrictByCitySuccess(
          districts: districts,
          cityId: cityId,
        ),
      );
    });
  }

  void changeSelectedCityIndex(int index) {
    citySelectedIndex = index;
    emit(SignupState.changeSelectedCityIndex(index: index));
    getDistrictsByCity(citiesDistrictsRepository.cities[citySelectedIndex].id);
  }

  void changeSelectedDistrictId(int index) {
    districtSelectedIndex = index;
    emit(SignupState.changeSelectedCityIndex(index: index));
  }

  void changeIsWithPrivateDriverValue(bool value) async {
    isWithPrivateDriver = value;
    if (AppConstants.driverFees == -1) {
      await carRepository.getDriverFees();
    }
    calculatePrice();
    emit(SignupState.changeIsWithPrivateDriverValue(
        isWithPrivateDriver: isWithPrivateDriver));
  }

  void changePickupDateValue({DateTime? pickUp}) {
    if (pickUp != null) {
      pickedDate = pickUp;
    }
    if (deliveryDate != null && deliveryDate!.isBefore(pickedDate!)) {
      deliveryDate = pickedDate!.add(const Duration(days: 1));
    }
    calculatePrice();
    emit(
      SignupState.changeSelectedDatesValue(
          pickUp: pickedDate, delivery: deliveryDate),
    );
  }

  void calculatePrice() {
    calculatedPrice = 0.0;
    print("isssss ${deliveryDate != null && pickedDate != null}");
    if (deliveryDate != null && pickedDate != null) {
      final int durationInDays = deliveryDate!.difference(pickedDate!).inDays;
      print("ssssss ${durationInDays} -- $dailyPrice");
      if (durationInDays >= 0 && durationInDays < 7) {
        calculatedPrice = durationInDays * dailyPrice;
      } else if (durationInDays >= 7 && durationInDays < 30) {
        calculatedPrice = durationInDays * weeklyPrice;
      } else {
        calculatedPrice = durationInDays * monthlyPrice;
      }
      print(
          "ssssss ${durationInDays} -- $dailyPrice -- ${weeklyPrice} -- $monthlyPrice");
    }
    if (isWithPrivateDriver) {
      calculatedPrice += AppConstants.driverFees;
    }
    emit(SignupState.calculatePrice(price: calculatedPrice));
  }

  void confirmBookingClicked() async {
    emit(const SignupState.confirmBookingLoading());
    checkLocationValidation();
    try {
      if (deliveryDate == null ||
          deliveryDate == null ||
          nationalIdFile == null ||
          passportFiles == null) {
        emit(const SignupState.confirmBookingFailed(
            errMsg: "Complete all required files"));
      } else if ((deliveryDate != null || deliveryDate != null) &&
          nationalIdFile != null &&
          passportFiles != null &&
          locationController.text.isNotEmpty &&
          AppConstants.vat != -1 &&
          AppConstants.driverFees != -1) {
        final res = await carRepository.addCarRequest(
          requestCarId: requestedCarId,
          requestLocation: locationController.text,
          requestBranchId: authRepository.selectedBranchId,
          isWithRequestDriver: isWithPrivateDriver,
          requestPeriod: pickedDate != null && deliveryDate != null
              ? deliveryDate!.difference(pickedDate!).inDays
              : 0,
          requestFromDate:
              pickedDate != null ? pickedDate!.toIso8601String() : "",
          requestToDate:
              deliveryDate != null ? deliveryDate!.toIso8601String() : "",
          requestCity: authRepository.selectedCityId,
          userToken: authRepository.customer.token,
          requestPrice: double.parse(calculatedPrice.toStringAsFixed(2)),
          nationalId: nationalIdFile ?? [],
          passport: passportFiles ?? [],
        );
        res.fold(
          (errMsg) => emit(SignupState.confirmBookingFailed(errMsg: errMsg)),
          (requestId) => emit(SignupState.confirmBookingSuccess(requestId)),
        );
      }
    } catch (e) {
      emit(
        SignupState.confirmBookingFailed(errMsg: e.toString()),
      );
    }
  }
}

bool isFieldValid(
  TextEditingController controller,
  TextFieldValidation validation,
) {
  if (controller.text.isNotEmpty && validation == TextFieldValidation.valid) {
    return true;
  } else {
    return false;
  }
}
