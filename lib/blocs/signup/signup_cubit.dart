import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/core/services/networking/repositories/car_repository.dart';
import 'package:turbo/core/services/networking/repositories/cities_districts_repository.dart';
import 'package:turbo/models/district_model.dart';

import '../../core/helpers/app_regex.dart';
import '../../core/helpers/enums.dart';
import '../../core/routing/screens_arguments.dart';
import '../../core/services/local/storage_service.dart';
import '../../core/services/local/token_service.dart';
import '../../main_paths.dart';
import '../../models/attachment.dart';

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

  double calculatedPrice = 0.0;
  num calculatedDriverFees = 0.0;
  double calculatedPriceWithVat = 0.0;
  double pricePerDay = 0.0;
  double dailyPrice = 0;
  double weeklyPrice = 0;
  double monthlyPrice = 0;
  bool isPhoneVerified = false;

  List<File>? nationalIdFile = [];
  List<File>? passportFiles = [];

  Attachment? nationalIdAttachments;
  String nationalIdOldPaths = "";
  int nationalIdInitStatus = 0;

  Attachment? passportAttachments;
  String passportOldPaths = "";
  int passportInitStatus = 0;
  String otpVerificationId = '';

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

  TextEditingController nationalIdController = TextEditingController();
  TextFieldValidation nationalIdValidation = TextFieldValidation.normal;

  TextEditingController drivingLicenceController = TextEditingController();
  TextFieldValidation drivingLicenceValidation = TextFieldValidation.normal;

  bool isWithPrivateDriver = false;

  DateTime? pickedDate;
  DateTime? deliveryDate;

  DateTime? nationalIdExpiryDate;
  DateTime? drivingLicenceExpiryDate;

  String requestedCarId = "";

  String currentPhoneNumber = '';

  TextEditingController locationController = TextEditingController();
  TextFieldValidation locationValidation = TextFieldValidation.normal;

  List<TextEditingController> codeControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<FocusNode> codeFocusNode = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  void onInit(SignupScreenArguments arguments) {
    requestedCarId = arguments.carId;
    dailyPrice = arguments.dailyPrice.toDouble();
    weeklyPrice = arguments.weeklyPrice.toDouble();
    monthlyPrice = arguments.monthlyPrice.toDouble();
    citySelectedIndex = authRepository.selectedCityIndex;
    if (UserTokenService.currentUserToken.isNotEmpty) {
      currentStep = 2;
      nationalIdAttachments = findAttachmentFile(
        type: "nationalId",
        attachments: authRepository.customer.attachments,
      );
      nationalIdOldPaths = nationalIdAttachments?.filePath ?? "";
      nationalIdInitStatus = nationalIdAttachments?.fileStatus ?? -1;
      passportAttachments = findAttachmentFile(
        type: "passport",
        attachments: authRepository.customer.attachments,
      );
      passportOldPaths = passportAttachments?.filePath ?? "";
      passportInitStatus = passportAttachments?.fileStatus ?? -1;
    }
    clearCodeControllers();
  }

  bool _areAllControllersFilled(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  void clearCodeControllers() {
    for (var controller in codeControllers) {
      controller.clear();
    }
  }

  Future<bool> sendOTP() async {
    bool isOtpSent = false;
    emit(const SignupState.sendOTPLoading());
    await authRepository.sendOTP(phoneNumber).then((value) {
      value.fold((errMsg) {
        otpVerificationId = '';
        emit(
          SignupState.otpSentFailed(
            errMsg: errMsg,
          ),
        );
      }, (value) {
        otpVerificationId = value;
        clearCodeControllers();
        isOtpSent = true;
        emit(
          SignupState.otpSentSuccessfully(
            phoneNumber: phoneNumber,
            verificationID: otpVerificationId,
          ),
        );
      });
    }).catchError((err) {
      otpVerificationId = '';
      emit(
        SignupState.otpSentFailed(
          errMsg: err.toString(),
        ),
      );
    });
    return isOtpSent;
  }

  void checkOTP() {
    if (_areAllControllersFilled(codeControllers)) {
      verifyOTP();
    }
  }

  Future<void> verifyOTP() async {
    emit(const SignupState.verifyOTPLoading());
    String smsCode = codeControllers[0].text +
        codeControllers[1].text +
        codeControllers[2].text +
        codeControllers[3].text +
        codeControllers[4].text +
        codeControllers[5].text;
    await authRepository
        .verifyOTP(
      verificationId: otpVerificationId,
      smsCode: smsCode,
    )
        .then((_) async {
      isPhoneVerified = true;

      final res = await authRepository.signupInfoStep(
        customerName: customerNameController.text,
        customerEmail: customerEmailController.text,
        customerAddress: customerAddressController.text,
        customerTelephone: phoneNumber,
        customerPassword: passwordController.text,
        customerCountry: country,
        customerCountryCode: countryIsoCode,
        customerType: saCitizenSelectedIndex,
        customerNationalId: nationalIdController.text,
        customerNationalIDExpiryDate: nationalIdExpiryDate!.toIso8601String(),
        customerDriverLicenseNumber: drivingLicenceController.text.isNotEmpty
            ? drivingLicenceController.text
            : null,
        customerDriverLicenseNumberExpiryDate:
            drivingLicenceExpiryDate?.toIso8601String(),
      );
      res.fold(
        (errMsg) => emit(
          SignupState.otpVerifyFailed(
            errMsg: errMsg,
          ),
        ),
        (_) {
          emit(
            SignupState.otpVerifySuccess(
              smsCode: smsCode,
              verificationID: otpVerificationId,
            ),
          );
        },
      );
    }).catchError((err) {
      emit(
        SignupState.otpVerifyFailed(
          errMsg: err.toString(),
        ),
      );
    });
  }

  void changeNationalIdState(int status) {
    nationalIdInitStatus = status;
    emit(SignupState.changeNationalIdStatus(state: status));
  }

  void changePassportState(int status) {
    passportInitStatus = status;
    emit(SignupState.changePassportStatus(state: status));
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

  void checkNationalIdValidation() {
    if (nationalIdController.text.isNotEmpty) {
      nationalIdValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkNationalIdValidation(
          nationalId: nationalIdController.text,
          validation: nationalIdValidation,
        ),
      );
    } else {
      nationalIdValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkNationalIdValidation(
          nationalId: nationalIdController.text,
          validation: nationalIdValidation,
        ),
      );
    }
  }

  void changeNationalIdExpiryDate(DateTime date) {
    nationalIdExpiryDate = date;
    emit(SignupState.changeNationalIdExpiry(date: date.toIso8601String()));
  }

  void changeDrivingLicenceExpiryDate(DateTime date) {
    drivingLicenceExpiryDate = date;
    emit(SignupState.changeDrivingLicenceExpiry(date: date.toIso8601String()));
  }

  void checkDrivingLicenceValidation() {
    if (drivingLicenceController.text.isNotEmpty) {
      drivingLicenceValidation = TextFieldValidation.valid;
      emit(
        SignupState.checkDrivingLicenceValidation(
          drivingLicence: drivingLicenceController.text,
          validation: drivingLicenceValidation,
        ),
      );
    } else {
      drivingLicenceValidation = TextFieldValidation.notValid;
      emit(
        SignupState.checkDrivingLicenceValidation(
          drivingLicence: drivingLicenceController.text,
          validation: drivingLicenceValidation,
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
    checkNationalIdValidation();
    if (isSaudiOrSaudiResident()) {
      checkDrivingLicenceValidation();
    }

    if (isFieldNotEmpty(customerNameController) &&
        isFieldNotEmpty(customerEmailController) &&
        isFieldNotEmpty(customerAddressController) &&
        isFieldNotEmpty(passwordController) &&
        isFieldNotEmpty(confirmPasswordController) &&
        phoneNumber.isNotEmpty &&
        isFieldNotEmpty(nationalIdController) &&
        nationalIdExpiryDate != null &&
        drivingLicenceExpiryDate != null &&
        (isFieldNotEmpty(drivingLicenceController) ||
            isSaudiOrSaudiResident())) {
      if (isFieldValid(customerNameValidation) &&
          isFieldValid(customerEmailValidation) &&
          isFieldValid(customerAddressValidation) &&
          isFieldValid(passwordValidation) &&
          isFieldValid(confirmPasswordValidation) &&
          phoneValidation == TextFieldValidation.valid &&
          isFieldValid(nationalIdValidation)) {
        emit(const SignupState.submitCustomerInfoLoading());
        final res = await authRepository.checkUserExistence(
          email: customerEmailController.text,
          phoneNumber: phoneNumber,
        );
        res.fold(
          (errMsg) {
            emit(SignupState.submitCustomerInfoFailed(errMsg: errMsg));
          },
          (r) {
            sendOTP();
          },
        );
      }
    } else {
      emit(const SignupState.submitCustomerInfoFailed(
          errMsg: "Please complete all required fields"));
    }
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
    pricePerDay = 0.0;
    calculatedDriverFees = 0;
    if (deliveryDate != null && pickedDate != null) {
      final int durationInDays = deliveryDate!.difference(pickedDate!).inDays;

      if (durationInDays >= 1 && durationInDays < 7) {
        pricePerDay = dailyPrice;
      } else if (durationInDays >= 7 && durationInDays < 30) {
        pricePerDay = weeklyPrice;
      } else {
        pricePerDay = monthlyPrice;
      }
      calculatedPrice = durationInDays * pricePerDay;
      if (isWithPrivateDriver) {
        calculatedDriverFees = (AppConstants.driverFees * durationInDays);
        calculatedPrice += calculatedDriverFees;
      } else {
        calculatedDriverFees = 0;
      }
    }

    emit(SignupState.calculatePrice(price: calculatedPrice));
  }

  void confirmBookingClicked() async {
    checkLocationValidation();
    try {
      if (deliveryDate == null || deliveryDate == null) {
        emit(const SignupState.confirmBookingFailed(
            errMsg: "Complete all required fields"));
      } else if ((deliveryDate != null || deliveryDate != null) &&
          ((nationalIdFile != null && passportFiles != null) ||
              (authRepository.customer.attachments.isNotEmpty) ||
              isSaudiOrSaudiResident()) &&
          locationController.text.isNotEmpty &&
          AppConstants.vat != -1 &&
          AppConstants.driverFees != -1) {
        calculatedPriceWithVat =
            calculatedPrice + (calculatedPrice * (AppConstants.vat / 100));
        emit(const SignupState.confirmBookingLoading());
        if (authRepository.customer.attachments.isNotEmpty ||
            isSaudiOrSaudiResident()) {
          List<String> userAttachmentsIds = [];
          if (authRepository.customer.attachments.isNotEmpty) {
            for (var attachment in authRepository.customer.attachments) {
              userAttachmentsIds.add(attachment.id);
            }
          }
          final res = await carRepository.addNewRequest(
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
            requestPrice:
                double.parse(calculatedPriceWithVat.toStringAsFixed(2)),
            attachmentsIds: userAttachmentsIds,
            requestDailyCalculationPrice:
                double.parse(pricePerDay.toStringAsFixed(2)),
            requestPriceVat: AppConstants.vat,
            requestDriverDailyFee: AppConstants.driverFees,
          );
          res.fold(
            (errMsg) => emit(SignupState.confirmBookingFailed(errMsg: errMsg)),
            (res) {
              emit(SignupState.confirmBookingSuccess(
                  requestId: res['requestId'],
                  registerCode: res['registerCode'].toString()));
            },
          );
        } else {
          calculatedPriceWithVat =
              calculatedPrice + (calculatedPrice * (AppConstants.vat / 100));
          final res = await carRepository.addCarRequest(
            requestDriverDailyFee: AppConstants.driverFees,
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
            requestPrice:
                double.parse(calculatedPriceWithVat.toStringAsFixed(2)),
            nationalId: nationalIdFile ?? [],
            passport: passportFiles ?? [],
            requestDailyCalculationPrice:
                double.parse(pricePerDay.toStringAsFixed(2)),
            requestPriceVat: AppConstants.vat,
          );
          res.fold(
            (l) => (errMsg) =>
                emit(SignupState.confirmBookingFailed(errMsg: errMsg)),
            (res) {
              if (res.containsKey('attachmentIds')) {
                List<Attachment> userAttachments =
                    (res['attachmentIds'] as List)
                        .map(
                          (e) => Attachment.fromJson(e),
                        )
                        .toList();
                authRepository.customer.attachments = userAttachments;
              }

              emit(SignupState.confirmBookingSuccess(
                  requestId: res['requestId'],
                  registerCode: res['registerCode'].toString()));
            },
          );
        }
      }
    } catch (e) {
      emit(
        SignupState.confirmBookingFailed(errMsg: e.toString()),
      );
    }
  }

  void updateRequestFile({
    required String fileId,
    required String oldPathFiles,
    required String fileType,
    required File newFile,
  }) async {
    emit(SignupState.saveEditedFileLoading(fileId));
    try {
      final res = await carRepository.editRequestFile(
        fileType: fileType,
        attachmentId: fileId,
        oldPathFiles: oldPathFiles,
        newFile: newFile,
      );

      res.fold(
        (errMsg) => emit(SignupState.saveEditedFileError(errMsg, fileId)),
        (newAttachments) {
          int index = 0;
          for (Attachment attachment in authRepository.customer.attachments) {
            if (attachment.id == fileId) {
              authRepository.customer.attachments[index] = newAttachments;
              break;
            }
            index++;
          }
          StorageService.saveData(
            "customerData",
            json.encode(authRepository.customer.toJson()),
          );
          nationalIdAttachments = findAttachmentFile(
            type: "nationalId",
            attachments: authRepository.customer.attachments,
          );
          nationalIdOldPaths = nationalIdAttachments?.filePath ?? "";
          nationalIdInitStatus = nationalIdAttachments?.fileStatus ?? 0;
          passportAttachments = findAttachmentFile(
            type: "passport",
            attachments: authRepository.customer.attachments,
          );
          passportInitStatus = passportAttachments?.fileStatus ?? 0;
        },
      );
      emit(SignupState.saveEditedFileSuccess(fileId));
    } catch (e) {
      emit(SignupState.saveEditedFileError(e.toString(), fileId));
    }
  }

  bool isSaudiOrSaudiResident() {
    return dialCode.startsWith("+966") ||
        (authRepository.customer.customerType == 1
            ? false
            : saCitizenSelectedIndex == 0);
  }
}

bool isFieldValid(
  TextFieldValidation validation,
) {
  if (validation == TextFieldValidation.valid) {
    return true;
  } else {
    return false;
  }
}

bool isFieldNotEmpty(TextEditingController controller) {
  if (controller.text.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
