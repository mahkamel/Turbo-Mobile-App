class CarBrand {
  final String id;
  final String brandName;
  final String brandDescription;
  final bool isActive;
  final DateTime sysDate;

  CarBrand({
    required this.id,
    required this.brandName,
    required this.brandDescription,
    required this.isActive,
    required this.sysDate,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) => CarBrand(
        id: json['_id'] ?? ""   ,
        brandName: json['brandName'] ?? "",
        brandDescription: json['brandDescription'] ?? "" ,
        isActive: json['brandIsActive'] as bool,
        sysDate: DateTime.parse(json['brandSysDate'] as String),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'brandName': brandName,
        'brandDescription': brandDescription,
        'brandIsActive': isActive,
        'brandSysDate': sysDate.toIso8601String(),
      };
}
