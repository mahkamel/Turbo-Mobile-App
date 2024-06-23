import 'package:turbo/models/car_brand_model.dart';

class GetCarsByBrandsResponse {
  bool status;
  Cars cars;

  GetCarsByBrandsResponse({
    required this.status,
    required this.cars,
  });

  factory GetCarsByBrandsResponse.fromJson(Map<String, dynamic> json) =>
      GetCarsByBrandsResponse(
        status: json['status'] as bool,
        cars: Cars.fromJson(json['cars'] as Map<String, dynamic>),
      );
}

class Cars {
  Map<String, List<Car>> carTypes;

  Cars({
    required this.carTypes,
  });

  factory Cars.fromJson(Map<String, dynamic> json) {
    try {
      return Cars(
        carTypes: json.map<String, List<Car>>((key, value) {
          return MapEntry(
            key,
            (value as List).map((item) => Car.fromJson(item)).toList(),
          );
        }),
      );
    } catch (e) {
      return Cars(
        carTypes: <String, List<Car>>{},
      );
    }
  }
}

class Car {
  String carName;
  List<CarBrand> carBrand;
  List<Color> carColor;
  String carType;
  String carYear;
  int carDailyPrice;
  String carId;
  String carImg;

  Car({
    required this.carName,
    required this.carBrand,
    required this.carColor,
    required this.carType,
    required this.carYear,
    required this.carDailyPrice,
    required this.carId,
    required this.carImg,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carName: json['carName'] ?? "",
      carBrand: List<CarBrand>.from((json['carBrand'] as List)
          .map((brandJson) => CarBrand.fromJson(brandJson))
          .toList()),
      carColor: List<Color>.from((json['carColor'] as List)
          .map((colorJson) => Color.fromJson(colorJson))
          .toList()),
      carType: json['carType'] ?? "",
      carYear: json['carYear'] ?? "",
      carId: json['id'] ?? "",
      carDailyPrice: json['carDailyPrice'] ?? 0,
      carImg:
          "https://images.unsplash.com/photo-1489824904134-891ab64532f1?q=80&w=2531&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    );
  }
}

class Color {
  String id;
  bool colorIsActive;
  String colorName;
  String colorSixLettersIdentifier;
  String? colorHexaDecimalBasedValue;
  String? colorSecondHexaDecimalBasedValue;
  String? colorThirdHexaDecimalBasedValue;
  String? colorDescription;
  int colorCode;

  Color({
    required this.id,
    required this.colorIsActive,
    required this.colorName,
    required this.colorSixLettersIdentifier,
    this.colorHexaDecimalBasedValue,
    this.colorSecondHexaDecimalBasedValue,
    this.colorThirdHexaDecimalBasedValue,
    this.colorDescription,
    required this.colorCode,
  });

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      id: json['_id'] ?? "",
      colorIsActive: json['Color_IsActive'] ?? false,
      colorName: json['Color_Name'] ?? "",
      colorSixLettersIdentifier: json['Color_SixLettersIdentifier'] ?? "",
      colorHexaDecimalBasedValue: json['Color_HexaDecimalBasedValue'] ?? "",
      colorSecondHexaDecimalBasedValue:
          json['Color_SecondHexaDecimalBasedValue'] ?? "",
      colorThirdHexaDecimalBasedValue:
          json['Color_ThirdHexaDecimalBasedValue'] ?? "",
      colorDescription: json['Color_Description'] ?? "",
      colorCode: json['Color_Code'] ?? 0,
    );
  }
}
