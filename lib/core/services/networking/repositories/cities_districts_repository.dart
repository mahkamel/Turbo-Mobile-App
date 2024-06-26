import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:turbo/core/services/networking/api_services/cities_districts_services.dart';
import 'package:turbo/models/city_model.dart';
import 'package:turbo/models/district_model.dart';

class CitiesDistrictsRepository {
  final CitiesDistrictsServices _citiesDistrictsServices;

  CitiesDistrictsRepository(this._citiesDistrictsServices);

  List<City> cities = [];

  Future<Either<String, List<City>>> getCities() async {
    try {
      final response = await _citiesDistrictsServices.getActiveCities();
      if (response.statusCode == 200 && response.data['status']) {
        cities = (response.data['data'] as List).isNotEmpty
            ? (response.data['data'] as List)
                .map((type) => City.fromJson(type))
                .toList()
            : <City>[];
        return Right(cities);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCities Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, List<District>>> getDistrictBasedOnCity(
      String cityId) async {
    try {
      final response =
          await _citiesDistrictsServices.getDistrictsByCity(cityId: cityId);
      if (response.statusCode == 200 && response.data['status']) {
        List<District> districts = (response.data['data'] as List).isNotEmpty
            ? (response.data['data'] as List)
                .map((type) => District.fromJson(type))
                .toList()
            : <District>[];
        return Right(districts);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCities Error -- $e');
      return Left(e.toString());
    }
  }
}
