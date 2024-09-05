import 'car_media_model.dart';
import 'get_cars_by_brands.dart';

//requestStatus        ==>>>>>   0 => pending , 4 => customerAction , 1=>  approved , 2=> reject , 3=> refund , 5=> canceled , 6=> delete
class RequestModel {
  late bool requestDriver;
  late int requestStatus;
  late num requestPrice;
  late String id;
  late List<RequestCarId> requestCarId;
  late String requestLocation;
  late RequestBranch requestBranch;
  late String requestPeriod;
  late String requestPaidStatus;
  late String requestCode;
  late DateTime requestFrom;
  late DateTime requestTo;
  late RequestCity? requestCity;
  late DateTime requestSysDate;

  RequestModel({
    required this.requestDriver,
    required this.requestStatus,
    required this.id,
    required this.requestCarId,
    required this.requestLocation,
    required this.requestBranch,
    required this.requestPeriod,
    required this.requestFrom,
    required this.requestTo,
    required this.requestPaidStatus,
    this.requestCity,
    required this.requestPrice,
    required this.requestSysDate,
    required this.requestCode,
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
    requestDriver = json['requestDriver'] ?? false;
    requestStatus = json['requestStatus'] ?? 0;
    requestPrice = json['requestTotalPrice'] ?? 0;
    id = json['_id'] ?? "";
    requestCarId = (json['requestCarId'] as List)
        .map((dynamic item) =>
            RequestCarId.fromJson(item as Map<String, dynamic>))
        .toList();
    requestLocation = json['requestLocation'] ?? "";
    requestPaidStatus = json['requestPaidStatus'] ?? "";
    requestBranch = json.containsKey("requestBranch")
        ? RequestBranch.fromJson(json['requestBranch'] as Map<String, dynamic>)
        : RequestBranch(
            id: "",
            branchName: "",
          );
    requestPeriod = json['requestPeriod'] ?? "";
    requestCode = json['requestCode'].toString();
    requestFrom = DateTime.parse(
      json['requestFrom'] ?? "",
    );
    requestTo = DateTime.parse(
      json['requestTo'] ?? "",
    );

    requestCity = json['requestCity'] == null
        ? null
        : RequestCity.fromJson(json['requestCity'] as Map<String, dynamic>);
    requestSysDate = DateTime.parse(
      json['requestSysDate'] ?? "",
    );
  }
}

class RequestCarId {
  final RequestCar carId;

  RequestCarId({
    required this.carId,
  });

  factory RequestCarId.fromJson(Map<String, dynamic> json) {
    return RequestCarId(
      carId: RequestCar.fromJson(json['carId'] as Map<String, dynamic>),
    );
  }
}

class RequestCar {
  final String id;
  final String carName;
  final num dailyPrice;
  final num monthlyPrice;
  final num weeklyPrice;
  final List<CarMedia> carMedia;
  final Brand carBrand;
  final String carYear;
  final String carModel;

  RequestCar({
    required this.id,
    required this.carName,
    this.dailyPrice = 0,
    this.weeklyPrice = 0,
    this.monthlyPrice = 0,
    required this.carMedia,
    required this.carBrand,
    required this.carYear,
    required this.carModel,
  });

  factory RequestCar.fromJson(Map<String, dynamic> json) {
    return RequestCar(
      id: json['_id'] ?? "",
      carName: json['carName'] ?? "",
      dailyPrice: json['carDailyPrice'] ?? 0.0,
      weeklyPrice: json['carWeaklyPrice'] ?? 0.0,
      monthlyPrice: json['carMothlyPrice'] ?? 0.0,
      carYear: json['carYear'] ?? "",
      carBrand: Brand.fromJson(json['carBrand']),
      carModel: json['carModel']["modelName"] ?? "",
      carMedia: (json['carMedia'] as List)
          .map(
              (dynamic item) => CarMedia.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RequestBranch {
  final String id;
  final String branchName;

  RequestBranch({required this.id, required this.branchName});

  factory RequestBranch.fromJson(Map<String, dynamic> json) => RequestBranch(
        id: json['_id'] as String,
        branchName: json['branchName'] ?? "",
      );
}

class RequestCity {
  final String id;
  final String cityName;

  RequestCity({required this.id, required this.cityName});

  factory RequestCity.fromJson(Map<String, dynamic> json) => RequestCity(
        id: json['_id'] ?? "",
        cityName: json['cityName'] ?? "",
      );
}
