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
    required bool isWithUnlimited,
    required String branchId,
    int? priceFrom,
    int? priceTo,
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
      if (isWithUnlimited) {
        filterBody.addAll({
          "carLimitedKiloMeters": isWithUnlimited,
        });
      }
      if (priceFrom != null) {
        filterBody.addAll({
          "priceRange": {
            "from": priceFrom,
            if (priceTo != null) "to": priceTo,
          },
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
    required String requestToken,
    required List<File> files,
    required List<File> secondFiles,
  }) async {
    try {
      Map<String, dynamic> body = {
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
        "requestPrice": requestPrice,
        "requestToken": requestToken,
      };
      String jsonData = json.encode(body);
      FormData carRequestForm = FormData();
      carRequestForm.fields.add(MapEntry("carRequest", jsonData));
      if (files.isNotEmpty) {
        print("filessss num ${files.length}");
        for (int i = 0; i < files.length; i++) {
          final String path = files[i].path;
          carRequestForm.files.add(
            MapEntry(
              "files",
              await MultipartFile.fromFile(
                path,
                filename: getFileName(path),
              ),
            ),
          );
        }
        for (int i = 0; i < secondFiles.length; i++) {
          final String path = secondFiles[i].path;
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
      }

      Response response = await DioHelper.postData(
        endpoint: 'car/addCarRequest',
        formData: carRequestForm,
        userToken: userToken,
        body: {},
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
