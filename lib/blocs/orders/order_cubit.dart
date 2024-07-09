import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:turbo/core/services/networking/repositories/auth_repository.dart';
import 'package:turbo/models/request_model.dart';

import '../../core/helpers/constants.dart';
import '../../core/helpers/functions.dart';
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
  double dailyPrice = 0;
  double weeklyPrice = 0;
  double monthlyPrice = 0;

  List<File>? nationalID;
  Attachment? nationalIdAttachments;
  String nationalIdOldPaths = "";

  List<File>? passportFiles;
  Attachment? passportAttachments;
  String passportOldPaths = "";

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
    print("isssss ${deliveryDate != null && pickedDate != null}");
    if (deliveryDate != null && pickedDate != null) {
      final int durationInDays = deliveryDate!.difference(pickedDate!).inDays;
      print("ssssss ${durationInDays} -- $dailyPrice");
      if (durationInDays >= 1 && durationInDays < 7) {
        calculatedPrice = durationInDays * dailyPrice;
      } else if (durationInDays >= 7 && durationInDays < 30) {
        calculatedPrice = durationInDays * weeklyPrice;
      } else {
        calculatedPrice = durationInDays * monthlyPrice;
      }
    }
    if (isWithPrivateDriver) {
      calculatedPrice += AppConstants.driverFees;
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

          passportAttachments = findAttachmentFile(
            type: "passport",
            attachments: status.attachmentsId,
          );
          passportOldPaths = passportAttachments?.filePath ?? "";
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
              ? calculatedPrice
              : null,
          requestPeriod: (pickedDate != null && deliveryDate != null) &&
                  (deliveryDate!.difference(pickedDate!).inDays.toString() !=
                      requestStatus!.requestPeriod)
              ? deliveryDate!.difference(pickedDate!).inDays
              : null,
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
        requestId: requestStatus!.id,
        fileType: fileType,
        attachmentId: fileId,
        oldPathFiles: oldPathFiles,
        newFile: newFile,
      );

      res.fold(
        (errMsg) => emit(OrderState.saveEditedFileError(errMsg, fileId)),
        (newAttachments) {
          for (Attachment attachment in _authRepository.customer.attachments) {
            if (attachment.id == fileId) {
              attachment = newAttachments;
              break;
            }
          }
          for (Attachment attachment in requestStatus!.attachmentsId) {
            if (attachment.id == fileId) {
              attachment = newAttachments;
              break;
            }
          }
        },
      );
      emit(OrderState.saveEditedFileSuccess(fileId));
    } catch (e) {
      emit(OrderState.saveEditedFileError(e.toString(), fileId));
    }
  }

  void onSubmitButtonClicked(String requestId) async {
    emit(const OrderState.submitEditsLoading());
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
