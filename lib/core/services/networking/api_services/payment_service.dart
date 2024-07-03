import 'package:dio/dio.dart';

import '../../local/token_service.dart';
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
    required String billingFirstName,
    required String billingLastName,
    required String billingCity,
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
        }
      };
      paymentBody.addEntries(visa.entries);
    }
    final billing = <String, Map<String, String>>{
      "billing": {
        "billingFirstName": billingFirstName,
        "billingLastName": billingLastName,
        "billingCity": billingCity,
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
        "billingFirstName": billingFirstName,
        "billingLastName": billingLastName,
        "billingCity": billingCity,
        "billingPostalCode": billingPostalCode,
        "billingAddress": billingAddress,
        "billingVisaLastNo": billingVisaLastNo
      },
    };
    paymentBody.addEntries(payment.entries);

    try {
      Response response = await DioHelper.postData(
        endpoint: 'payment/addPaymentCarRequest',
        userToken: UserTokenService.currentUserToken,
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
        userToken: userToken,
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
      Response response = await DioHelper.postData(
          endpoint: 'visacard/deleteVisaCard',
          userToken: userToken,
          body: {
            "visaCard": {
              "_id": cardId,
            }
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> addNewPaymentMethod({
    required String userToken,
    required String visaCardName,
    required String visaCardNumber,
    required String visaCardExpiryMonth,
    required String visaCardExpiryYear,
  }) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'visacard/addPaymentMethod',
          userToken: userToken,
          body: {
            "visaCard": {
              "visaCardName": visaCardName,
              "visaCardNumber": visaCardNumber,
              "visaCardExpiryMonth": visaCardExpiryMonth,
              "visaCardExpiryYear": visaCardExpiryYear,
            }
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
