import 'package:dio/dio.dart';

import '../dio_helper.dart';

class AuthServices {
  Future<Response> signupInfoStep({
    required String customerName,
    required String customerEmail,
    required String customerAddress,
    required String customerTelephone,
    required String customerPassword,
    required String customerCountry,
    required String customerCountryCode,
    required int customerType,
    required String fcmToken,
  }) async {
    try {
      Response response = await DioHelper.postData(
        endpoint: 'customer/addCustomer',
        body: {
          "customer": {
            "customerName": customerName,
            "customerEmail": customerEmail,
            "customerAddress": customerAddress,
            "customerTelephone": customerTelephone,
            "customerPassword": customerPassword,
            "customerCountry": customerCountry,
            "customerCountryCode": customerCountryCode,
            "customerType": customerType, // 0=> saudi , 1=> other
            "customerUserToken": fcmToken,
          }
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
