import 'package:dio/dio.dart';

import '../dio_helper.dart';

class AuthServices {
  Future<Response> customerLogin({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await DioHelper.postData(
        endpoint: 'customer/customerLogin',
        body: {
          "UserOfCustomer_Email": email,
          "password": password,
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> checkUserExistence({
    required String email,
    required String phoneNumber,
  }) async {
    try {
      Response response = await DioHelper.postData(
        endpoint: 'customer/checkCustomerIsExits',
        body: {
          "customer": {
            "customerEmail": email,
            "customerTelephone": phoneNumber,
          }
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> refreshCustomerData() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'customer/refreshCustomerData',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

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

  Future<Response> getNotifications() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'notification/getNotifications',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> setNotificationsToken(
      String customerToken, String token) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'customer/setTokenForCustomer',
          body: {
            "customerToken": customerToken,
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> disableNotificationsToken({
    required String notificationToken,
    required String customerToken,
  }) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'customer/disableTokenForCustomer',
          body: {
            "customerToken": notificationToken,
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> setSeenNotifications() async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'notification/setSeenNotifications', body: {});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> setReadNotification(String notificationId) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'notification/setReadNotification',
          body: {
            "notificationId": notificationId,
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
