class Attachment {
   String filePath;
   int fileStatus;
   bool fileIsActive;
   String id;
   String fileType;
   DateTime fileSysDate;
   String? fileRejectComment;

  Attachment({
    required this.filePath,
    required this.fileStatus,
    required this.fileIsActive,
    required this.id,
    required this.fileType,
    required this.fileSysDate,
    required this.fileRejectComment,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        filePath: json['filePath'] ?? "",
        fileStatus: json['fileStatus'] ?? 0,
        fileIsActive: json['fileIsActive'] ?? "",
        id: json['_id'] ?? "",
        fileType: json['fileType'] ?? "",
        fileSysDate: DateTime.parse(json['fileSysDate'] ?? ""),
        fileRejectComment: json['fileRejectComment'] ?? "",
      );

   Map<String, dynamic> toJson() => {
     'filePath': filePath,
     'fileStatus': fileStatus,
     'fileIsActive': fileIsActive,
     '_id': id,
     'fileType': fileType,
     'fileSysDate': fileSysDate.toIso8601String(),
     'fileRejectComment': fileRejectComment,
   };
}
