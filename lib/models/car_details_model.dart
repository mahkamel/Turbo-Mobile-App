import '../core/helpers/constants.dart';
import 'car_brand_model.dart';

class CarDetailsModel {
  final bool status;
  final CarDetailsData data;

  CarDetailsModel({required this.status, required this.data});

  factory CarDetailsModel.fromJson(Map<String, dynamic> json) {
    return CarDetailsModel(
      status: json['status'] as bool,
      data: CarDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class CarDetailsData {
  final bool carIsFeatured;
  final bool carIsActive;
  final String id;
  final String carName;
  final CarBrand carBrand;
  final String carType;
  final String carCategory;
  final String carYear;
  final String carEngine;
  // final String carPlateNumber;
  final String carChassis;
  final String carModel;
  final String carColor;
  final num carPassengerNo;
  final num carDailyPrice;
  final num carLimitedKiloMeters;
  final num carMothlyPrice;
  final num carWeaklyPrice;
  final String carSysDate;

  CarDetailsData({
    required this.carIsFeatured,
    required this.carIsActive,
    required this.id,
    required this.carName,
    required this.carBrand,
    required this.carType,
    required this.carCategory,
    required this.carYear,
    required this.carEngine,
    // required this.carPlateNumber,
    required this.carChassis,
    required this.carModel,
    required this.carColor,
    required this.carPassengerNo,
    required this.carDailyPrice,
    required this.carLimitedKiloMeters,
    required this.carMothlyPrice,
    required this.carWeaklyPrice,
    required this.carSysDate,
  });

  factory CarDetailsData.fromJson(Map<String, dynamic> json) {
    return CarDetailsData(
      carIsFeatured: json['carIsFeatured'] ?? false,
      carIsActive: json['carIsActive'] ?? false,
      id: json['_id'] ?? "",
      carName: json['carName'] ?? "",
      carBrand: CarBrand.fromJson(json['carBrand'] as Map<String, dynamic>),
      carType: json['carType']["typeName"] ?? "",
      carCategory: json['carCategory']["categoryName"] ?? "",
      carYear: json['carYear'] ?? "",
      carEngine: json['carEngine'] ?? "",
      // carPlateNumber: json['carPlateNumber'] ?? "",
      carChassis: json['carChassis'] ?? "",
      carModel: json.containsKey("carModel") && json['carModel'] != null
          ? json['carModel']["modelName"] ?? ""
          : "",
      carColor: json['carColor']["Color_Name"] ?? "",
      carPassengerNo: json['carPassengerNo'] ?? 0,
      carDailyPrice: ((json['carDailyPrice'] ?? 0.0) +
          ((json['carDailyPrice'] ?? 0.0) * (AppConstants.vat / 100))),
      carLimitedKiloMeters: json['carLimitedKiloMeters'] ?? 0,
      carMothlyPrice:((json['carMothlyPrice'] ?? 0.0) +
          ((json['carMothlyPrice'] ?? 0.0) * (AppConstants.vat / 100))),

      carWeaklyPrice:
      ((json['carWeaklyPrice'] ?? 0.0) +
          ((json['carWeaklyPrice'] ?? 0.0) * (AppConstants.vat / 100))),

      carSysDate: json['carSysDate'] ?? "",
    );
  }
  factory CarDetailsData.empty() => CarDetailsData(
        carIsFeatured: false,
        carIsActive: false,
        id: "",
        carName: "",
        carBrand: CarBrand(
          display: "",
          brandName: "",
          id: "",
          path: "",
        ),
        carType: "",
        carCategory: "",
        carYear: "",
        carEngine: "",
        // carPlateNumber: "",
        carChassis: "",
        carModel: "",
        carColor: "",
        carPassengerNo: 0,
        carDailyPrice: 0.0,
        carLimitedKiloMeters: 0,
        carMothlyPrice: 0.0,
        carWeaklyPrice: 0.0,
        carSysDate: "",
      );
}
