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
            ? "homePage/getCarByBrand"
            : 'homePage/getCarByBrandType',
        body: carBrandId != null
            ? {
                "brand": carBrandId,
              }
            : null,
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
