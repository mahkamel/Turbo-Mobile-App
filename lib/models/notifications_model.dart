class UserNotificationModel {
  bool isNotificationRead;
  bool isNotificationSeen;
  String id;
  String notificationMessage;
  String notificationCustomerId;
  String notificationRequestId;
  String notificationType;
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
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) =>
      UserNotificationModel(
        isNotificationRead: json['notificationRead'] ?? false,
        isNotificationSeen: json['notificationSeen'] ?? false,
        id: json['_id'] ?? "",
        notificationMessage: json['notificationMessage'] ?? "",
        notificationCustomerId: json['notificationCustomerId'] ?? "",
        notificationRequestId: json['notificationRequestId'] ?? "",
        notificationType: json['notificationType'] ?? "",
        notificationDate: DateTime.tryParse(
              json['notificationDate'],
            ) ??
            DateTime.now(),
      );
}
