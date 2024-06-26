import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo/core/services/networking/api_services/car_services.dart';
import 'package:turbo/models/car_brand_model.dart';
import 'package:turbo/models/car_details_model.dart';
import 'package:turbo/models/car_type_model.dart';
import 'package:turbo/models/get_cars_by_brands.dart';

class CarRepository {
  final CarServices _carServices;
  CarRepository(this._carServices);

  List<CarBrand> carBrands = [];
  List<CarType> carTypes = [];
  Map<String, List<Car>> filteredCars = {};

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

  Future<Either<String, List<CarType>>> getCarTypes() async {
    try {
      final response = await _carServices.getCarTypes();
      if (response.statusCode == 200 && response.data['status']) {
        carTypes = (response.data['data'] as List).isNotEmpty
            ? (response.data['data'] as List)
                .map((type) => CarType.fromJson(type))
                .toList()
            : <CarType>[];
        return Right(carTypes);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCarTypes Error -- $e');
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

  Future<Either<String, Map<String, List<Car>>>> carsFilter({
    required List<String> carYears,
    required List<String> carTypes,
    required List<String> carBrands,
    required bool isWithUnlimited,
  }) async {
    try {
      final response = await _carServices.carsFilter(
        carYears: carYears,
        carTypes: carTypes,
        carBrands: carBrands,
        isWithUnlimited: isWithUnlimited,
      );
      if (response.statusCode == 200 && response.data['status']) {
        filteredCars = {};
        if ((response.data as Map).containsKey("cars")) {
          filteredCars =
              GetCarsByBrandsResponse.fromJson(response.data).cars.carTypes;
        }

        return Right(filteredCars);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCarsByBrand Error -- $e');
      return Left(e.toString());
    }
  }
}
