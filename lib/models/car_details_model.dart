import 'dart:ui';

import 'car_brand_model.dart';
import 'car_media_model.dart';

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
  final String carPlateNumber;
  final String carChassis;
  final String carModel;
  final List<CarColor> carColor;
  final num carPassengerNo;
  final num carDailyPrice;
  final num carLimitedKiloMeters;
  final num carMothlyPrice;
  final num carWeaklyPrice;
  final String carSysDate;
  List<CarMedia> carMedia;

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
    required this.carPlateNumber,
    required this.carChassis,
    required this.carModel,
    required this.carColor,
    required this.carPassengerNo,
    required this.carDailyPrice,
    required this.carLimitedKiloMeters,
    required this.carMothlyPrice,
    required this.carWeaklyPrice,
    required this.carSysDate,
    required this.carMedia,
  });

  factory CarDetailsData.fromJson(Map<String, dynamic> json) {
    List<CarMedia> mediaList = [];
    List<CarColor> colorList = [];
    if (json['carMedia'] != null) {
      for (var mediaItem in json['carMedia']) {
        mediaList.add(CarMedia.fromJson(mediaItem as Map<String, dynamic>));
      }
    }

    if (json['carColor'] != null) {
      for (var carColorItem in json['carColor']) {
        colorList.add(CarColor.fromJson(carColorItem as Map<String, dynamic>));
      }
    }
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
      carPlateNumber: json['carPlateNumber'] ?? "",
      carChassis: json['carChassis'] ?? "",
      carModel: json.containsKey("carModel") && json['carModel'] != null
          ? json['carModel']["modelName"] ?? ""
          : "",
      carColor: colorList,
      carPassengerNo: json['carPassengerNo'] ?? 0,
      carDailyPrice: (json['carDailyPrice'] ?? 0.0),
      carLimitedKiloMeters: json['carLimitedKiloMeters'] ?? 0,
      carMothlyPrice: (json['carMothlyPrice'] ?? 0.0),
      carWeaklyPrice: (json['carWeaklyPrice'] ?? 0.0),
      carSysDate: json['carSysDate'] ?? "",
      carMedia: mediaList,
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
        carPlateNumber: "",
        carChassis: "",
        carModel: "",
        carColor: [],
        carPassengerNo: 0,
        carDailyPrice: 0.0,
        carLimitedKiloMeters: 0,
        carMothlyPrice: 0.0,
        carWeaklyPrice: 0.0,
        carSysDate: "",
        carMedia: [],
      );
}

class CarColor {
  final Color color;
  final String carId;

  const CarColor({required this.color, required this.carId});

  factory CarColor.fromJson(Map<String, dynamic> json) => CarColor(
        color: json['color'] != null
            ? hexToColor(json['color'])
            : const Color(0xffffffff),
        carId: json['carId'],
      );
}

Color hexToColor(String hex) {
  assert(hex.length == 7 || hex.length == 9,
      'Color hex string must be 7 or 9 characters long including "#".');

  final int value = int.parse(hex.substring(1), radix: 16);
  if (hex.length == 9) {
    return Color(value);
  } else {
    return Color(value | 0xFF000000);
  }
}
