class CarType {
  String id;
  String typeName;
  bool isSelected;

  CarType({
    required this.id,
    required this.typeName,
    this.isSelected = false,
  });

  factory CarType.fromJson(Map<String, dynamic> json) {
    return CarType(
      id: json['_id'] ?? "",
      typeName: json['typeName'] ?? "",
    );
  }
}
