class GetCarsByBrands {
  bool status;
  Cars cars;

  GetCarsByBrands({required this.status, required this.cars});

  factory GetCarsByBrands.fromJson(Map<String, dynamic> json) =>
      GetCarsByBrands(
        status: json['status'] as bool,
        cars: Cars.fromJson(json['cars'] as Map<String, dynamic>),
      );
}

class Cars {
  Map<String, List<Car>> cars;

  Cars({required this.cars});

  factory Cars.fromJson(Map<String, dynamic> json) => Cars(
        cars: json.map((key, value) => MapEntry(
              key,
              (value as List).map((carJson) => Car.fromJson(carJson)).toList(),
            )),
      );
}

class Car {
  String id; // Use a more descriptive name like '_id'
  bool carIsFeatured;
  bool carIsActive;
  String carName;
  String carBrand;
  String carType;
  String carCategory;
  String carYear;
  String carEngine;
  String carPlateNumber;
  String carChassis;
  String carModel;
  String carColor;
  int? carPassengerNo; // Make nullable to handle null values
  int carDailyPrice;
  int carLimitedKiloMeters;
  int carMothlyPrice;
  int carWeaklyPrice;
  DateTime carSysDate;

  Car({
    required this.id,
    required this.carIsFeatured,
    required this.carIsActive,
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
    this.carPassengerNo,
    required this.carDailyPrice,
    required this.carLimitedKiloMeters,
    required this.carMothlyPrice,
    required this.carWeaklyPrice,
    required this.carSysDate,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json['_id'] as String,
        carIsFeatured: json['carIsFeatured'] as bool,
        carIsActive: json['carIsActive'] as bool,
        carName: json['carName'] as String,
        carBrand: json['carBrand'] as String,
        carType: json['carType'] as String,
        carCategory: json['carCategory'] as String,
        carYear: json['carYear'] as String,
        carEngine: json['carEngine'] as String,
        carPlateNumber: json['carPlateNumber'] as String,
        carChassis: json['carChassis'] as String,
        carModel: json['carModel'] as String,
        carColor: json['carColor'] as String,
        carPassengerNo: json['carPassengerNo'] as int?,
        carDailyPrice: json['carDailyPrice'] as int,
        carLimitedKiloMeters: json['carLimitedKiloMeters'] as int,
        carMothlyPrice: json['carMothlyPrice'] as int,
        carWeaklyPrice: json['carWeaklyPrice'] as int,
        carSysDate: DateTime.parse(json['carSysDate'] as String),
      );
}
