class CarMedia {
  final bool isFeatured;
  final String id;
  final MediaDetails mediaId;

  CarMedia({
    required this.isFeatured,
    required this.id,
    required this.mediaId,
  });

  factory CarMedia.fromJson(Map<String, dynamic> json) {
    return CarMedia(
      isFeatured: json['isFeatured'] ?? false,
      id: json['_id'] ?? "",
      mediaId: MediaDetails.fromJson(json['mediaId'] as Map<String, dynamic>),
    );
  }
}

class MediaDetails {
  final bool mediaIsActive;
  final String mediaType;
  final String mediaTitle;
  final String? mediaAlternativeText;
  final String? mediaDescribtion;
  final String mediaXLargImageUrl;
  final String mediaLargImageUrl;
  final String mediaMediumImageUrl;
  final String mediaSamllImageUrl;

  MediaDetails({
    required this.mediaIsActive,
    required this.mediaType,
    required this.mediaTitle,
    this.mediaAlternativeText,
    this.mediaDescribtion,
    required this.mediaXLargImageUrl,
    required this.mediaLargImageUrl,
    required this.mediaMediumImageUrl,
    required this.mediaSamllImageUrl,
  });

  factory MediaDetails.fromJson(Map<String, dynamic> json) {
    return MediaDetails(
      mediaIsActive: json['mediaIsActive'] ?? false,
      mediaType: json['mediaType'] ?? "",
      mediaTitle: json['mediaTitle'] ?? "",
      mediaAlternativeText: json['mediaAlternativeText'],
      mediaDescribtion: json['mediaDescribtion'],
      mediaXLargImageUrl: json['mediaxLargImageUrl'] ?? "",
      mediaLargImageUrl: json['mediaLargImageUrl'] ?? "",
      mediaMediumImageUrl: json['mediaMediumImageUrl'] ?? "",
      mediaSamllImageUrl: json['mediaSamllImageUrl'] ?? "",
    );
  }
}
