import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/local/cache_helper.dart';
import 'package:turbo/core/services/local/storage_service.dart';
import 'package:turbo/core/services/networking/api_services/auth_service.dart';
import 'package:turbo/models/customer_model.dart';

class AuthRepository {
  final AuthServices _authServices;
  int selectedCityIndex = 0;
  AuthRepository(
    this._authServices,
  );

  CustomerModel customer = CustomerModel.empty();

  void setCustomerData(CustomerModel? cachedCustomer) {
    if (cachedCustomer != null) {
      customer = cachedCustomer;
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
          phoneNumber: customerTelephone,
          customerType: customerType,
          customerEmail: customerEmail,
          customerAddress: customerAddress,
          token: response.data['token'],
        );
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


  void setSelectedCityIdToCache(String id) {
    CacheHelper.setData(key: "SelectedCityId", value: id);
  }
}
