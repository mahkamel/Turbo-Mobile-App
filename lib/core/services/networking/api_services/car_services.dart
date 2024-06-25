import 'package:dio/dio.dart';

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
      List<Map<String, dynamic>> filterBody = [];

      if (carYears.isNotEmpty) {
        if (carYears.length == 1) {
          filterBody.add({
            "carYear": carYears[0],
          });
        } else {
          filterBody.add({
            "carYear": {
              "\$in": carYears,
            }
          });
        }
      }

      if (carTypes.isNotEmpty) {
        if (carTypes.length == 1) {
          filterBody.add({
            "carType": carTypes[0],
          });
        } else {
          filterBody.add({
            "carType": {
              "\$in": carTypes,
            }
          });
        }
      }
      if (carBrands.isNotEmpty) {
        if (carBrands.length == 1) {
          filterBody.add({
            "carBrand": carBrands[0],
          });
        } else {
          filterBody.add({
            "carBrand": {
              "\$in": carBrands,
            }
          });
        }
      }
      if (isWithUnlimited) {
        filterBody.add({
          "carLimitedKiloMeters": isWithUnlimited,
        });
      }

      if (carYears.isEmpty &&
          carTypes.isEmpty &&
          carBrands.isEmpty &&
          !isWithUnlimited) {
        filterBody.add({
          "carIsActive": true,
        });
      }

      Response response = await DioHelper.postData(
        endpoint: 'search/getCarByFilter',
        body: {
          "filter": filterBody,
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
