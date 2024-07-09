import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/networking/api_services/car_service.dart';
import 'package:turbo/models/attachment.dart';
import 'package:turbo/models/car_brand_model.dart';
import 'package:turbo/models/car_details_model.dart';
import 'package:turbo/models/car_type_model.dart';
import 'package:turbo/models/get_cars_by_brands.dart';
import 'package:turbo/models/request_model.dart';

import '../../../../models/request_status_model.dart';
import '../api_services/pricing_policy_service.dart';
import '../api_services/requests_services.dart';

class CarRepository {
  final CarServices _carServices;
  final PricingPolicyService _pricingPolicyService;
  final RequestsService _requestsService;
  CarRepository(
    this._carServices,
    this._pricingPolicyService,
    this._requestsService,
  );

  List<CarBrand> carBrands = [];
  List<CarType> carTypes = [];
  Map<String, List<Car>> filteredCars = {};

  Future<Either<String, List<CarBrand>>> getCarBrands(String branchId) async {
    try {
      final response = await _carServices.getCarBrands(branchId);
      if (response.statusCode == 200 && response.data['status']) {
        List<CarBrand> carBrands = (response.data['data'] as List).isNotEmpty
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

  Future<Either<String, List<CarBrand>>> getActiveBrands() async {
    try {
      final response = await _carServices.getActiveCarBrands();
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

  Future<Either<String, Map<String, List<Car>>>> getCarsByBrand({
    required String branchId,
    String? brandId,
  }) async {
    try {
      final response = await _carServices.getCarsByBrand(
        branchId: branchId,
        carBrandId: brandId,
      );
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

  Future<Either<String, num>> getVat() async {
    try {
      final response = await _pricingPolicyService.getPricingVat();
      if (response.statusCode == 200 && response.data['status']) {
        AppConstants.vat = response.data['data'][0]['pricingPolicyValue'];

        return Right(AppConstants.vat);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getVat Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, num>> getDriverFees() async {
    try {
      final response =
          await _pricingPolicyService.getAllPricingPolicyWithoutVat();
      if (response.statusCode == 200 && response.data['status']) {
        AppConstants.driverFees =
            response.data['data'][0]['pricingPolicyValue'];
        return Right(AppConstants.driverFees);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getVat Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, Map<String, List<Car>>>> carsFilter({
    required List<String> carYears,
    required List<String> carTypes,
    required List<String> carBrands,
    required bool isWithUnlimited,
    required String branchId,
    int? priceFrom,
    int? priceTo,
  }) async {
    try {
      final response = await _carServices.carsFilter(
        carYears: carYears,
        carTypes: carTypes,
        carBrands: carBrands,
        isWithUnlimited: isWithUnlimited,
        branchId: branchId,
        priceFrom: priceFrom,
        priceTo: priceTo,
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

  Future<Either<String, String>> addCarRequest({
    required String requestCarId,
    required String requestLocation,
    required String requestBranchId,
    required bool isWithRequestDriver,
    required int requestPeriod,
    required String requestFromDate,
    required String requestToDate,
    required String requestCity,
    required String userToken,
    required num requestPrice,
    required List<File> nationalId,
    required List<File> passport,
  }) async {
    try {
      final response = await _carServices.addCarRequest(
        userToken: userToken,
        isWithRequestDriver: isWithRequestDriver,
        requestCarId: requestCarId,
        requestCity: requestCity,
        requestBranchId: requestBranchId,
        requestFromDate: requestFromDate,
        requestToDate: requestToDate,
        requestLocation: requestLocation,
        requestPeriod: requestPeriod,
        requestPrice: requestPrice,
        requestToken: AppConstants.fcmToken,
        nationalIdFiles: nationalId,
        passportFiles: passport,
      );
      if (response.statusCode == 200 && response.data['status']) {
        String requestId = response.data['requestId'];
        return Right(requestId);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('getCarsByBrand Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, List<RequestModel>>> getAllRequests() async {
    try {
      final response = await _requestsService.getAllRequests();
      if (response.statusCode == 200 && response.data['status']) {
        List<RequestModel> allRequests = (response.data['data'] as List)
            .map(
              (e) => RequestModel.fromJson(e),
            )
            .toList();
        return Right(allRequests);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, RequestStatusModel>> getStatusByRequestId(
      String requestId) async {
    try {
      final response = await _requestsService.getStatusByRequestId(requestId);
      if (response.statusCode == 200 && response.data['status']) {
        return Right(RequestStatusModel.fromJson(response.data['data']));
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> editCarRequest({
    required String requestId,
    String? requestLocation,
    bool? requestDriver,
    int? requestPeriod,
    DateTime? requestForm,
    DateTime? requestTo,
    num? requestPrice,
  }) async {
    try {
      final response = await _requestsService.editRequestBody(
        requestId: requestId,
        requestTo: requestTo,
        requestForm: requestForm,
        requestPrice: requestPrice,
        requestPeriod: requestPeriod,
        requestLocation: requestLocation,
        requestDriver: requestDriver,
      );
      if (response.statusCode == 200 && response.data['status']) {
        return const Right("Your data has been saved");
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('editRequestBody Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, Attachment>> editRequestFile({
    required String requestId,
    required String fileType,
    required String attachmentId,
    required String oldPathFiles,
    required File newFile,
  }) async {
    try {
      final response = await _requestsService.editRequestFile(
        requestId: requestId,
        fileType: fileType,
        attachmentId: attachmentId,
        oldPathFiles: oldPathFiles,
        newFile: newFile,
      );
      if (response.statusCode == 200 && response.data['status']) {
        return Right(Attachment.fromJson(response.data['data']));
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('editRequestFile Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> sendPendingRequest(String requestId) async {
    try {
      final response = await _requestsService.sendPendingRequest(requestId);
      if (response.statusCode == 200 && response.data['status']) {
        return const Right(true);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
