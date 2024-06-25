import 'dart:convert';

import 'package:bson/bson.dart';
import 'package:dio/dio.dart';
// import 'package:hex/hex.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:objectid/objectid.dart' hide ObjectId;
// import 'package:string_to_hex/string_to_hex.dart';

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

      // if (carYears.isNotEmpty) {
      //   if (carYears.length == 1) {
      //     filterBody.addAll({
      //       "carYear": carYears[0],
      //     });
      //   } else {
      //     filterBody.addAll({
      //       "carYear": {
      //         "\$in": carYears,
      //       }
      //     });
      //   }
      // }

      // if (carTypes.isNotEmpty) {
      //   if (carTypes.length == 1) {
      //     try {
      //
      //       // ObjectId objec = ObjectId.fromHexString(carTypes[0]);
      //       // String encodedId = objec.toHexString(); // Get the string representation
      //
      //       // Map<String, dynamic> ob = {"objectId": objec};
      //       print("0--------- ${carTypes[0]}");
      //       // print("xxxxxxxx ${objec.runtimeType} -- ${objec}");
      //       filterBody.add({
      //         "carType": ca,
      //       });
      //     } catch (e) {
      //       print("sssdddddss $e");
      //     }
      //   } else {
      //     List<ObjectId> objectss = [];
      //     for (var i in carTypes) {
      //       objectss.add(ObjectId.fromHexString(i));
      //     }
      //     filterBody.add({
      //       "carType": {
      //         "\$in": objectss,
      //       }
      //     });
      //   }
      // }
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
        // if (carBrands.length == 1) {
        //   ObjectId brandObject = ObjectId.fromHexString(carBrands[0]);
        //   filterBody.add({
        //     "carBrand": brandObject,
        //   });
        // } else {
        //   filterBody.add({
        //     "carBrand": {
        //       "\$in": carBrands,
        //     }
        //   });
        // }
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
      print("ssss ${response}");
      return response;
    } catch (e) {
      print("ssssssss $e");
      throw e.toString();
    }
  }
}
