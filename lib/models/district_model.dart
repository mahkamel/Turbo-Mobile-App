class District {
  bool districtIsActive;
  String id;
  String districtName;
  String districtCityId;

  District({
    required this.districtIsActive,
    required this.id,
    required this.districtName,
    required this.districtCityId,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        districtIsActive: json['districtIsActive'] ?? false,
        id: json['_id'] ?? "",
        districtName: json['districtName'] ?? "",
        districtCityId: json['districtCityId'] ?? "",
      );
}
