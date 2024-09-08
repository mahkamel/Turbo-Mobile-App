import 'package:dartz/dartz.dart';
import 'package:turbo/core/services/local/token_service.dart';
import 'package:turbo/core/services/networking/api_services/payment_service.dart';

import '../../../../models/saved_card.dart';

class PaymentRepository {
  final PaymentService _paymentService;
  List<SavedCard> savedPaymentCards = [];
  PaymentRepository(this._paymentService);
  SavedCard? defaultCard;

  Future<Either<String, String>> carRequestPayment({
    required String requestId,
    required num paymentAmount,
    required String visaCardName,
    required String visaCardNumber,
    required String visaCardExpiryMonth,
    required String visaCardExpiryYear,
    required bool isToSave,
    required String billingCustomerName,
    required String billingPostalCode,
    required String billingAddress,
    required String billingVisaLastNo,
    String? savedCardId,
  }) async {
    try {
      final response = await _paymentService.addPayment(
        isToSave: isToSave,
        visaId: savedCardId,
        visaCardNumber: visaCardNumber,
        visaCardExpiryMonth: visaCardExpiryMonth,
        visaCardExpiryYear: visaCardExpiryYear,
        visaCardName: visaCardName,
        carRequestId: requestId,
        paymentAmount: paymentAmount,
        billingCustomerName: billingCustomerName,
        billingAddress: billingAddress,
        billingPostalCode: billingPostalCode,
        billingVisaLastNo: billingVisaLastNo,
      );
      if (response.statusCode == 200) {
        if (response.data['status']) {
          return const Right("Paid");
        } else {
          return Left(response.data['message']);
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<SavedCard>>> getSavedPaymentMethods() async {
    try {
      final response = await _paymentService.getSavedPaymentMethods(
        userToken: UserTokenService.currentUserToken,
      );
      if (response.statusCode == 200) {
        if (response.data['status']) {
          if (response.data['data'] is List) {
            savedPaymentCards = (response.data['data'] as List)
                .map((e) => SavedCard.fromJson(e))
                .toList();
            if (savedPaymentCards.any(
              (element) => element.isCardDefault,
            )) {
              defaultCard = savedPaymentCards.singleWhere(
                (element) => element.isCardDefault,
              );
            }
          } else {
            savedPaymentCards = [];
          }
          return Right(savedPaymentCards);
        } else {
          return Left(response.data['message']);
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> deleteSavedPaymentMethods(String cardId) async {
    try {
      final response = await _paymentService.deleteSavedPaymentMethods(
        userToken: UserTokenService.currentUserToken,
        cardId: cardId,
      );
      if (response.statusCode == 200) {
        if (response.data['status']) {
          return const Right(true);
        } else {
          return Left(response.data['message']);
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> addNewCard(
      {required String visaCardName,
      required String visaCardNumber,
      required String visaCardExpiryMonth,
      required String visaCardExpiryYear,
      required String visaCardType}) async {
    try {
      final response = await _paymentService.addNewPaymentMethod(
          userToken: UserTokenService.currentUserToken,
          visaCardName: visaCardName,
          visaCardNumber: visaCardNumber,
          visaCardExpiryMonth: visaCardExpiryMonth,
          visaCardExpiryYear: visaCardExpiryYear,
          visaCardType: visaCardType);
      if (response.statusCode == 200) {
        if (response.data['status']) {
          return const Right(true);
        } else {
          return Left(response.data['message']);
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> setDefaultCard(String cardId) async {
    try {
      final response = await _paymentService.setDefaultCard(cardId: cardId);
      if (response.data['status'] == false) {
        return Left(response.data['message']);
      } else {
        return Right(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> editPaymentCard(
    String cardId,
    String? cardHolderName,
    String? cardExpiryMonth,
    String? cardExpiryYear,
  ) async {
    try {
      final response = await _paymentService.editPaymentMethod(
          cardId: cardId,
          cardHolderName: cardHolderName,
          cardExpiryMonth: cardExpiryMonth,
          cardExpiryYear: cardExpiryYear);
      if (response.data['statuse'] == false) {
        return Left(response.data['message']);
      } else {
        return Right(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  void init() {
    if (UserTokenService.currentUserToken.isNotEmpty) {
      getSavedPaymentMethods();
    }
  }
}
