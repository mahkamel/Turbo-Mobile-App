class CustomerModel {
  String customerName;
  String customerEmail;
  String customerAddress;
  String phoneNumber;
  int customerType;
  String token;

  CustomerModel({
    required this.customerName,
    required this.customerEmail,
    required this.customerAddress,
    required this.phoneNumber,
    required this.token,
    required this.customerType,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerName: json['customerName'] ?? "",
      customerEmail: json['customerEmail'] ?? "",
      customerAddress: json['customerAddress'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      token: json['token'] ?? "",
      customerType: json['customerType'] ?? 0,
    );
  }

  CustomerModel.empty()
      : customerName = '',
        customerEmail = "",
        customerType = 3,
        customerAddress = "",
        phoneNumber = "",
        token = '';

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerType': customerType,
      'customerAddress': customerAddress,
      'phoneNumber': phoneNumber,
      'token': token,
    };
  }
}
