import 'dart:ui';

import 'package:turbo/models/car_media_model.dart';

class GetCarsByBrandsResponse {
  bool status;
  List<CarData> results;

  GetCarsByBrandsResponse({
    required this.status,
    required this.results,
  });

  factory GetCarsByBrandsResponse.fromJson(Map<String, dynamic> json) =>
      GetCarsByBrandsResponse(
        status: json['status'] as bool,
        results: List<CarData>.from(
          (json['data'] as List).map((data) => CarData.fromJson(data)),
        ),
      );
}

class CarData {
  String carType;
  List<Car> cars;

  CarData({
    required this.carType,
    required this.cars,
  });

  factory CarData.fromJson(Map<String, dynamic> json) => CarData(
        carType: json['carType'] ?? "",
        cars: List<Car>.from(
          (json['cars'] as List).map((carJson) => Car.fromJson(carJson)),
        ),
      );
}

class Car {
  String carId;
  String carYear;
  int carDailyPrice;
  Color? color;
  Model model;
  Brand brand;
  MediaDetails media;

  Car({
    required this.carId,
    required this.carYear,
    required this.carDailyPrice,
    this.color,
    required this.model,
    required this.brand,
    required this.media,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        carId: json['_id'] ?? "",
        carYear: json['carYear'] ?? "",
        carDailyPrice: json['carDailyPrice'] ?? 0,
        color: json['color'] == null
            ? null
            : CarColor.fromJson(json['color']).colorHexaDecimalBasedValue,
        model: Model.fromJson(json['model']),
        brand: Brand.fromJson(json['brand']),
        media: MediaDetails.fromJson(json["media"]),
      );
}

class Model {
  String modelName;

  Model({
    required this.modelName,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        modelName: json['modelName'] ?? "",
      );
}

class Brand {
  String brandName;
  String brandPath;

  Brand({
    required this.brandName,
    required this.brandPath,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        brandName: json['brandName'] ?? "",
        brandPath: json['path'] ?? "",
      );
}

class CarColor {
  Color? colorHexaDecimalBasedValue;

  CarColor({this.colorHexaDecimalBasedValue});

  factory CarColor.fromJson(Map<String, dynamic> json) => CarColor(
        colorHexaDecimalBasedValue: json['Color_HexaDecimalBasedValue'] != null
            ? hexToColor(json['Color_HexaDecimalBasedValue'])
            : const Color(0xffffffff),
      );
}

Color hexToColor(String hexCode) {
  hexCode = hexCode.replaceAll('#', '');
  int colorValue = int.parse(hexCode, radix: 16);
  return Color(colorValue);
}
