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
          (json['result'] as List).map((data) => CarData.fromJson(data)),
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
  String carImg;
  int carDailyPrice;
  Color? color;
  Model model;
  Brand brand;

  Car({
    required this.carId,
    required this.carYear,
    required this.carDailyPrice,
    this.color,
    required this.carImg,
    required this.model,
    required this.brand,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        carId: json['_id'] ?? "",
        carYear: json['carYear'] ?? "",
        carImg:
            "https://www.telegraph.co.uk/content/dam/cars/2022/10/06/TELEMMGLPICT000303818851_trans_NvBQzQNjv4Bqt5zbar6XbM4pjVdFDGnuCuvLaAydVN2IieZzbeiTTKw.jpeg?imwidth=960",
        carDailyPrice: json['carDailyPrice'] ?? 0,
        color: json['color'] == null ? null : Color.fromJson(json['color']),
        model: Model.fromJson(json['model']),
        brand: Brand.fromJson(json['brand']),
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

class Color {
  String? colorHexaDecimalBasedValue; // Make color value nullable

  Color({this.colorHexaDecimalBasedValue});

  factory Color.fromJson(Map<String, dynamic> json) => Color(
        colorHexaDecimalBasedValue:
            json['Color_HexaDecimalBasedValue'] ?? "0xffffff",
      );
}
