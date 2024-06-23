import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo/core/services/networking/api_services/car_services.dart';
import 'package:turbo/models/car_brand_model.dart';
import 'package:turbo/models/car_details_model.dart';
import 'package:turbo/models/get_cars_by_brands.dart';

class CarRepository {
  final CarServices _carServices;
  CarRepository(this._carServices);

  List<CarBrand> carBrands = [];

  Future<Either<String, List<CarBrand>>> getCarBrands() async {
    try {
      final response = await _carServices.getCarBrands();
      if (response.statusCode == 200 && response.data['status']) {
        carBrands = (response.data['data'] as List).isNotEmpty
            ? (response.data['data'] as List)
                .map((brand) => CarBrand.fromJson(brand))
                .toList()
            : <CarBrand>[];
        return Right(carBrands);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCarBrands Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, Map<String, List<Car>>>> getCarsByBrand(
      {String? brandId}) async {
    try {
      final response = await _carServices.getCarsByBrand(carBrandId: brandId);
      if (response.statusCode == 200 && response.data['status']) {
        Map<String, List<Car>> cars = {};
        if ((response.data as Map).containsKey("cars")) {
          cars = GetCarsByBrandsResponse.fromJson(response.data).cars.carTypes;
        }

        return Right(cars);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCarsByBrand Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, CarDetailsData>> getCarDetails(String carId) async {
    try {
      final response = await _carServices.getCarDetails(carId);
      if (response.statusCode == 200 && response.data['status']) {
        return Right(CarDetailsModel.fromJson(response.data).data);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCarDetails Error -- $e');
      return Left(e.toString());
    }
  }
}
