class CarBrand {
  String id;
  String brandName;
  String display;
  String path;
  bool isSelected;

  CarBrand({
    required this.id,
    required this.display,
    required this.brandName,
    required this.path,
    this.isSelected = false,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) => CarBrand(
        id: json['_id'] ?? "",
        display: json['display'] ?? "",
        brandName: json['brandName'] ?? "",
        path: json['path'] ?? "",
      );

  @override
  bool operator ==(Object other) =>
      other is CarBrand &&
      id == other.id &&
      display == other.display &&
      brandName == other.brandName &&
      path == other.path;

  @override
  int get hashCode => Object.hash(id, display, brandName, path);
}
