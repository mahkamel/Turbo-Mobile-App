import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo/core/services/networking/api_services/car_services.dart';
import 'package:turbo/models/car_brand_model.dart';
import 'package:turbo/models/get_cars_by_brands.dart';

class CarRepository {
  final CarServices _carServices;
  CarRepository(this._carServices);

  List<CarBrand> carBrands = [];

  Future<Either<String, List<CarBrand>>> getCarBrands() async {
    try {
      final response = await _carServices.getCarBrands();
      if (response.statusCode == 200 && response.data['status']) {
        carBrands = (response.data['data'] as List)
            .map((brand) => CarBrand.fromJson(brand))
            .toList();
        return Right(carBrands);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCarBrands Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, GetCarsByBrandsResponse>> getCarsByBrand() async {
    try {
      final response = await _carServices.getCarsByBrand();
      if (response.statusCode == 200 && response.data['status']) {
        return Right(GetCarsByBrandsResponse.fromJson(response.data));
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCarsByBrand Error -- $e');
      return Left(e.toString());
    }
  }
}
