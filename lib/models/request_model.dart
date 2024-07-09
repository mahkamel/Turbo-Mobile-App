class RequestModel {
  late bool requestDriver;
  late int requestStatus;
  late num requestPrice;
  late String id;
  late List<RequestCarId> requestCarId;
  late String requestLocation;
  late RequestBranch requestBranch;
  late String requestPeriod;
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
    this.requestCity,
    required this.requestPrice,
    required this.requestSysDate,
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
    print("---------requestDriver---------");
    requestDriver = json['requestDriver'] ?? false;
    print("--------requestStatus----------");
    requestStatus = json['requestStatus'] ?? 0;
    requestPrice = json['requestPrice'] ?? 0;
    print("-------_id ${json['_id']}-----------");
    id = json['_id'] ?? "";
    print("---------requestCarId---------");
    print("---------${json['requestCarId']}---------");
    requestCarId = (json['requestCarId'] as List)
        .map((dynamic item) =>
            RequestCarId.fromJson(item as Map<String, dynamic>))
        .toList();
    print("-----------requestLocation-------");
    requestLocation = json['requestLocation'] ?? "";
    print("----------requestBranch--------");
    requestBranch = json.containsKey("requestBranch")
        ? RequestBranch.fromJson(json['requestBranch'] as Map<String, dynamic>)
        : RequestBranch(
            id: "",
            branchName: "",
          );
    print("-------requestPeriod-----------");
    requestPeriod = json['requestPeriod'] ?? "";
    print("---------requestFrom---------");
    requestFrom = DateTime.parse(
      json['requestFrom'] ?? "",
    );
    print("---------requestTo---------");
    requestTo = DateTime.parse(
      json['requestTo'] ?? "",
    );
    print("----------requestCity--------");
    requestCity = json['requestCity'] == null
        ? null
        : RequestCity.fromJson(json['requestCity'] as Map<String, dynamic>);
    print("---------requestSysDate---------");
    requestSysDate = DateTime.parse(
      json['requestSysDate'] ?? "",
    );
  }
}

class RequestCarId {
  final RequestCar carId;

  RequestCarId({required this.carId});

  factory RequestCarId.fromJson(Map<String, dynamic> json) {print("******* ${json}");
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

  RequestCar({
    required this.id,
    required this.carName,
    this.dailyPrice = 0,
    this.weeklyPrice = 0,
    this.monthlyPrice = 0,
  });

  factory RequestCar.fromJson(Map<String, dynamic> json) {
    return RequestCar(
      id: json['_id'] ?? "",
      carName: json['carName'] ?? "",
      dailyPrice: json['carDailyPrice'] ?? 0.0,
      weeklyPrice: json['carWeaklyPrice'] ?? 0.0,
      monthlyPrice: json['carMothlyPrice'] ?? 0.0,
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
