import 'package:dio/dio.dart';

import '../dio_helper.dart';

class CitiesDistrictsServices {
  Future<Response> getActiveCities() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'homePage/getActiveCities',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getDistrictsByCity({
    required String cityId,
  }) async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'homePage/getActiveDistrictsByCityId?districtCityId=$cityId',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
