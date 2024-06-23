class CarBrand {
  String id;
  String brandName;
  String display;
  String path;

  CarBrand({
    required this.id,
    required this.display,
    required this.brandName,
    required this.path,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) => CarBrand(
        id: json['_id'] ?? "",
        display: json['display'] ?? false,
        brandName: json['brandName'] ?? "",
        path: json['path'] ?? "",
      );
}
