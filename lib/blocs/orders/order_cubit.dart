import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/models/request_model.dart';

import '../../core/helpers/constants.dart';
import '../../core/helpers/functions.dart';
import '../../core/services/local/storage_service.dart';
import '../../core/services/networking/repositories/car_repository.dart';
import '../../models/attachment.dart';
import '../../models/request_status_model.dart';

part 'order_state.dart';
part 'order_cubit.freezed.dart';

class OrderCubit extends Cubit<OrderState> {
  final CarRepository _carRepository;
  final AuthRepository _authRepository;
  OrderCubit(this._carRepository, this._authRepository)
      : super(const OrderState.initial());

  List<RequestModel> allRequests = [];
  RequestStatusModel? requestStatus;

  TextEditingController locationController = TextEditingController();

  bool isWithPrivateDriver = false;

  DateTime? pickedDate;
  DateTime? deliveryDate;

  double calculatedPrice = 0.0;
  double calculatedPriceWithVat = 0.0;
  num calculatedDriverFees = 0.0;
  double pricePerDay = 0.0;
  double dailyPrice = 0;
  double weeklyPrice = 0;
  double monthlyPrice = 0;

  File? nationalID;
  Attachment? nationalIdAttachments;
  String nationalIdOldPaths = "";
  int nationalIdInitStatus = 0;

  File? passportFiles;
  Attachment? passportAttachments;
  String passportOldPaths = "";
  int passportInitStatus = 0;

  void getAllCustomerRequests() async {
    emit(const OrderState.getAllRequestsLoading());
    try {
      final res = await _carRepository.getAllRequests();
      res.fold(
        (errMsg) {
          emit(OrderState.getAllRequestsError(errMsg));
        },
        (userRequests) {
          allRequests = userRequests;
          emit(const OrderState.getAllRequestsSuccess());
        },
      );
    } catch (e) {
      emit(OrderState.getAllRequestsError(e.toString()));
    }
  }

  void changeIsWithPrivateDriverValue(bool value) async {
    isWithPrivateDriver = value;
    if (AppConstants.driverFees == -1) {
      await _carRepository.getDriverFees();
    }
    calculatePrice();
    emit(OrderState.changeIsWithPrivateEditValue(
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
      OrderState.changeEditedDatesValue(
          pickUp: pickedDate, delivery: deliveryDate),
    );
  }

  void calculatePrice() {
    calculatedPrice = 0.0;
    pricePerDay = 0.0;
    calculatedDriverFees = 0.0;
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
      calculatedPriceWithVat =
          (calculatedPrice) + (calculatedPrice * (AppConstants.vat / 100));

      if (isWithPrivateDriver) {
        calculatedDriverFees = (AppConstants.driverFees * durationInDays);
        calculatedPrice += calculatedDriverFees;
        num driverFeesWithVats =
            (calculatedDriverFees * (AppConstants.vat / 100)) +
                calculatedDriverFees;
        calculatedPriceWithVat += driverFeesWithVats;
      } else {
        calculatedDriverFees = 0.0;
      }
    }

    emit(OrderState.calculateEditedPrice(price: calculatedPrice));
  }

  void getRequestStatus(String requestId) async {
    emit(OrderState.getRequestStatusLoading(requestId));
    try {
      final res = await _carRepository.getStatusByRequestId(requestId);
      res.fold(
        (errMsg) {
          emit(OrderState.getRequestStatusError(errMsg));
        },
        (status) {
          requestStatus = status;
          isWithPrivateDriver = status.requestDriver;
          pickedDate = status.requestFrom;
          deliveryDate = status.requestTo;
          calculatedPrice = status.requestPrice.toDouble();
          dailyPrice = status.requestCarId.last.dailyPrice.toDouble();
          weeklyPrice = status.requestCarId.last.weeklyPrice.toDouble();
          monthlyPrice = status.requestCarId.last.monthlyPrice.toDouble();
          nationalIdAttachments = findAttachmentFile(
            type: "nationalId",
            attachments: status.attachmentsId,
          );
          nationalIdOldPaths = nationalIdAttachments?.filePath ?? "";
          nationalIdInitStatus = nationalIdAttachments?.fileStatus ?? -1;
          passportAttachments = findAttachmentFile(
            type: "passport",
            attachments: status.attachmentsId,
          );
          // passportAttachments?.fileStatus = 2;
          passportOldPaths = passportAttachments?.filePath ?? "";
          passportInitStatus = passportAttachments?.fileStatus ?? -1;
          if (nationalIdAttachments == null &&
              requestStatus?.requestStatus == 4) {
            nationalIdInitStatus = 4;
          }

          if (passportAttachments == null &&
              requestStatus?.requestStatus == 4) {
            passportInitStatus = 4;
          }

          emit(OrderState.getRequestStatusSuccess(requestId));
        },
      );
    } catch (e) {
      emit(OrderState.getAllRequestsError(e.toString()));
    }
  }

  void saveEditedRequestData() async {
    emit(const OrderState.saveEditedDataLoading());
    if (pickedDate == null || pickedDate!.isBefore(DateTime.now())) {
      emit(const OrderState.saveEditedDataError(
          "Pickup date can't be before today"));
    } else if (deliveryDate == null ||
        deliveryDate!.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      emit(const OrderState.saveEditedDataError(
          "Pickup date can't be before tomorrow"));
    }
    try {
      if (calculatedPrice != 0.0 &&
              (deliveryDate != requestStatus!.requestTo) ||
          (pickedDate != requestStatus!.requestTo) ||
          (isWithPrivateDriver != requestStatus!.requestDriver) ||
          (locationController.text != requestStatus!.requestLocation) ||
          (calculatedPrice != requestStatus!.requestPrice) ||
          ((pickedDate != null && deliveryDate != null) &&
              (deliveryDate!.difference(pickedDate!).inDays !=
                  requestStatus!.requestPrice))) {
        final res = await _carRepository.editCarRequest(
          requestId: requestStatus!.id,
          requestTo:
              deliveryDate != requestStatus!.requestTo ? deliveryDate : null,
          requestForm:
              pickedDate != requestStatus!.requestFrom ? pickedDate : null,
          requestDriver: isWithPrivateDriver != requestStatus!.requestDriver
              ? isWithPrivateDriver
              : null,
          requestLocation: (locationController.text.isNotEmpty &&
                  locationController.text != requestStatus!.requestLocation)
              ? locationController.text
              : null,
          requestPrice: calculatedPrice != requestStatus!.requestPrice
              ? calculatedPriceWithVat
              : null,
          requestPeriod: (pickedDate != null && deliveryDate != null) &&
                  (deliveryDate!.difference(pickedDate!).inDays.toString() !=
                      requestStatus!.requestPeriod)
              ? deliveryDate!.difference(pickedDate!).inDays
              : null,
          requestDailyCalculationPrice:
              calculatedPrice != requestStatus!.requestPrice
                  ? pricePerDay
                  : null,
          requestDriverDailyFee:
              isWithPrivateDriver ? AppConstants.driverFees : null,
        );
        res.fold(
          (errMsg) {
            emit(OrderState.saveEditedDataError(errMsg));
          },
          (r) {
            if (deliveryDate != null &&
                deliveryDate != requestStatus!.requestTo) {
              requestStatus!.requestTo = deliveryDate!;
            } else if (pickedDate != null &&
                pickedDate != requestStatus!.requestFrom) {
              requestStatus!.requestFrom = pickedDate!;
            } else if (isWithPrivateDriver != requestStatus!.requestDriver) {
              requestStatus!.requestDriver = isWithPrivateDriver;
            } else if (locationController.text.isNotEmpty &&
                locationController.text != requestStatus!.requestLocation) {
              requestStatus!.requestLocation = locationController.text;
            } else if (calculatedPrice != requestStatus!.requestPrice) {
              requestStatus!.requestPrice = calculatedPrice;
            } else if ((pickedDate != null && deliveryDate != null) &&
                (deliveryDate!.difference(pickedDate!).inDays.toString() !=
                    requestStatus!.requestPeriod)) {
              requestStatus!.requestPeriod =
                  deliveryDate!.difference(pickedDate!).inDays.toString();
            }
            emit(OrderState.saveEditedDataSuccess(requestStatus!));
          },
        );
      }
    } catch (e) {
      emit(OrderState.saveEditedDataError(e.toString()));
    }
  }

  void updateRequestFile({
    required String fileId,
    required String oldPathFiles,
    required String fileType,
    required File newFile,
  }) async {
    emit(OrderState.saveEditedFileLoading(fileId));
    try {
      final res = await _carRepository.editRequestFile(
        fileType: fileType,
        attachmentId: fileId,
        oldPathFiles: oldPathFiles,
        newFile: newFile,
      );

      res.fold(
        (errMsg) => emit(OrderState.saveEditedFileError(errMsg, fileId)),
        (newAttachments) {
          if (fileType == "nationalId") {
            nationalID = null;
          } else {
            passportFiles = null;
          }
          int index = 0;
          for (Attachment attachment in _authRepository.customer.attachments) {
            if (attachment.id == fileId) {
              _authRepository.customer.attachments[index] = newAttachments;
              break;
            }
            index++;
          }
          StorageService.saveData(
            "customerData",
            json.encode(_authRepository.customer.toJson()),
          );
          nationalIdAttachments = findAttachmentFile(
            type: "nationalId",
            attachments: _authRepository.customer.attachments,
          );
          nationalIdOldPaths = nationalIdAttachments?.filePath ?? "";
          nationalIdInitStatus = nationalIdAttachments?.fileStatus ?? -1;
          passportAttachments = findAttachmentFile(
            type: "passport",
            attachments: _authRepository.customer.attachments,
          );
          nationalIdOldPaths = passportAttachments?.filePath ?? "";
          passportInitStatus = passportAttachments?.fileStatus ?? -1;
        },
      );
      emit(OrderState.saveEditedFileSuccess(fileId));
    } catch (e) {
      emit(OrderState.saveEditedFileError(e.toString(), fileId));
    }
  }

  void onSubmitButtonClicked(String requestId) async {
    emit(const OrderState.submitEditsLoading());
    if ((nationalID != null || passportFiles != null) &&
        (nationalIdAttachments == null && passportAttachments == null)) {
      final attachmentsRes = await _carRepository.uploadCustomerAttachments(
        requestId: requestId,
        customerId: _authRepository.customer.customerId,
        userToken: _authRepository.customer.token,
        nationalIdFile: nationalID,
        passportFile: passportFiles,
      );
      attachmentsRes.fold(
        (errMsg) => emit(OrderState.submitEditsError(errMsg)),
        (attachments) async {
          try {
            _authRepository.customer.attachments = attachments;
            final res = await _carRepository.sendPendingRequest(requestId);
            res.fold(
              (errMsg) => emit(OrderState.submitEditsError(errMsg)),
              (_) {
                emit(const OrderState.submitEditsSuccess());
              },
            );
          } catch (e) {
            emit(OrderState.submitEditsError(e.toString()));
          }
        },
      );
    } else {
      try {
        final res = await _carRepository.sendPendingRequest(requestId);
        res.fold(
          (errMsg) => emit(OrderState.submitEditsError(errMsg)),
          (_) {
            emit(const OrderState.submitEditsSuccess());
          },
        );
      } catch (e) {
        emit(OrderState.submitEditsError(e.toString()));
      }
    }
  }

  void pickNationalIdFile() {
    emit(OrderState.selectNationalIdFile(
        nationalIdAttachments?.fileStatus ?? (nationalIdInitStatus)));
  }

  void pickPassportFile() {
    emit(OrderState.selectPassportFile(
        passportAttachments?.fileStatus ?? passportInitStatus));
  }

  Future<void> editRequestStatus({
    required String requestId,
    required int requestStatus,
  }) async {
    emit(const OrderState.submitEditStatusLoading());
    try {
      final res = await _carRepository.editRequestStatus(
        requestId: requestId,
        requestStatus: requestStatus,
      );
      res.fold(
        (errMsg) => emit(OrderState.submitEditStatusError(errMsg)),
        (_) {
          emit(OrderState.submitEditStatusSuccess(requestId, requestStatus));
          getAllCustomerRequests();
        },
      );
    } catch (e) {
      emit(OrderState.submitEditStatusError(e.toString()));
    }
  }
}
