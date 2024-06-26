class City {
  bool cityIsActive;
  String id;
  String cityName;
  String cityGovId;
  int cityCode;

  City({
    required this.cityIsActive,
    required this.id,
    required this.cityName,
    required this.cityGovId,
    required this.cityCode,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        cityIsActive: json['cityIsActive'] ?? false,
        id: json['_id'] ?? "",
        cityName: json['cityName'] ?? "",
        cityGovId: json['cityGovId'] ?? "",
        cityCode: json['cityCode'] ?? 0,
      );
}
