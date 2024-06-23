import 'package:dio/dio.dart';

import '../dio_helper.dart';

class CarServices {
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
}
