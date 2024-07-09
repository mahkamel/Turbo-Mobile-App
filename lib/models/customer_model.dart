import 'attachment.dart';

class CustomerModel {
  String customerId;
  String customerName;
  String customerEmail;
  String token;
  List<Attachment> attachments;

  CustomerModel({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.token,
    required this.attachments,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json["id"],
      customerName: json['customerDisplayName'] ?? "",
      customerEmail: json['customerEmail'] ?? "",
      token: json['token'] ?? "",
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
        token = '';

  Map<String, dynamic> toJson() => {
        'id': customerId,
        'customerDisplayName': customerName,
        'customerEmail': customerEmail,
        'token': token,
        'customerAttachments': attachments.map((e) => e.toJson()).toList(),
      };
}
