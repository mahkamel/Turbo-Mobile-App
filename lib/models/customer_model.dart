import 'attachment.dart';

class CustomerModel {
  String customerId;
  String customerName;
  String customerEmail;
  String token;
  String customerAddress;
  int customerType;
  String customerTelephone;
  String customerNationalId;
  List<Attachment> attachments;
  String? customerImageProfilePath;

  CustomerModel({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.token,
    required this.customerAddress,
    required this.customerType,
    required this.attachments,
    required this.customerTelephone,
    required this.customerNationalId,
    this.customerImageProfilePath,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json["id"],
      customerName: json['customerDisplayName'] ?? "",
      customerEmail: json['customerEmail'] ?? "",
      token: json['token'] ?? "",
      customerAddress: json['customerId']['customerAddress'] ?? "",
      customerType: json['customerId']['customerType'] ?? 0,
      customerTelephone: json['customerId']['customerTelephone'] ?? "",
      customerNationalId: json['customerId']['customerNationalId'] ?? "",
      customerImageProfilePath: json['customerId']['customerImageProfilePath'] ?? "",
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
        customerTelephone = '',
        customerNationalId = '',
        customerImageProfilePath = '',
        token = '';

  Map<String, dynamic> toJson() => {
        'id': customerId,
        'customerDisplayName': customerName,
        'customerEmail': customerEmail,
        'token': token,
        "customerId": {
          "customerAddress": customerAddress,
          "customerType": customerType,
          'customerTelephone': customerTelephone,
          'customerNationalId': customerNationalId,
          'customerImageProfilePath' : customerImageProfilePath,
        },
        'customerAttachments': attachments.map((e) => e.toJson()).toList(),
      };
}
