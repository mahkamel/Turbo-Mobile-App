import 'package:dartz/dartz.dart';
import 'package:turbo/core/services/networking/api_services/car_services.dart';
import 'package:turbo/models/car_brand_model.dart';

class CarRepository {
  final CarServices _carServices;
  CarRepository(this._carServices);

  List<CarBrand> carBrands = [];

  Future<Either<String, List<CarBrand>>> getCarBrands() async {
    // carBrands.clear();
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
      return Left(e.toString());
    }
  }
}
