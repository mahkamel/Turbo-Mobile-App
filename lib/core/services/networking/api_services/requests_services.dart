import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../dio_helper.dart';
import 'car_service.dart';

class RequestsService {
  Future<Response> getAllRequests() async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'car/getAllRequests',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getStatusByRequestId(String requestId) async {
    try {
      Response response = await DioHelper.getData(
        endpoint: 'car/getStatusByRequestId?id=$requestId',
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> editRequestBody({
    required String requestId,
    String? requestLocation,
    bool? requestDriver,
    int? requestPeriod,
    DateTime? requestForm,
    DateTime? requestTo,
    num? requestPrice,
  }) async {
    try {
      Response response = await DioHelper.postData(
        endpoint: 'car/editCarRequest',
        body: {
          "carRequest": {
            "requestId": requestId,
            if (requestLocation != null) "requestLocation": requestLocation,
            if (requestDriver != null) "requestDriver": requestDriver,
            if (requestPeriod != null) "requestPeriod": requestPeriod,
            if (requestForm != null)
              "requestFrom": requestForm.toIso8601String(),
            if (requestTo != null) "requestTo": requestTo.toIso8601String(),
            if (requestPrice != null) "requestPrice": requestPrice,
          }
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> editRequestFile({
    required String fileType,
    required String attachmentId,
    required String oldPathFiles,
    required File newFile,
  }) async {
    try {
      Map<String, dynamic> body = {
        "attachmentId": attachmentId,
        "oldPathFiles": oldPathFiles,
      };
      String jsonData = json.encode(body);
      FormData editCarRequestForm = FormData();
      editCarRequestForm.fields.add(MapEntry("carRequest", jsonData));

      editCarRequestForm.files.add(
        MapEntry(
          fileType,
          await MultipartFile.fromFile(
            newFile.path,
            filename: getFileName(newFile.path),
          ),
        ),
      );

      Response response = await DioHelper.postData(
        endpoint: 'car/editCarRequest',
        formData: editCarRequestForm,
        body: {},
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> sendPendingRequest(String requestId) async {
    try {
      Response response = await DioHelper.postData(
        endpoint: 'car/sendPendingRequest',
        body: {
          "pendingRequest": {
            "requestId": requestId,
          },
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
