import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../dio_helper.dart';

class CarServices {
  Future<Response> getCarTypes() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'homePage/getActiveTypes',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getCarBrands() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'homePage/getActiveBrands',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getCarsByBrand({String? carBrandId}) async {
    try {
      Response response = await DioHelper.getData(
        endpoint: carBrandId != null
            ? "homePage/getCarByBrand?brand=$carBrandId"
            : 'homePage/getCarByBrandType',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getCarDetails(String carId) async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'homePage/getCarDetails?carId=$carId',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> carsFilter({
    required List<String> carYears,
    required List<String> carTypes,
    required List<String> carBrands,
    required bool isWithUnlimited,
  }) async {
    try {
      Map<String, dynamic> filterBody = {};

      if (carYears.isNotEmpty) {
        filterBody.addAll({
          "carYear": carYears,
        });
      }
      if (carTypes.isNotEmpty) {
        filterBody.addAll({
          "carType": carTypes,
        });
      }
      if (carBrands.isNotEmpty) {
        filterBody.addAll({
          "carBrand": carBrands,
        });
      }
      if (isWithUnlimited) {
        filterBody.addAll({
          "carLimitedKiloMeters": isWithUnlimited,
        });
      }

      if (carYears.isEmpty &&
          carTypes.isEmpty &&
          carBrands.isEmpty &&
          !isWithUnlimited) {
        filterBody.addAll({
          "carIsActive": true,
        });
      }
      Response response = await DioHelper.postData(
        endpoint: 'search/getCarByFilter',
        body: {
          "car": filterBody,
        },
      );
      return response;
    } catch (e) {
      debugPrint("ssssssss $e");
      throw e.toString();
    }
  }
}
