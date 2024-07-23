class CarCategory {
  final bool categoryIsActive;
  final String id;
  final String categoryName;
  final String categoryDescription;
  final String categorySysDate;
  bool isSelected;

  CarCategory({
    this.isSelected = false,
    required this.categoryIsActive, 
    required this.id, 
    required this.categoryName, 
    required this.categoryDescription, required this.categorySysDate
  });

  factory CarCategory.fromJson(Map<String, dynamic> json) {
    return CarCategory(
      categoryIsActive: json['categoryIsActive'],
      id: json['_id'],
      categoryName: json['categoryName'],
      categoryDescription: json['categoryDescription'],
      categorySysDate: json['categorySysDate']
    );
  }
}