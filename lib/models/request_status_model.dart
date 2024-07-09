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
  DateTime requestSysDate;
  int requestCode;
  String requestRejectComment;
  String requestRejectedByUser;
  DateTime? requestRejectedDate;

  RequestStatusModel({
    required this.requestDriver,
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
    required this.requestRejectedByUser,
    this.requestRejectedDate,
  });
  factory RequestStatusModel.fromJson(Map<String, dynamic> json) {
    // Parse individual fields from the JSON
    return RequestStatusModel(
      requestDriver: json['requestDriver'] as bool,
      requestStatus: json['requestStatus'] as int,
      id: json['_id'] ?? "", // Handle potential missing id field
      attachmentsId: [], // Assuming attachmentsId needs separate parsing
      requestCarId: (json['requestCarId'] as List)
          .map((carJson) => RequestStatusCar.fromJson(carJson))
          .toList(),
      requestLocation: json['requestLocation'] as String,
      requestBranch:
          RequestBranch.fromJson(json['requestBranch'] as Map<String, dynamic>),
      requestPeriod: json['requestPeriod'] as String,
      requestFrom:
          DateTime.parse(json['requestFrom'] as String), // Assuming date format
      requestTo:
          DateTime.parse(json['requestTo'] as String), // Assuming date format
      requestCity:
          RequestCity.fromJson(json['requestCity'] as Map<String, dynamic>),
      requestPrice: json['requestPrice'] as num,
      customerId: json['customerId'] as String,
      requestSysDate: DateTime.parse(
          json['requestSysDate'] as String), // Assuming date format
      requestCode: json['requestCode'] as int,
      requestRejectComment: json.containsKey("requestRejectComment")
          ? json['requestRejectComment'] ?? ""
          : "", // Handle potential missing field
      requestRejectedByUser:
          json['requestRejectedByUser'] ?? "", // Handle potential missing field
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
    print("******* ${json}");
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
