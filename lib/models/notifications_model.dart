class UserNotificationModel {
  final bool notificationRead;
  final String id;
  final String notificationMessage;
  final String notificationCustomerId;
  final String notificationRequestId;
  final String notificationType;
  final DateTime notificationDate;

  UserNotificationModel({
    required this.notificationRead,
    required this.id,
    required this.notificationMessage,
    required this.notificationCustomerId,
    required this.notificationRequestId,
    required this.notificationType,
    required this.notificationDate,
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) =>
      UserNotificationModel(
        notificationRead: json['notificationRead'] ?? false,
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
