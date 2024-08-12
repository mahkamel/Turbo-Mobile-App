import 'attachment.dart';

class CustomerModel {
  String customerId;
  String customerName;
  String customerEmail;
  String token;
  String customerAddress;
  int customerType;
  List<Attachment> attachments;

  CustomerModel({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.token,
    required this.customerAddress,
    required this.customerType,
    required this.attachments,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json["id"],
      customerName: json['customerDisplayName'] ?? "",
      customerEmail: json['customerEmail'] ?? "",
      token: json['token'] ?? "",
      customerAddress: json['customerId']['customerAddress'] ?? "",
      customerType: json['customerId']['customerType'] ?? 0,
      attachments: (json['customerAttachments'] as List)
          .map(
            (e) => Attachment.fromJson(e),
          )
          .toList(),
    );
  }

  CustomerModel.empty()
      : customerName = '',
        customerId = "",
        customerEmail = "",
        attachments = <Attachment>[],
        customerAddress = '',
        customerType = 0,
        token = '';

  Map<String, dynamic> toJson() => {
        'id': customerId,
        'customerDisplayName': customerName,
        'customerEmail': customerEmail,
        'token': token,
        "customerId": {
          "customerAddress": customerAddress,
          "customerType": customerType,
        },
        'customerAttachments': attachments.map((e) => e.toJson()).toList(),
      };
}
