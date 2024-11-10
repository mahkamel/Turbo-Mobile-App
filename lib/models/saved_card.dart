class SavedCard {
  bool visaCardIsActive;
  String id;
  String visaCardName;
  String visaCardNumber;
  String visaCardExpiryMonth;
  String visaCardExpiryYear;
  String visaCardType;
  bool isCardDefault;
  bool isSelected;

  SavedCard({
    required this.visaCardIsActive,
    required this.id,
    required this.visaCardName,
    required this.visaCardNumber,
    this.isSelected = false,
    required this.visaCardExpiryMonth,
    required this.visaCardExpiryYear,
    required this.isCardDefault,
    required this.visaCardType,
  });

  factory SavedCard.fromJson(Map<String, dynamic> json) {
    return SavedCard(
      visaCardIsActive: json['visaCardIsActive'],
      id: json['_id'],
      visaCardType:
          json.containsKey("visaCardType") ? json['visaCardType'] : "",
      visaCardName: json['visaCardName'],
      visaCardNumber: json['visaCardNumber'],
      visaCardExpiryMonth: json['visaCardExpiryMonth'],
      visaCardExpiryYear: json['visaCardExpiryYear'],
      isCardDefault: json['visaCardIsDefault'],
    );
  }
}
