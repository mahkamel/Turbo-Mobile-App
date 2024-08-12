import 'package:turbo/models/request_model.dart';

import 'attachment.dart';

class RequestStatusModel {
  bool requestDriver;
  int requestStatus;
  String id;
  List<Attachment> attachmentsId;
  List<RequestStatusCar> requestCarId;
  String requestLocation;
  RequestBranch requestBranch;
  String requestPeriod;
  DateTime requestFrom;
  DateTime requestTo;
  RequestCity requestCity;
  num requestPrice;
  String customerId;
  String requestPaidStatus;
  DateTime requestSysDate;
  String requestCode;
  String requestRejectComment;
  DateTime? requestRejectedDate;

  RequestStatusModel({
    required this.requestDriver,
    required this.requestPaidStatus,
    required this.requestStatus,
    required this.id,
    required this.attachmentsId,
    required this.requestCarId,
    required this.requestLocation,
    required this.requestBranch,
    required this.requestPeriod,
    required this.requestFrom,
    required this.requestTo,
    required this.requestCity,
    required this.requestPrice,
    required this.customerId,
    required this.requestSysDate,
    required this.requestCode,
    required this.requestRejectComment,
    this.requestRejectedDate,
  });
  factory RequestStatusModel.fromJson(Map<String, dynamic> json) {
    return RequestStatusModel(
      requestDriver: json['requestDriver'] ?? false,
      requestStatus: json['requestStatus'] ?? 0,
      id: json['_id'] ?? "",
      attachmentsId: (json['attachmentsId'] as List)
          .map(
            (e) => Attachment.fromJson(e),
          )
          .toList(),
      requestCarId: (json['requestCarId'] as List)
          .map((carJson) => RequestStatusCar.fromJson(carJson))
          .toList(),
      requestLocation: json['requestLocation'] ?? "",
      requestPaidStatus: json['requestPaidStatus'] ?? "pending",
      requestBranch:
          RequestBranch.fromJson(json['requestBranch'] as Map<String, dynamic>),
      requestPeriod: json['requestPeriod'] ?? "0",
      requestFrom: DateTime.parse(json['requestFrom'] as String),
      requestTo: DateTime.parse(json['requestTo'] as String),
      requestCity:
          RequestCity.fromJson(json['requestCity'] as Map<String, dynamic>),
      requestPrice: json['requestTotalPrice'] ?? 0.0,
      customerId: json['customerId'] ?? "",
      requestSysDate: DateTime.parse(json['requestSysDate'] as String),
      requestCode: json['requestCode'].toString(),
      requestRejectComment: json.containsKey("requestRejectComment")
          ? json['requestRejectComment'] ?? ""
          : "",
      requestRejectedDate: json.containsKey("requestRejectedDate") &&
              json['requestRejectedDate'] != null
          ? DateTime.parse(json['requestRejectedDate'] as String)
          : null, // Handle potential missing field
    );
  }
}

class RequestCarId {
  final RequestStatusCar carId;

  RequestCarId({required this.carId});

  factory RequestCarId.fromJson(Map<String, dynamic> json) {
    return RequestCarId(
      carId: RequestStatusCar.fromJson(json['carId'] as Map<String, dynamic>),
    );
  }
}

class RequestStatusCar {
  final String id;
  final String carName;
  final num dailyPrice;
  final num monthlyPrice;
  final num weeklyPrice;

  RequestStatusCar({
    required this.id,
    required this.carName,
    this.dailyPrice = 0,
    this.weeklyPrice = 0,
    this.monthlyPrice = 0,
  });

  factory RequestStatusCar.fromJson(Map<String, dynamic> json) {
    return RequestStatusCar(
      id: json['_id'] ?? "",
      carName: json['carId']['carName'] ?? "",
      dailyPrice: json['carId']['carDailyPrice'] ?? 0.0,
      weeklyPrice: json['carId']['carWeaklyPrice'] ?? 0.0,
      monthlyPrice: json['carId']['carMothlyPrice'] ?? 0.0,
    );
  }
}
