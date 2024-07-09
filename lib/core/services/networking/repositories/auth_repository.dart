import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/local/cache_helper.dart';
import 'package:turbo/core/services/local/storage_service.dart';
import 'package:turbo/core/services/networking/api_services/auth_service.dart';
import 'package:turbo/models/attachment.dart';
import 'package:turbo/models/customer_model.dart';

import '../../../../models/notifications_model.dart';
import '../../local/token_service.dart';

class AuthRepository {
  final AuthServices _authServices;
  int selectedCityIndex = 0;
  int selectedBranchIndex = 0;
  String selectedBranchId = "";
  String selectedCityId = "";
  AuthRepository(
    this._authServices,
  );

  CustomerModel customer = CustomerModel.empty();

  void setCustomerData(CustomerModel? cachedCustomer) {
    if (cachedCustomer != null) {
      customer = cachedCustomer;
      UserTokenService.saveUserToken(customer.token);
      UserTokenService.userTokenFirstTime();
    }
  }

  Future<Either<String, CustomerModel>> customerLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authServices.customerLogin(
        email: email,
        password: password,
      );
      if (response.statusCode == 200) {
        if (response.data['status']) {
          return Right(CustomerModel.fromJson(response.data));
        } else {
          return const Left(
              "Invalid login credentials. Please double-check your email and password.");
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> signupInfoStep({
    required String customerName,
    required String customerEmail,
    required String customerAddress,
    required String customerTelephone,
    required String customerPassword,
    required String customerCountry,
    required String customerCountryCode,
    required int customerType,
  }) async {
    try {
      final response = await _authServices.signupInfoStep(
        customerName: customerName,
        customerAddress: customerAddress,
        customerCountry: customerCountry,
        customerCountryCode: customerCountryCode,
        customerEmail: customerEmail,
        customerPassword: customerPassword,
        customerTelephone: customerTelephone,
        customerType: customerType,
        fcmToken: AppConstants.fcmToken,
      );
      if (response.statusCode == 200 && response.data['status']) {
        customer = CustomerModel(
          customerName: customerName,
          customerId: "",
          customerEmail: customerEmail,
          attachments: <Attachment>[],
          token: response.data['token'],
        );
        UserTokenService.saveUserToken(response.data['token']);
        StorageService.saveData(
          "customerData",
          json.encode(customer.toJson()),
        );
        return const Right(true);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<UserNotificationModel>>> getNotifications() async {
    try {
      final response = await _authServices.getNotifications();
      if (response.statusCode == 200) {
        if (response.data['status']) {
          List<UserNotificationModel> notifications =
              (response.data['data'] as List)
                  .map(
                    (e) => UserNotificationModel.fromJson(e),
                  )
                  .toList();
          return Right(notifications);
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

  void setSelectedCityIdToCache(String id) {
    CacheHelper.setData(key: "SelectedCityId", value: id);
  }

  void setSelectedBranchIdToCache(String id) {
    CacheHelper.setData(key: "SelectedBranchId", value: id);
  }
}
