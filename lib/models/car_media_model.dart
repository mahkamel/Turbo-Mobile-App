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
  final String mediaXLargImageUrl;
  final String mediaLargImageUrl;
  final String mediaMediumImageUrl;
  final String mediaSamllImageUrl;

  MediaDetails({

    required this.mediaXLargImageUrl,
    required this.mediaLargImageUrl,
    required this.mediaMediumImageUrl,
    required this.mediaSamllImageUrl,
  });

  factory MediaDetails.fromJson(Map<String, dynamic> json) {
    return MediaDetails(
      mediaXLargImageUrl: json['mediaxLargImageUrl'] ?? "",
      mediaLargImageUrl: json['mediaLargImageUrl'] ?? "",
      mediaMediumImageUrl: json['mediaMediumImageUrl'] ?? "",
      mediaSamllImageUrl: json['mediaSamllImageUrl'] ?? "",
    );
  }
}
