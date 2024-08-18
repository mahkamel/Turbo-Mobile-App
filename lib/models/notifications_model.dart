class UserNotificationModel {
  bool isNotificationRead;
  bool isNotificationSeen;
  String id;
  String notificationMessage;
  String notificationCustomerId;
  String notificationRequestId;
  String notificationType;
  String requestCode;
  String notificationUnitNumber;
  String notificationCustomerName;
  DateTime notificationDate;

  UserNotificationModel({
    required this.isNotificationRead,
    required this.isNotificationSeen,
    required this.id,
    required this.notificationMessage,
    required this.notificationCustomerId,
    required this.notificationRequestId,
    required this.notificationType,
    required this.notificationDate,
    required this.notificationCustomerName,
    required this.notificationUnitNumber,
    required this.requestCode,
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) =>
      UserNotificationModel(
        isNotificationRead: json['notificationRead'] ?? false,
        isNotificationSeen: json['notificationSeen'] ?? false,
        id: json['_id'] ?? "",
        requestCode: json['notificationRequestId']['requestCode'].toString(),
        notificationMessage: json['notificationMessage'] ?? "",
        notificationCustomerId: json['notificationCustomerId'] ?? "",
        notificationRequestId: json['notificationRequestId']['_id'].toString(),
        notificationType: json['notificationType'] ?? "",
        notificationCustomerName: json['notificationCustomerName'] ?? "",
        notificationUnitNumber: json['notificationUnitNumber'] ?? "",
        notificationDate: DateTime.tryParse(
              json['notificationDate'],
            ) ??
            DateTime.now(),
      );
}
