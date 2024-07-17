import 'dart:convert';
import 'dart:io';

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

  Future<Response> getCarBrands(String branchId) async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'homePage/getActiveBrandByBranchId?_id=$branchId',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getActiveCarBrands() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'homePage/getActiveBrands',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getCarsByBrand({
    required String branchId,
    String? carBrandId,
  }) async {
    try {
      Response response = await DioHelper.getData(
        endpoint: carBrandId != null
            ? "homePage/getCarByBrand?brand=$carBrandId&branch=$branchId"
            : 'homePage/getCarByBrandType?branch=$branchId',
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
    // required bool isWithUnlimited,
    required String branchId,
    num? priceFrom,
    num? priceTo,
  }) async {
    try {
      Map<String, dynamic> filterBody = {};
      filterBody.addAll({
        "branchId": branchId,
      });
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
      // if (isWithUnlimited) {
      //   filterBody.addAll({
      //     "carLimitedKiloMeters": isWithUnlimited,
      //   });
      // }
      if (priceFrom != null) {
        filterBody.addAll({
          "priceRange": {
            "from": priceFrom,
            if (priceTo != null) "to": priceTo,
          },
        });
      }

      if (carYears.isEmpty && carTypes.isEmpty && carBrands.isEmpty) {
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

  Future<Response> addCarRequest({
    required String requestCarId,
    required String requestLocation,
    required String requestBranchId,
    required bool isWithRequestDriver,
    required int requestPeriod,
    required String requestFromDate,
    required String requestToDate,
    required String requestCity,
    required String userToken,
    required num requestPrice,
    required num requestPriceVat,
    required num requestDailyCalculationPrice,
    required String requestToken,
    required List<File> nationalIdFiles,
    required List<File> passportFiles,
  }) async {
    try {
      Map<String, dynamic> body = {
        "requestCarId": {
          "carId": requestCarId,
          "from": requestFromDate,
        },
        "requestDailyCalculationPrice": requestDailyCalculationPrice,
        "requestLocation": requestLocation,
        "requestBranch": requestBranchId,
        "requestDriver": isWithRequestDriver,
        "requestPeriod": requestPeriod,
        "requestFrom": requestFromDate,
        "requestTo": requestToDate,
        "requestCity": requestCity,
        "requestTotalPrice": requestPrice,
        "requestToken": requestToken,
        "requestPriceVat": requestPriceVat,
      };
      String jsonData = json.encode(body);
      FormData carRequestForm = FormData();
      carRequestForm.fields.add(MapEntry("carRequest", jsonData));
      if (nationalIdFiles.isNotEmpty) {
        for (int i = 0; i < nationalIdFiles.length; i++) {
          final String path = nationalIdFiles[i].path;
          carRequestForm.files.add(
            MapEntry(
              "nationalId",
              await MultipartFile.fromFile(
                path,
                filename: getFileName(path),
              ),
            ),
          );
        }
        for (int i = 0; i < passportFiles.length; i++) {
          final String path = passportFiles[i].path;
          carRequestForm.files.add(
            MapEntry(
              "passport",
              await MultipartFile.fromFile(
                path,
                filename: getFileName(path),
              ),
            ),
          );
        }
      }

      Response response = await DioHelper.postData(
        endpoint: 'car/addCarRequest',
        formData: carRequestForm,
        body: {},
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> addNewCarRequest({
    required String requestCarId,
    required String requestLocation,
    required String requestBranchId,
    required bool isWithRequestDriver,
    required int requestPeriod,
    required String requestFromDate,
    required String requestToDate,
    required String requestCity,
    required String userToken,
    required num requestPrice,
    required num requestDailyCalculationPrice,
    required num requestPriceVat,
    required String requestToken,
    required List<String> attachmentsIds,
  }) async {
    try {
      Map<String, dynamic> body = {
        "carRequest": {
          "requestCarId": {
            "carId": requestCarId,
            "from": requestFromDate,
          },
          "requestLocation": requestLocation,
          "requestBranch": requestBranchId,
          "requestDriver": isWithRequestDriver,
          "requestPeriod": requestPeriod,
          "requestFrom": requestFromDate,
          "requestTo": requestToDate,
          "requestCity": requestCity,
          "requestTotalPrice": requestPrice,
          "requestDailyCalculationPrice": requestDailyCalculationPrice,
          "requestToken": requestToken,
          "attachmentsId": attachmentsIds,
          "requestPriceVat": requestPriceVat,
        }
      };
      Response response = await DioHelper.postData(
        endpoint: 'car/addNewCarRequest',
        body: body,
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}

String getFileName(String filePath) {
  return filePath.split('/').last;
}
