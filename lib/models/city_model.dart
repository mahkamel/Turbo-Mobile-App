class City {
  final String id;
  final String cityName;
  final List<Branch> branches;

  City({required this.id, required this.cityName, this.branches = const []});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'] ?? "",
      cityName: json['cityName'] ?? "",
      branches: (json['cityBranchesId'] as List)
          .map((branchJson) => Branch.fromJson(branchJson))
          .toList(),
    );
  }
}

class Branch {
  final String id;
  final String branchName;

  Branch({required this.id, required this.branchName});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'] as String,
      branchName: json['branchName'] as String,
    );
  }
}
