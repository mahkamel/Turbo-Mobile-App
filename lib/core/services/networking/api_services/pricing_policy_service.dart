import 'package:dio/dio.dart';

import '../dio_helper.dart';

class PricingPolicyService {
  Future<Response> getPricingVat() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'pricingPolicy/getPricingVat',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getAllPricingPolicyWithoutVat() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'pricingPolicy/getAllPricingPolicyWithoutVat',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
