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
  final num carDailyPrice;
  final num carWeaklyPrice;
  final num carMothlyPrice;
  final num carLimitedKiloMeters;

  const CarColor({
    required this.color,
    required this.carId,
    required this.carDailyPrice,
    required this.carWeaklyPrice,
    required this.carMothlyPrice,
    required this.carLimitedKiloMeters,
  });

  factory CarColor.fromJson(Map<String, dynamic> json) => CarColor(
        color: json['color'] != null
            ? hexToColor(json['color'])
            : const Color(0xffffffff),
        carId: json['carId'],
        carDailyPrice: json['carDailyPrice'],
        carMothlyPrice: json['carMothlyPrice'],
        carWeaklyPrice: json['carWeaklyPrice'],
        carLimitedKiloMeters: json['carLimitedKiloMeters'],
      );
}

Color hexToColor(String colorString) {
  if (colorString.startsWith('#')) {
    // Handle hex format #RRGGBB or #AARRGGBB
    assert(colorString.length == 7 || colorString.length == 9,
        'Color hex string must be 7 or 9 characters long including "#".');

    final int value = int.parse(colorString.substring(1), radix: 16);
    if (colorString.length == 9) {
      return Color(value);
    } else {
      return Color(value | 0xFF000000);
    }
  } else if (colorString.startsWith('rgba(') && colorString.endsWith(')')) {
    final parts = colorString
        .substring(5, colorString.length - 1)
        .split(',')
        .map((part) => part.trim())
        .toList();

    assert(parts.length == 4, 'RGBA color format must have 4 components.');

    final int r = int.parse(parts[0]);
    final int g = int.parse(parts[1]);
    final int b = int.parse(parts[2]);
    final double opacity = double.parse(parts[3]);

    assert(r >= 0 && r <= 255 && g >= 0 && g <= 255 && b >= 0 && b <= 255,
        'RGB values must be between 0 and 255.');
    assert(opacity >= 0.0 && opacity <= 1.0,
        'Alpha value must be between 0.0 and 1.0.');

    return Color.fromRGBO(r, g, b, opacity);
  } else {
    throw FormatException('Unsupported color format.');
  }
}
