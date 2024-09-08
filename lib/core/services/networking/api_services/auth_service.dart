import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:turbo/core/services/networking/api_services/car_service.dart';
import 'package:turbo/main_paths.dart';


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
    required String customerNationalId,
    required String customerNationalIDExpiryDate,
    required String? customerDriverLicenseNumber,
    required String? customerDriverLicenseNumberExpiryDate,
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
            "customerNationalId": customerNationalId,
            "customerNationalIDExpiryDate": customerNationalIDExpiryDate,
            "customerDriverLicenseNumber":
                customerDriverLicenseNumber ?? customerNationalId,
            if (customerDriverLicenseNumberExpiryDate != null)
              "customerDriverLicenseNumberExpiryDate":
                  customerDriverLicenseNumberExpiryDate,
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
          token: customerToken,
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

  Future<Response> forgetPassword(String email) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'customer/forgetPassword',
          body: {
            "email": email,
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

   Future<Response> checkOTP(String email, String otp) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'customer/checkOTP',
          body: {
            "email": email,
            "OTP": otp
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> changePassword(String id, String newPassword) async {
    try {
      Response response = await DioHelper.postData(
          endpoint: 'customer/changePassword',
          body: {
            "customer": {
              "id": id,
              "newPassword": newPassword
            }
          });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<Response> editCustomer(String? customerName, String? customerAddress, File? image) async {
    Response response;
    try {
      if(image != null) {
        Map<String, String> requestBody = {
          if(customerName != null) 
            "customerDisplayName": customerName,
          if(customerAddress != null)
            "customerAddress": customerAddress
        };
        String jsonData = json.encode(requestBody);

        FormData formData = FormData();
        formData.fields.add(MapEntry('customer', jsonData));
        formData.files.add(
              MapEntry(
                'files',
                await MultipartFile.fromFile(
                  image.path,
                  filename: getFileName(image.path),
                ),
              ),
            );
        response = await DioHelper.postData(
          endpoint: 'customer/editCustomer',
          formData:formData, 
          body: {}
        );
        return response;
      } else {
        response = await DioHelper.postData(
            endpoint: 'customer/editCustomer',
            body: {
              "customer": {
                if(customerName != null)
                  "customerDisplayName": customerName,
                if(customerAddress != null)
                  "customerAddress": customerAddress
              },
            });
      }
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> deleteCustomer() async {
    try {
      Response response = await DioHelper.postData(
        endpoint: 'customer/editCustomer',
        body: {
          "customer":{
              "customerIsActive":false
          }
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<Response> resetCustomer(String customerEmail) async {
    try {
      Response response = await DioHelper.postData(
        endpoint: 'customer/resetCustomer',
        body: {
          "customer":{
            "customerEmail":customerEmail
          }
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}


