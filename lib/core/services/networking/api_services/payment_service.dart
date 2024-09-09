import 'package:dio/dio.dart';

import '../../../helpers/app_regex.dart';
import '../dio_helper.dart';

class PaymentService {
  Future<Response> addPayment({
    String? visaId,
    required String carRequestId,
    required num paymentAmount,
    required String visaCardName,
    required String visaCardNumber,
    required String visaCardExpiryMonth,
    required String visaCardExpiryYear,
    required String billingCustomerName,
    required String billingPostalCode,
    required String billingAddress,
    required String billingVisaLastNo,
    required bool isToSave,
  }) async {
    Map<String, dynamic> paymentBody = {};
    if (visaId != null) {
      final savedVisaId = <String, dynamic>{
        "visaCard": {
          "id": visaId,
        }
      };
      paymentBody.addEntries(savedVisaId.entries);
    } else {
      final visa = <String, Map<String, dynamic>>{
        "visaCard": {
          "IsSaved": isToSave,
          "visaCardName": visaCardName,
          "visaCardNumber": visaCardNumber,
          "visaCardExpiryMonth": visaCardExpiryMonth,
          "visaCardExpiryYear": visaCardExpiryYear,
          "visaCardType": AppRegex.detectCardType(visaCardNumber),
        }
      };
      paymentBody.addEntries(visa.entries);
    }
    final billing = <String, Map<String, String>>{
      "billing": {
        "billingCustomerName": billingCustomerName,
        "billingPostalCode": billingPostalCode,
        "billingAddress": billingAddress,
        "billingVisaLastNo": billingVisaLastNo
      },
    };
    paymentBody.addEntries(billing.entries);

    final payment = <String, Map<String, dynamic>>{
      "payment": {
        "carRequestId": carRequestId,
        "paymentAmount": paymentAmount,
        "billingCustomerName": billingCustomerName,
        "billingPostalCode": billingPostalCode,
        "billingAddress": billingAddress,
        "billingVisaLastNo": billingVisaLastNo,
      },
    };
    paymentBody.addEntries(payment.entries);

    try {
      Response response = await DioHelper.postData(
        endpoint: 'payment/addPaymentCarRequest',
        body: paymentBody,
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getSavedPaymentMethods({
    required String userToken,
  }) async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'visacard/getPaymentMethods',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> deleteSavedPaymentMethods({
    required String userToken,
    required String cardId,
  }) async {
    try {
      Response response =
          await DioHelper.postData(endpoint: 'visacard/deleteVisaCard', body: {
        "visaCard": {
          "_id": cardId,
        }
      });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> addNewPaymentMethod(
      {required String userToken,
      required String visaCardName,
      required String visaCardNumber,
      required String visaCardExpiryMonth,
      required String visaCardExpiryYear,
      required String visaCardType}) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'visacard/addPaymentMethod',
          body: {
            "visaCard": {
              "visaCardName": visaCardName,
              "visaCardNumber": visaCardNumber,
              "visaCardExpiryMonth": visaCardExpiryMonth,
              "visaCardExpiryYear": visaCardExpiryYear,
              "visaCardType": visaCardType,
            }
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> setDefaultCard({
    required String cardId,
  }) async {
    try {
      Response response = await DioHelper.postData(
        endpoint: 'visacard/editPaymentMethod',
        body: {
          "visaCard": {
            "visaCardIsDefault": true,
            "id": cardId,
          }
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> editPaymentMethod({
    required String cardId,
    String? cardHolderName,
    String? cardExpiryMonth,
    String? cardExpiryYear,
  }) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: "visacard/editPaymentMethod",
          body: {
            "visaCard": {
              "id": cardId,
              if (cardHolderName != null) "visaCardName": cardHolderName,
              if (cardExpiryMonth != null)
                "visaCardExpiryMonth": cardExpiryMonth,
              if (cardExpiryYear != null) "visaCardExpiryYear": cardExpiryYear,
            }
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
